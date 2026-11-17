import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import 'backup_models.dart';
import 'drive_client.dart';

/// Google Drive backups stored only in the hidden appDataFolder.
///
/// The sign-in scope list is exactly [BackupPayload.driveAppDataScope].
class DriveBackupService {
  DriveBackupService({GoogleSignIn? signIn}) : _signInOverride = signIn;

  static const filePrefix = 'hfm-backup-';
  static const keepCount = 5;

  /// Pass `--dart-define=GOOGLE_WEB_CLIENT_ID=...` for web sign-in.
  static const webClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  final GoogleSignIn? _signInOverride;
  GoogleSignIn? _signIn;
  bool _unsupported = false;

  bool get isConfigured {
    if (_unsupported) return false;
    if (kIsWeb && webClientId.isEmpty) return false;
    return true;
  }

  GoogleSignIn _client() {
    final override = _signInOverride;
    if (override != null) return override;
    return _signIn ??= GoogleSignIn(
      clientId: kIsWeb ? webClientId : null,
      scopes: const [BackupPayload.driveAppDataScope],
    );
  }

  Future<String?> currentAccountLabel() async {
    if (!isConfigured) return null;
    try {
      final account = await _client().signInSilently(suppressErrors: true);
      if (account == null) return null;
      return _label(account);
    } catch (error) {
      if (_isUnsupported(error)) {
        _unsupported = true;
        return null;
      }
      return null;
    }
  }

  Future<String> signIn() async {
    _ensureConfigured();
    try {
      final account = await _client().signIn();
      if (account == null) {
        throw const BackupFailure(
          BackupFailureKind.cancelled,
          'Google sign-in was cancelled.',
        );
      }
      return _label(account);
    } catch (error) {
      if (error is BackupFailure) rethrow;
      throw _map(error);
    }
  }

  Future<void> signOut() async {
    if (!isConfigured) return;
    try {
      await _client().signOut();
    } catch (error) {
      if (_isUnsupported(error)) {
        _unsupported = true;
        return;
      }
      throw _map(error);
    }
  }

  Future<bool> isSignedIn() async {
    final label = await currentAccountLabel();
    return label != null;
  }

  Future<DriveBackupInfo> upload(String json, {required String filename}) {
    return _withApi((api) async {
      final bytes = utf8.encode(json);
      final created = await api.files.create(
        drive.File()
          ..name = filename
          ..parents = ['appDataFolder']
          ..mimeType = 'application/json',
        uploadMedia: drive.Media(
          Stream<List<int>>.value(bytes),
          bytes.length,
          contentType: 'application/json',
        ),
      );
      final id = created.id;
      if (id == null || id.isEmpty) {
        throw const BackupCorruptException('Drive did not return a file id.');
      }
      return DriveBackupInfo(
        id: id,
        name: created.name ?? filename,
        createdAt: created.createdTime?.toUtc() ?? DateTime.now().toUtc(),
        sizeBytes: int.tryParse(created.size ?? '') ?? bytes.length,
      );
    });
  }

  Future<List<DriveBackupInfo>> listBackups() {
    return _withApi((api) async {
      final listed = await api.files.list(
        spaces: 'appDataFolder',
        q: 'trashed = false',
        orderBy: 'createdTime desc',
        pageSize: 50,
        $fields: 'files(id,name,size,createdTime)',
      );
      final files = listed.files ?? const <drive.File>[];
      final backups = <DriveBackupInfo>[];
      for (final file in files) {
        final name = file.name ?? '';
        final id = file.id;
        if (id == null || !name.startsWith(filePrefix)) continue;
        backups.add(
          DriveBackupInfo(
            id: id,
            name: name,
            createdAt: file.createdTime?.toUtc() ?? DateTime.now().toUtc(),
            sizeBytes: int.tryParse(file.size ?? '') ?? 0,
          ),
        );
      }
      backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (backups.length <= keepCount) return backups;
      return backups.take(keepCount).toList();
    });
  }

  Future<String> download(String fileId) {
    return _withApi((api) async {
      final media = await api.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      );
      if (media is! drive.Media) {
        throw const BackupCorruptException('Drive returned no file contents.');
      }
      final chunks = await media.stream.toList();
      final bytes = chunks.expand((chunk) => chunk).toList();
      try {
        return utf8.decode(bytes);
      } catch (_) {
        throw const BackupCorruptException('Drive backup is not valid text.');
      }
    });
  }

  Future<void> prune({int keep = keepCount}) {
    return _withApi((api) async {
      final listed = await api.files.list(
        spaces: 'appDataFolder',
        q: 'trashed = false',
        orderBy: 'createdTime desc',
        pageSize: 100,
        $fields: 'files(id,name,createdTime)',
      );
      final files = (listed.files ?? const <drive.File>[])
          .where((file) => (file.name ?? '').startsWith(filePrefix))
          .toList();
      files.sort((a, b) {
        final left = a.createdTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.createdTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
      for (final extra in files.skip(keep)) {
        final id = extra.id;
        if (id == null) continue;
        await api.files.delete(id);
      }
    });
  }

  Future<T> _withApi<T>(Future<T> Function(drive.DriveApi api) body) async {
    _ensureConfigured();
    http.Client? client;
    try {
      final account =
          _client().currentUser ??
          await _client().signInSilently(suppressErrors: true);
      if (account == null) {
        throw const BackupFailure(
          BackupFailureKind.authExpired,
          'Google sign-in expired. Sign in again.',
        );
      }
      final auth = await account.authentication;
      final token = auth.accessToken;
      if (token == null || token.isEmpty) {
        throw const BackupFailure(
          BackupFailureKind.authExpired,
          'Google sign-in expired. Sign in again.',
        );
      }
      client = createDriveClient(token);
      return await body(drive.DriveApi(client));
    } catch (error) {
      if (error is BackupFailure || error is BackupCorruptException) rethrow;
      throw _map(error);
    } finally {
      client?.close();
    }
  }

  void _ensureConfigured() {
    if (kIsWeb && webClientId.isEmpty) {
      throw const BackupFailure(
        BackupFailureKind.unavailable,
        'Google Drive sign-in needs a web client ID. Export a local file instead.',
      );
    }
    if (_unsupported) {
      throw const BackupFailure(
        BackupFailureKind.unavailable,
        'Google Drive sign-in is not available on this device. Export a local file instead.',
      );
    }
  }

  String _label(GoogleSignInAccount account) {
    if (account.email.isNotEmpty) return account.email;
    final name = account.displayName;
    if (name != null && name.isNotEmpty) return name;
    return 'Google account';
  }

  bool _isUnsupported(Object error) {
    return error is UnimplementedError || error is UnsupportedError;
  }

  BackupFailure _map(Object error) {
    if (error is BackupFailure) return error;
    if (_isUnsupported(error)) {
      _unsupported = true;
      return const BackupFailure(
        BackupFailureKind.unavailable,
        'Google Drive sign-in is not available on this device.',
      );
    }
    if (error is PlatformException) {
      final text = '${error.code} ${error.message}'.toLowerCase();
      if (text.contains('cancel')) {
        return const BackupFailure(
          BackupFailureKind.cancelled,
          'Google sign-in was cancelled.',
        );
      }
      if (text.contains('network') || text.contains('offline')) {
        return const BackupFailure(
          BackupFailureKind.offline,
          'You appear to be offline.',
        );
      }
    }
    if (error is drive.DetailedApiRequestError) {
      final text = '${error.message}'.toLowerCase();
      if (error.status == 401 ||
          (error.status == 403 && text.contains('auth'))) {
        return const BackupFailure(
          BackupFailureKind.authExpired,
          'Google sign-in expired. Sign in again.',
        );
      }
      if (error.status == 403 || error.status == 429) {
        if (text.contains('quota') ||
            text.contains('storage') ||
            text.contains('rate')) {
          return const BackupFailure(
            BackupFailureKind.quota,
            'Google Drive storage is full.',
          );
        }
        return const BackupFailure(
          BackupFailureKind.authExpired,
          'Google Drive refused this request. Sign in again.',
        );
      }
    }
    final type = error.runtimeType.toString();
    final text = error.toString().toLowerCase();
    if (type == 'SocketException' ||
        type == 'ClientException' ||
        error is http.ClientException ||
        text.contains('failed host lookup') ||
        text.contains('xmlhttprequest') ||
        text.contains('network is unreachable') ||
        text.contains('connection errored')) {
      return const BackupFailure(
        BackupFailureKind.offline,
        'You appear to be offline.',
      );
    }
    return BackupFailure(BackupFailureKind.unavailable, error.toString());
  }
}
