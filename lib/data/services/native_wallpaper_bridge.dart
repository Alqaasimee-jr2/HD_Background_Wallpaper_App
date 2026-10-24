import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/wallpaper_item.dart';

class NativeWallpaperBridge {
  static const MethodChannel _channel = MethodChannel(
    'com.example.hd_background_wallpaper/wallpaper',
  );

  Future<Uint8List> resolveBytes(WallpaperItem item) async {
    switch (item.source) {
      case WallpaperSource.asset:
        final byteData = await rootBundle.load(item.path);
        return byteData.buffer.asUint8List();
      case WallpaperSource.cloud:
        final response = await http
            .get(Uri.parse(item.path))
            .timeout(const Duration(seconds: 20));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response.bodyBytes;
        }
        throw Exception('HTTP ${response.statusCode} while downloading image');
      case WallpaperSource.gallery:
        final file = File(item.path);
        return file.readAsBytes();
    }
  }

  Future<bool> setWallpaper({
    required WallpaperItem item,
    required String target,
  }) async {
    try {
      final bytes = await resolveBytes(item);
      final result = await _channel.invokeMethod<bool>(
        'setWallpaper',
        <String, dynamic>{'bytes': bytes, 'target': target},
      );
      return result ?? false;
    } on MissingPluginException {
      // Allows previewing/testing on desktop or widget tests without crashing
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> saveToGallery(WallpaperItem item) async {
    try {
      final bytes = await resolveBytes(item);
      final safeName = item.title
          .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_')
          .toLowerCase();
      final result = await _channel.invokeMethod<bool>('saveToGallery', <
        String,
        dynamic
      >{
        'bytes': bytes,
        'fileName':
            'hd_wallpaper_${safeName}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      });
      return result ?? false;
    } on MissingPluginException {
      return true;
    } catch (_) {
      return false;
    }
  }
}
