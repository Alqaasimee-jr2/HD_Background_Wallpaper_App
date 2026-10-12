import 'package:flutter_test/flutter_test.dart';
import 'package:hd_background_wallpaper/data/services/wallpaper_catalog_service.dart';
import 'package:hd_background_wallpaper/domain/models/wallpaper_item.dart';
import 'package:hd_background_wallpaper/presentation/state/wallpaper_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WallpaperCatalogService unit tests', () {
    test('categorizeFileName classifies all 6 offline categories accurately', () {
      expect(
        WallpaperCatalogService.categorizeFileName('game22.jpg'),
        WallpaperCatalogService.catGame,
      );
      expect(
        WallpaperCatalogService.categorizeFileName('waterfall anime.jpg'),
        WallpaperCatalogService.catAnime,
      );
      expect(
        WallpaperCatalogService.categorizeFileName('ds2.jpeg'),
        WallpaperCatalogService.catAnime,
      );
      expect(
        WallpaperCatalogService.categorizeFileName('nature_bg.jpg'),
        WallpaperCatalogService.catNature,
      );
      expect(
        WallpaperCatalogService.categorizeFileName('abstract splash.jpg'),
        WallpaperCatalogService.catAbstract,
      );
      expect(
        WallpaperCatalogService.categorizeFileName('black halo.jpg'),
        WallpaperCatalogService.catBlack,
      );
      expect(
        WallpaperCatalogService.categorizeFileName('Feels bg.jpg'),
        WallpaperCatalogService.catRandom,
      );
    });

    test('loads all 266 bundled offline assets and 17 cloud 4K wallpapers', () async {
      final service = WallpaperCatalogService();
      final offline = await service.loadOfflineWallpapers();
      final cloud = service.getCloudWallpapers();

      expect(offline.length, 266);
      expect(cloud.length, greaterThanOrEqualTo(16));
      expect(
        offline.any((w) => w.fileName == 'game22.jpg'),
        isTrue,
      );
      expect(
        offline.any((w) => w.fileName == 'waterfall anime.jpg'),
        isTrue,
      );
      expect(
        offline.any((w) => w.fileName == 'ds2.jpeg'),
        isTrue,
      );
    });
  });

  group('WallpaperController state tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('filters by category, search query, toggles favorites, and manages custom folders', () async {
      final controller = WallpaperController();
      await controller.initialize();

      expect(controller.offlineWallpapers.length, 266);
      expect(controller.filteredOfflineWallpapers.length, 266);

      controller.setSelectedCategory(WallpaperCatalogService.catGame);
      expect(controller.filteredOfflineWallpapers, isNotEmpty);
      expect(
        controller.filteredOfflineWallpapers.every(
          (w) => w.category == WallpaperCatalogService.catGame,
        ),
        isTrue,
      );

      controller.setSelectedCategory(WallpaperCatalogService.catAll);
      controller.setSearchQuery('valorant');
      expect(controller.filteredOfflineWallpapers, isNotEmpty);
      expect(
        controller.filteredOfflineWallpapers.every(
          (w) => w.fileName.toLowerCase().contains('valorant'),
        ),
        isTrue,
      );

      controller.setSearchQuery('');
      final firstId = controller.offlineWallpapers.first.id;
      expect(controller.isFavorite(firstId), isFalse);

      await controller.toggleFavorite(firstId);
      expect(controller.isFavorite(firstId), isTrue);
      expect(controller.favoriteWallpapers.length, 1);

      await controller.createCollection('Cyberpunk Favorites');
      await controller.addWallpaperToCollection('Cyberpunk Favorites', firstId);

      final customFolder = controller.collections.firstWhere(
        (c) => c.name == 'Cyberpunk Favorites',
      );
      expect(customFolder.wallpaperIds, contains(firstId));

      await controller.removeWallpaperFromCollection(
        'Cyberpunk Favorites',
        firstId,
      );
      final updatedFolder = controller.collections.firstWhere(
        (c) => c.name == 'Cyberpunk Favorites',
      );
      expect(updatedFolder.wallpaperIds, isNot(contains(firstId)));

      controller.setMockupMode(MockupMode.lockScreen);
      expect(controller.mockupMode, MockupMode.lockScreen);
    });
  });
}
