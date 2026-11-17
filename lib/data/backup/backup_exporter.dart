import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

import 'backup_models.dart';

/// Turns a [BackupPayload] into versioned JSON, optionally AES-encrypted.
///
/// Encrypted files store `salt (16 bytes) + iv (16 bytes) + ciphertext` as
/// one base64 blob. The password is stretched with PBKDF2-HMAC-SHA256.
/// A forgotten password cannot be recovered.
class BackupExporter {
  const BackupExporter();

  static const fileFormat = 'hfm-backup';
  static const algorithm = 'AES-256-CBC';
  static const kdf = 'PBKDF2-HMAC-SHA256';
  static const iterations = 100000;

  static const forgottenPasswordWarning =
      'If you forget this password, this backup cannot be decrypted. '
      'There is no password reset and no way to recover the file.';

  static const passwordRequiredWarning =
      'This backup is encrypted. Enter the password used when it was created. '
      'If you forget this password, this backup cannot be decrypted. '
      'There is no password reset and no way to recover the file.';

  static const wrongPasswordWarning =
      'Wrong password, or the file is damaged. '
      'If you forgot the password, this backup cannot be opened.';

  String exportToJson(BackupPayload payload, {String? password}) {
    final body = payload.toJson();
    if (password == null || password.isEmpty) {
      return _pretty({
        'format': fileFormat,
        'schemaVersion': BackupPayload.currentSchemaVersion,
        'encrypted': false,
        'payload': body,
      });
    }

    final salt = _randomBytes(16);
    final iv = _randomBytes(16);
    final cipher = _encrypt(jsonEncode(body), password, salt, iv);
    final packed = Uint8List(salt.length + iv.length + cipher.length)
      ..setRange(0, salt.length, salt)
      ..setRange(salt.length, salt.length + iv.length, iv)
      ..setRange(salt.length + iv.length, salt.length + iv.length + cipher.length, cipher);

    return _pretty({
      'format': fileFormat,
      'schemaVersion': BackupPayload.currentSchemaVersion,
      'encrypted': true,
      'algorithm': algorithm,
      'kdf': kdf,
      'iterations': iterations,
      'warning': forgottenPasswordWarning,
      'data': base64Encode(packed),
    });
  }

  BackupPayload importFromJson(String source, {String? password}) {
    final envelope = _decodeEnvelope(source);
    final encrypted = envelope['encrypted'] == true;
    if (!encrypted) {
      final payload = envelope['payload'];
      if (payload is! Map) {
        throw const BackupCorruptException('Backup payload is missing.');
      }
      return BackupPayload.fromJson(Map<String, dynamic>.from(payload));
    }

    if (password == null || password.isEmpty) {
      throw const BackupPasswordException(passwordRequiredWarning);
    }

    final packed = _decodePacked(envelope['data']);
    if (packed.length < 33) {
      throw const BackupCorruptException('Encrypted backup is truncated.');
    }
    final salt = Uint8List.sublistView(packed, 0, 16);
    final iv = Uint8List.sublistView(packed, 16, 32);
    final cipher = Uint8List.sublistView(packed, 32);
    final iterations = _asInt(envelope['iterations']) ?? BackupExporter.iterations;

    late final String plain;
    try {
      plain = _decrypt(cipher, password, salt, iv, iterations);
    } catch (_) {
      throw const BackupPasswordException(wrongPasswordWarning);
    }

    Map<String, dynamic> json;
    try {
      final decoded = jsonDecode(plain);
      if (decoded is! Map) {
        throw const BackupPasswordException(wrongPasswordWarning);
      }
      json = Map<String, dynamic>.from(decoded);
    } on BackupPasswordException {
      rethrow;
    } catch (_) {
      throw const BackupPasswordException(wrongPasswordWarning);
    }
    return BackupPayload.fromJson(json);
  }

  /// True when the file needs a password. Throws if the text is not JSON.
  bool isEncrypted(String source) {
    return _decodeEnvelope(source)['encrypted'] == true;
  }

  Map<String, dynamic> _decodeEnvelope(String source) {
    final trimmed = source.trim();
    if (trimmed.isEmpty) {
      throw const BackupCorruptException('Backup file is empty.');
    }
    Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } catch (_) {
      throw const BackupCorruptException('Backup file is not valid JSON.');
    }
    if (decoded is! Map) {
      throw const BackupCorruptException('Backup file has an unexpected shape.');
    }
    final envelope = Map<String, dynamic>.from(decoded);
    if (envelope.containsKey('wallets') && envelope.containsKey('schemaVersion')) {
      return {
        'format': fileFormat,
        'schemaVersion': envelope['schemaVersion'],
        'encrypted': false,
        'payload': envelope,
      };
    }
    final version = _asInt(envelope['schemaVersion']);
    if (version == null) {
      throw const BackupCorruptException('Backup is missing schemaVersion.');
    }
    if (version > BackupPayload.currentSchemaVersion) {
      throw BackupVersionException(
        'This backup uses schema $version. Update the app before restoring it.',
      );
    }
    if (envelope['format'] != fileFormat) {
      throw const BackupCorruptException('This file is not a finance backup.');
    }
    return envelope;
  }

  Uint8List _encrypt(
    String plain,
    String password,
    Uint8List salt,
    Uint8List iv,
  ) {
    final key = enc.Key(_deriveKey(password, salt, iterations));
    final aes = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return aes.encrypt(plain, iv: enc.IV(iv)).bytes;
  }

  String _decrypt(
    Uint8List cipher,
    String password,
    Uint8List salt,
    Uint8List iv,
    int rounds,
  ) {
    final key = enc.Key(_deriveKey(password, salt, rounds));
    final aes = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return aes.decrypt(enc.Encrypted(cipher), iv: enc.IV(iv));
  }

  Uint8List _deriveKey(String password, Uint8List salt, int rounds) {
    return pbkdf2HmacSha256(
      password: utf8.encode(password),
      salt: salt,
      iterations: rounds,
      keyLength: 32,
    );
  }

  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  Uint8List _decodePacked(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      throw const BackupCorruptException('Encrypted backup data is missing.');
    }
    try {
      return Uint8List.fromList(base64Decode(raw));
    } catch (_) {
      throw const BackupCorruptException('Encrypted backup data is not base64.');
    }
  }

  String _pretty(Map<String, dynamic> json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }
}

/// Top-level so backup encoding can run off the UI isolate.
String encodeBackupJob(Map<String, dynamic> job) {
  final raw = job['payload'];
  if (raw is! Map) {
    throw const BackupCorruptException('Backup payload is missing.');
  }
  final password = job['password'] as String?;
  return const BackupExporter().exportToJson(
    BackupPayload.fromJson(Map<String, dynamic>.from(raw)),
    password: (password == null || password.isEmpty) ? null : password,
  );
}

/// Top-level so backup decoding can run off the UI isolate.
BackupPayload decodeBackupJob(Map<String, dynamic> job) {
  final source = job['json'];
  if (source is! String) {
    throw const BackupCorruptException('Backup file is empty.');
  }
  final password = job['password'] as String?;
  return const BackupExporter().importFromJson(
    source,
    password: (password == null || password.isEmpty) ? null : password,
  );
}

/// PBKDF2-HMAC-SHA256. [keyLength] is in bytes.
Uint8List pbkdf2HmacSha256({
  required List<int> password,
  required List<int> salt,
  required int iterations,
  required int keyLength,
}) {
  if (iterations < 1 || keyLength < 1) {
    throw ArgumentError('PBKDF2 iterations and key length must be positive.');
  }
  final hmac = Hmac(sha256, password);
  final blockCount = (keyLength / 32).ceil();
  final out = BytesBuilder(copy: false);
  for (var block = 1; block <= blockCount; block++) {
    final index = Uint8List(4)..buffer.asByteData().setUint32(0, block);
    var u = Uint8List.fromList(hmac.convert([...salt, ...index]).bytes);
    final mixed = Uint8List.fromList(u);
    for (var round = 1; round < iterations; round++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (var i = 0; i < mixed.length; i++) {
        mixed[i] ^= u[i];
      }
    }
    out.add(mixed);
  }
  final bytes = out.takeBytes();
  if (bytes.length == keyLength) return bytes;
  return Uint8List.sublistView(bytes, 0, keyLength);
}

int? _asInt(Object? raw) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  return null;
}
