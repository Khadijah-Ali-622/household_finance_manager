import 'backup_models.dart';

abstract class LocalBackupStore {
  Future<StoredBackup> write({
    required String prefix,
    required String extension,
    required String contents,
    int keep = 5,
  });

  Future<List<StoredBackup>> list(String prefix);

  Future<String> read(StoredBackup item);

  /// Returns false when the platform cannot open a share sheet.
  Future<bool> share(StoredBackup item, {required String mimeType});

  Future<String?> pickTextFile({required List<String> extensions});
}
