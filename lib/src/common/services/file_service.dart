import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract interface class FileService {
  Future<Directory> getDocumentsDirectory();
  Future<String> readFile(String filePath);
  Future<File> writeFile({required String filePath, required String content});
  Future<File> createNewFile(String title);
  Future<bool> fileExists(String filePath);
  Future<void> deleteFile(String filePath);
  String titleFromPath(String filePath);
  bool isRichDocument(String filePath);
}

class FileServiceImpl implements FileService {
  static const String richExtension = '.livre';

  @override
  Future<Directory> getDocumentsDirectory() async {
    try {
      final base = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(base.path, 'TextEditor'));
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir;
    } catch (error) {
      throw Exception('FileService: $error');
    }
  }

  @override
  Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) throw Exception('File not found: $filePath');
      return await file.readAsString(encoding: utf8);
    } catch (error) {
      throw Exception('FileService: $error');
    }
  }

  @override
  Future<File> writeFile({
    required String filePath,
    required String content,
  }) async {
    try {
      final file = File(filePath);
      await file.parent.create(recursive: true);
      return await file.writeAsString(content, encoding: utf8, flush: true);
    } catch (error) {
      throw Exception('FileService: $error');
    }
  }

  @override
  Future<File> createNewFile(String title) async {
    try {
      final dir = await getDocumentsDirectory();
      final safeName = title.replaceAll(RegExp(r'[^\w\s\-]'), '').trim();
      final base = safeName.isEmpty ? 'Untitled' : safeName;
      var candidate = p.join(dir.path, '$base$richExtension');
      var i = 1;
      while (await File(candidate).exists()) {
        candidate = p.join(dir.path, '${base}_$i$richExtension');
        i++;
      }
      final file = File(candidate);
      await file.create();
      return file;
    } catch (error) {
      throw Exception('FileService: $error');
    }
  }

  @override
  Future<bool> fileExists(String filePath) => File(filePath).exists();

  @override
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    } catch (error) {
      throw Exception('FileService: $error');
    }
  }

  @override
  String titleFromPath(String filePath) =>
      p.basenameWithoutExtension(filePath);

  @override
  bool isRichDocument(String filePath) {
    final lower = filePath.toLowerCase();
    return lower.endsWith(richExtension) || lower.endsWith('.json');
  }
}
