import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class ShareService {
  Future<void> shareText({required String text, String? subject});
  Future<void> shareFile({required String filePath, String? mimeType});
}

class ShareServiceImpl implements ShareService {
  @override
  Future<void> shareText({required String text, String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } on UnimplementedError {
      await Clipboard.setData(ClipboardData(text: text));
      debugPrint('[ShareService] Linux: text copied to clipboard.');
    } catch (error) {
      throw Exception('ShareService: $error');
    }
  }

  @override
  Future<void> shareFile({required String filePath, String? mimeType}) async {
    try {
      await Share.shareXFiles([
        XFile(filePath, mimeType: mimeType ?? 'application/json'),
      ]);
    } on UnimplementedError {
      try {
        final dir = File(filePath).parent.path;
        await Process.run('xdg-open', [dir]);
        debugPrint('[ShareService] Linux: opened folder $dir');
      } catch (e) {
        await Clipboard.setData(ClipboardData(text: filePath));
        debugPrint('[ShareService] Linux: file path copied to clipboard.');
      }
    } catch (error) {
      throw Exception('ShareService: $error');
    }
  }
}
