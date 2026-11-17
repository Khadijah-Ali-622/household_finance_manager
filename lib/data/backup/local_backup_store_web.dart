import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_models.dart';
import 'local_backup_store_api.dart';

LocalBackupStore createLocalBackupStore() => WebLocalBackupStore();

/// Browsers have no documents folder. Copies stay in memory for this session
/// and are also offered as a download through the share sheet.
class WebLocalBackupStore implements LocalBackupStore {
  final List<StoredBackup> _items = [];

  @override
  Future<StoredBackup> write({
    required String prefix,
    required String extension,
    required String contents,
    int keep = 5,
  }) async {
    final name = '$prefix${_stamp(DateTime.now().toUtc())}.$extension';
    final item = StoredBackup(
      name: name,
      modified: DateTime.now().toUtc(),
      sizeBytes: utf8.encode(contents).length,
      content: contents,
    );
    _items.insert(0, item);
    final samePrefix = _items.where((file) => file.name.startsWith(prefix));
    if (samePrefix.length > keep) {
      final drop = samePrefix.skip(keep).toSet();
      _items.removeWhere(drop.contains);
    }
    return item;
  }

  @override
  Future<List<StoredBackup>> list(String prefix) async {
    final items = _items.where((file) => file.name.startsWith(prefix)).toList();
    items.sort((a, b) => b.modified.compareTo(a.modified));
    return items;
  }

  @override
  Future<String> read(StoredBackup item) async {
    final content = item.content;
    if (content == null) {
      throw const BackupCorruptException('Backup file is no longer in memory.');
    }
    return content;
  }

  @override
  Future<bool> share(StoredBackup item, {required String mimeType}) async {
    try {
      final content = item.content;
      if (content == null) return false;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              utf8.encode(content),
              mimeType: mimeType,
              name: item.name,
            ),
          ],
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> pickTextFile({required List<String> extensions}) async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    if (picked == null) return null;
    return utf8.decode(await picked.readAsBytes());
  }
}

String _stamp(DateTime utc) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${utc.year}${two(utc.month)}${two(utc.day)}-'
      '${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
}
