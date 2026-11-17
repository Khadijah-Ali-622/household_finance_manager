import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_models.dart';
import 'local_backup_store_api.dart';

LocalBackupStore createLocalBackupStore() => const IoLocalBackupStore();

class IoLocalBackupStore implements LocalBackupStore {
  const IoLocalBackupStore();

  Future<Directory> _directory() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'hfm_backups'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  Future<StoredBackup> write({
    required String prefix,
    required String extension,
    required String contents,
    int keep = 5,
  }) async {
    final dir = await _directory();
    final name = '$prefix${_stamp(DateTime.now().toUtc())}.$extension';
    final file = File(p.join(dir.path, name));
    await file.writeAsString(contents);
    await _prune(dir, prefix, keep);
    final stat = await file.stat();
    return StoredBackup(
      name: name,
      modified: stat.modified.toUtc(),
      sizeBytes: stat.size,
      path: file.path,
    );
  }

  @override
  Future<List<StoredBackup>> list(String prefix) async {
    final dir = await _directory();
    if (!await dir.exists()) return const [];
    final files = <File>[];
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      if (!p.basename(entity.path).startsWith(prefix)) continue;
      files.add(entity);
    }
    files.sort(
      (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
    );
    return [
      for (final file in files)
        StoredBackup(
          name: p.basename(file.path),
          modified: file.statSync().modified.toUtc(),
          sizeBytes: file.statSync().size,
          path: file.path,
        ),
    ];
  }

  @override
  Future<String> read(StoredBackup item) async {
    if (item.content != null) return item.content!;
    final path = item.path;
    if (path == null) {
      throw const BackupCorruptException('Backup file path is missing.');
    }
    return File(path).readAsString();
  }

  @override
  Future<bool> share(StoredBackup item, {required String mimeType}) async {
    try {
      final path = item.path;
      final files = path != null
          ? [XFile(path, mimeType: mimeType, name: item.name)]
          : [
              XFile.fromData(
                _bytes(item),
                mimeType: mimeType,
                name: item.name,
              ),
            ];
      await SharePlus.instance.share(ShareParams(files: files));
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

  Uint8List _bytes(StoredBackup item) {
    final content = item.content;
    if (content == null) {
      throw const BackupCorruptException('Nothing to share.');
    }
    return utf8.encode(content);
  }

  Future<void> _prune(Directory dir, String prefix, int keep) async {
    final items = await list(prefix);
    if (items.length <= keep) return;
    for (final extra in items.skip(keep)) {
      final path = extra.path;
      if (path == null) continue;
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }
}

String _stamp(DateTime utc) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${utc.year}${two(utc.month)}${two(utc.day)}-'
      '${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
}
