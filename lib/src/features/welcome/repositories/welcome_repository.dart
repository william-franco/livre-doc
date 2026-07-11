import 'dart:convert';

import 'package:livre_doc/src/common/constants/value_constant.dart';
import 'package:livre_doc/src/common/patterns/result_pattern.dart';
import 'package:livre_doc/src/common/services/storage_service.dart';
import 'package:livre_doc/src/features/welcome/models/recent_document.dart';

typedef WelcomeResult = Result<List<RecentDocument>, Exception>;

abstract interface class WelcomeRepository {
  Future<WelcomeResult> readRecentDocuments();
  Future<void> addRecentDocument(RecentDocument doc);
  Future<void> removeRecentDocument(String filePath);
  Future<void> clearRecentDocuments();
}

class WelcomeRepositoryImpl implements WelcomeRepository {
  final StorageService storageService;

  WelcomeRepositoryImpl({required this.storageService});

  @override
  Future<WelcomeResult> readRecentDocuments() async {
    try {
      final raw =
          await storageService.getStringListValue(
            key: ValueConstant.recentDocuments,
          ) ??
          [];
      final docs = raw
          .map(
            (e) =>
                RecentDocument.fromJson(jsonDecode(e) as Map<String, dynamic>),
          )
          .toList();
      return Success(value: docs);
    } catch (error) {
      return Error(error: Exception('WelcomeRepository: $error'));
    }
  }

  @override
  Future<void> addRecentDocument(RecentDocument doc) async {
    try {
      final result = await readRecentDocuments();
      final list = result.fold(
        onSuccess: (docs) => List<RecentDocument>.from(docs),
        onError: (_) => <RecentDocument>[],
      );
      list.removeWhere((d) => d.filePath == doc.filePath);
      list.insert(0, doc);
      await storageService.setStringListValue(
        key: ValueConstant.recentDocuments,
        value: list.take(20).map((d) => jsonEncode(d.toJson())).toList(),
      );
    } catch (error) {
      throw Exception('WelcomeRepository: $error');
    }
  }

  @override
  Future<void> removeRecentDocument(String filePath) async {
    try {
      final result = await readRecentDocuments();
      final list = result.fold(
        onSuccess: (docs) => List<RecentDocument>.from(docs),
        onError: (_) => <RecentDocument>[],
      );
      list.removeWhere((d) => d.filePath == filePath);
      await storageService.setStringListValue(
        key: ValueConstant.recentDocuments,
        value: list.map((d) => jsonEncode(d.toJson())).toList(),
      );
    } catch (error) {
      throw Exception('WelcomeRepository: $error');
    }
  }

  @override
  Future<void> clearRecentDocuments() async {
    try {
      await storageService.removeValue(key: ValueConstant.recentDocuments);
    } catch (error) {
      throw Exception('WelcomeRepository: $error');
    }
  }
}
