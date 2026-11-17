import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'backup_exporter.dart';
import 'backup_models.dart';
import 'backup_repository.dart';
import 'backup_settings.dart';
import 'drive_backup_service.dart';
import 'local_backup_service.dart';

class LocalExportResult {
  const LocalExportResult({required this.file, required this.shared});

  final StoredBackup file;
  final bool shared;
}

/// Ties the database, local files, and Google Drive together.
class BackupCoordinator {
  BackupCoordinator({
    required this.repository,
    required this.settings,
    required this.local,
    required this.drive,
    this.exporter = const BackupExporter(),
  });

  final BackupRepository repository;
  final BackupSettings settings;
  final LocalBackupService local;
  final DriveBackupService drive;
  final BackupExporter exporter;

  Future<void> backupToDrive() async {
    if (!await drive.isSignedIn()) {
      throw const BackupFailure(
        BackupFailureKind.authExpired,
        'Sign in to Google before backing up.',
      );
    }
    final json = await _snapshotJson(await _passwordForNewBackup());
    final name =
        '${DriveBackupService.filePrefix}${_stamp(DateTime.now().toUtc())}.json';
    await drive.upload(json, filename: name);
    await drive.prune();
    try {
      await local.writeExport(json);
    } catch (error, stack) {
      debugPrint('Local copy of Drive backup failed: $error\n$stack');
    }
    await settings.recordBackup(
      DateTime.now().toUtc(),
      LocalBackupService.utf8Size(json),
    );
  }

  Future<LocalExportResult> exportJson() async {
    final json = await _snapshotJson(await _passwordForNewBackup());
    final file = await local.writeExport(json);
    final shared = await local.shareJson(file);
    await settings.recordBackup(DateTime.now().toUtc(), file.sizeBytes);
    return LocalExportResult(file: file, shared: shared);
  }

  Future<LocalExportResult> exportCsv() async {
    final payload = await repository.snapshot();
    final csv = LocalBackupService.transactionsToCsv(payload.transactions);
    final file = await local.writeCsv(csv);
    final shared = await local.shareCsv(file);
    return LocalExportResult(file: file, shared: shared);
  }

  Future<String?> pickJson() => local.pickJsonFile();

  bool fileIsEncrypted(String json) => exporter.isEncrypted(json);

  /// Decrypts first. A bad password does not change local data.
  /// A safety copy is written before Replace or Merge is applied.
  Future<BackupPayload> restoreJson({
    required String json,
    required RestoreMode mode,
    String? password,
  }) async {
    final payload = await _decode(json, password);
    final current = await repository.snapshot();
    final safetyPassword = settings.encryptionEnabled
        ? await settings.readPassword()
        : null;
    final safety = await _encode(current, safetyPassword);
    await local.writeSafetyCopy(safety);
    await repository.restore(payload, mode: mode);
    return payload;
  }

  Future<void> runAutoBackupIfDue() async {
    final interval = settings.frequency.interval;
    if (interval == null || !drive.isConfigured) return;
    final last = settings.lastBackupAt;
    if (last != null && DateTime.now().toUtc().difference(last) < interval) {
      return;
    }
    if (!await drive.isSignedIn()) return;
    await backupToDrive();
  }

  Future<void> enableEncryption(String password) async {
    final trimmed = password.trim();
    if (trimmed.length < 4) {
      throw const BackupPasswordException(
        'Password must be at least 4 characters.',
      );
    }
    await settings.savePassword(trimmed);
    await settings.setEncryptionEnabled(true);
  }

  Future<void> disableEncryption() async {
    await settings.setEncryptionEnabled(false);
    await settings.clearPassword();
  }

  Future<String> _snapshotJson(String? password) async {
    final payload = await repository.snapshot();
    return _encode(payload, password);
  }

  Future<String?> _passwordForNewBackup() async {
    if (!settings.encryptionEnabled) return null;
    final password = await settings.readPassword();
    if (password == null || password.isEmpty) {
      throw const BackupPasswordException(
        BackupExporter.passwordRequiredWarning,
      );
    }
    return password;
  }

  Future<String> _encode(BackupPayload payload, String? password) {
    final job = <String, dynamic>{
      'payload': payload.toJson(),
      'password': password,
    };
    return _offUi(() => encodeBackupJob(job));
  }

  Future<BackupPayload> _decode(String json, String? password) {
    final job = <String, dynamic>{'json': json, 'password': password};
    return _offUi(() => decodeBackupJob(job));
  }

  Future<T> _offUi<T>(T Function() body) async {
    try {
      return await Isolate.run(body);
    } catch (error) {
      if (error is BackupPasswordException ||
          error is BackupCorruptException ||
          error is BackupVersionException) {
        rethrow;
      }
      return body();
    }
  }
}

String _stamp(DateTime utc) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${utc.year}${two(utc.month)}${two(utc.day)}-'
      '${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
}
