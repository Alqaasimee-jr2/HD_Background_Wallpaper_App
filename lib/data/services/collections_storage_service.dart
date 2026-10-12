import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/custom_collection.dart';

class CollectionsStorageService {
  static const String _keyFavorites = 'favorites_set_v2';
  static const String _keyCollections = 'custom_collections_v2';
  static const String _keyGalleryPaths = 'gallery_paths_v2';

  Future<Set<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyFavorites) ?? <String>[];
    return list.toSet();
  }

  Future<void> saveFavorites(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavorites, favorites.toList());
  }

  Future<List<CustomCollection>> loadCollections() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCollections);
    if (raw == null || raw.isEmpty) {
      final seeded = <CustomCollection>[
        CustomCollection(
          name: 'AMOLED Setup',
          wallpaperIds: <String>[
            'assets/wallpapers/black bg wallpaper.jpg',
            'assets/wallpapers/black halo.jpg',
          ],
          createdAt: DateTime(2026, 10, 12),
        ),
        CustomCollection(
          name: 'Lock Screen Picks',
          wallpaperIds: <String>[
            'assets/wallpapers/nature_bg.jpg',
            'assets/wallpapers/anime boy.jpg',
          ],
          createdAt: DateTime(2026, 10, 12),
        ),
      ];
      await saveCollections(seeded);
      return seeded;
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final collections = <CustomCollection>[];
      decoded.forEach((key, value) {
        final ids = (value as List<dynamic>).map((e) => e.toString()).toList();
        collections.add(
          CustomCollection(
            name: key,
            wallpaperIds: ids,
            createdAt: DateTime(2026, 10, 12),
          ),
        );
      });
      return collections;
    } catch (_) {
      return <CustomCollection>[];
    }
  }

  Future<void> saveCollections(List<CustomCollection> collections) async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, List<String>>{};
    for (final col in collections) {
      map[col.name] = col.wallpaperIds;
    }
    await prefs.setString(_keyCollections, jsonEncode(map));
  }

  Future<List<String>> loadGalleryPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyGalleryPaths) ?? <String>[];
  }

  Future<void> saveGalleryPaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyGalleryPaths, paths);
  }
}
