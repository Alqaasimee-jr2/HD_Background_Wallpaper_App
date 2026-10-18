import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/collections_storage_service.dart';
import '../../data/services/native_wallpaper_bridge.dart';
import '../../data/services/wallpaper_catalog_service.dart';
import '../../domain/models/custom_collection.dart';
import '../../domain/models/wallpaper_item.dart';

class WallpaperController extends ChangeNotifier {
  WallpaperController({
    WallpaperCatalogService? catalogService,
    CollectionsStorageService? storageService,
    NativeWallpaperBridge? nativeBridge,
    ImagePicker? imagePicker,
  }) : _catalogService = catalogService ?? WallpaperCatalogService(),
       _storageService = storageService ?? CollectionsStorageService(),
       _nativeBridge = nativeBridge ?? NativeWallpaperBridge(),
       _imagePicker = imagePicker ?? ImagePicker();

  final WallpaperCatalogService _catalogService;
  final CollectionsStorageService _storageService;
  final NativeWallpaperBridge _nativeBridge;
  final ImagePicker _imagePicker;
  final Random _random = Random();

  List<WallpaperItem> _offlineWallpapers = <WallpaperItem>[];
  List<WallpaperItem> _shuffledOfflineWallpapers = <WallpaperItem>[];
  List<WallpaperItem> _cloudWallpapers = <WallpaperItem>[];
  List<WallpaperItem> _galleryWallpapers = <WallpaperItem>[];
  Set<String> _favoriteIds = <String>{};
  List<CustomCollection> _collections = <CustomCollection>[];

  // Performance caches
  Map<String, WallpaperItem> _allWallpapersMap = <String, WallpaperItem>{};
  List<WallpaperItem>? _spotlightCache;
  final Map<String, int> _categoryCountsCache = <String, int>{};

  // Memoization for expensive filtered lists
  List<WallpaperItem>? _filteredOfflineCache;
  List<WallpaperItem>? _filteredCloudCache;

  String _selectedCategory = WallpaperCatalogService.catAll;
  String _selectedCloudTopic = 'All';
  String _searchQuery = '';
  MockupMode _mockupMode = MockupMode.clean;
  bool _compactGrid = false;
  bool _isShuffled = false;
  bool _isInitialized = false;

  List<WallpaperItem> get offlineWallpapers => _offlineWallpapers;
  List<WallpaperItem> get cloudWallpapers => _cloudWallpapers;
  List<WallpaperItem> get galleryWallpapers => _galleryWallpapers;
  Set<String> get favoriteIds => _favoriteIds;
  List<CustomCollection> get collections => _collections;
  String get selectedCategory => _selectedCategory;
  String get selectedCloudTopic => _selectedCloudTopic;
  String get searchQuery => _searchQuery;
  MockupMode get mockupMode => _mockupMode;
  bool get compactGrid => _compactGrid;
  bool get isShuffled => _isShuffled;
  bool get isInitialized => _isInitialized;

  List<String> get offlineCategories =>
      WallpaperCatalogService.offlineCategories;
  List<String> get cloudTopics => WallpaperCatalogService.cloudTopics;

  Future<void> initialize() async {
    _offlineWallpapers = await _catalogService.loadOfflineWallpapers();
    _shuffledOfflineWallpapers = List<WallpaperItem>.from(_offlineWallpapers);
    _cloudWallpapers = _catalogService.getCloudWallpapers();
    _favoriteIds = await _storageService.loadFavorites();
    _collections = await _storageService.loadCollections();
    final galleryPaths = await _storageService.loadGalleryPaths();
    _galleryWallpapers = _buildGalleryItems(galleryPaths);
    _isInitialized = true;
    _rebuildCaches();
    notifyListeners();
  }

  void _rebuildCaches() {
    _allWallpapersMap = <String, WallpaperItem>{
      for (final item in allKnownWallpapers) item.id: item,
    };
    _spotlightCache = null;
    _categoryCountsCache.clear();
    _filteredOfflineCache = null;
    _filteredCloudCache = null;
  }

  List<WallpaperItem> _buildGalleryItems(List<String> paths) {
    final result = <WallpaperItem>[];
    for (var i = 0; i < paths.length; i++) {
      final path = paths[i];
      result.add(
        WallpaperItem(
          id: path,
          title: 'Imported Wallpaper #${i + 1}',
          path: path,
          category: 'My Gallery',
          source: WallpaperSource.gallery,
          accentColorHex: '#00E5FF',
          resolutionLabel: 'Custom HD',
        ),
      );
    }
    return result;
  }

  List<WallpaperItem> get allKnownWallpapers => <WallpaperItem>[
    ..._offlineWallpapers,
    ..._cloudWallpapers,
    ..._galleryWallpapers,
  ];

  /// Curated spotlight items highlighting story-mode & AMOLED pieces across categories.
  List<WallpaperItem> get spotlightWallpapers {
    if (_spotlightCache != null) return _spotlightCache!;
    if (_offlineWallpapers.isEmpty) return const <WallpaperItem>[];
    final preferredPrefixes = <String>[
      'black__Lone_Wolf_Falling_Star',
      'scifi__Astronaut_Streetlamp_In_Space',
      'abstract__Kintsugi_Gold_Porcelain_Sphere',
      'nature__Midnight_Storm_Cliff_Cabin',
      'minimal__Brutalist_Archway_Violet_Eclipse',
      'anime__Cyberpunk_Ronin_Neon_Rain',
      'game__Spartan_God_Of_War_Ember',
      'quotes__',
    ];
    final picks = <WallpaperItem>[];
    for (final prefix in preferredPrefixes) {
      for (final item in _offlineWallpapers) {
        if (item.fileName.startsWith(prefix) && !picks.contains(item)) {
          picks.add(item);
          break;
        }
      }
    }
    if (picks.length < 6) {
      for (final item in _offlineWallpapers.take(8)) {
        if (!picks.contains(item)) picks.add(item);
        if (picks.length >= 6) break;
      }
    }
    _spotlightCache = picks;
    return picks;
  }

  List<WallpaperItem> get filteredOfflineWallpapers {
    if (_filteredOfflineCache != null) return _filteredOfflineCache!;

    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final sourceList = _isShuffled
        ? _shuffledOfflineWallpapers
        : _offlineWallpapers;

    // Memoize the filtered list to avoid O(N) re-evaluation on unrelated notifyListeners()
    _filteredOfflineCache = sourceList.where((item) {
      final matchesCategory =
          _selectedCategory == WallpaperCatalogService.catAll ||
          item.category == _selectedCategory;
      final matchesSearch =
          normalizedQuery.isEmpty ||
          item.title.toLowerCase().contains(normalizedQuery) ||
          item.fileName.toLowerCase().contains(normalizedQuery) ||
          item.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return _filteredOfflineCache!;
  }

  List<WallpaperItem> get filteredCloudWallpapers {
    if (_filteredCloudCache != null) return _filteredCloudCache!;

    if (_selectedCloudTopic == 'All') {
      _filteredCloudCache = _cloudWallpapers;
    } else {
      // Memoize the filtered list to avoid O(N) re-evaluation on unrelated notifyListeners()
      _filteredCloudCache = _cloudWallpapers
          .where(
            (item) =>
                item.category.toLowerCase() == _selectedCloudTopic.toLowerCase(),
          )
          .toList();
    }

    return _filteredCloudCache!;
  }

  List<WallpaperItem> get favoriteWallpapers {
    final results = <WallpaperItem>[];
    for (final id in _favoriteIds) {
      final item = _allWallpapersMap[id];
      if (item != null) results.add(item);
    }
    return results;
  }

  int countForCategory(String category) {
    if (category == WallpaperCatalogService.catAll) {
      return _offlineWallpapers.length;
    }
    if (_categoryCountsCache.containsKey(category)) {
      return _categoryCountsCache[category]!;
    }
    final count = _offlineWallpapers
        .where((w) => w.category == category)
        .length;
    _categoryCountsCache[category] = count;
    return count;
  }

  WallpaperItem? coverForCategory(String category) {
    if (_offlineWallpapers.isEmpty) return null;
    if (category == WallpaperCatalogService.catAll) {
      return _offlineWallpapers.first;
    }
    for (final item in _offlineWallpapers) {
      if (item.category == category) return item;
    }
    return _offlineWallpapers.first;
  }

  WallpaperItem? pickRandomWallpaper() {
    final pool = filteredOfflineWallpapers.isNotEmpty
        ? filteredOfflineWallpapers
        : _offlineWallpapers;
    if (pool.isEmpty) return null;
    return pool[_random.nextInt(pool.length)];
  }

  void toggleCompactGrid() {
    _compactGrid = !_compactGrid;
    notifyListeners();
  }

  void shuffleWallpapers() {
    _shuffledOfflineWallpapers = List<WallpaperItem>.from(_offlineWallpapers)
      ..shuffle(_random);
    _isShuffled = true;
    _filteredOfflineCache = null; // Invalidate cache
    notifyListeners();
  }

  void resetOrder() {
    if (!_isShuffled) return;
    _isShuffled = false;
    _filteredOfflineCache = null; // Invalidate cache
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _filteredOfflineCache = null; // Invalidate cache
    notifyListeners();
  }

  void setSelectedCloudTopic(String topic) {
    if (_selectedCloudTopic == topic) return;
    _selectedCloudTopic = topic;
    _filteredCloudCache = null; // Invalidate cache
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _filteredOfflineCache = null; // Invalidate cache
    notifyListeners();
  }

  void setMockupMode(MockupMode mode) {
    if (_mockupMode == mode) return;
    _mockupMode = mode;
    notifyListeners();
  }

  bool isFavorite(String wallpaperId) => _favoriteIds.contains(wallpaperId);

  Future<bool> toggleFavorite(String wallpaperId) async {
    final updated = Set<String>.from(_favoriteIds);
    final bool added;
    if (updated.contains(wallpaperId)) {
      updated.remove(wallpaperId);
      added = false;
    } else {
      updated.add(wallpaperId);
      added = true;
    }
    _favoriteIds = updated;
    notifyListeners();
    await _storageService.saveFavorites(_favoriteIds);
    return added;
  }

  Future<void> createCollection(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final exists = _collections.any(
      (c) => c.name.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;

    _collections = <CustomCollection>[
      ..._collections,
      CustomCollection(
        name: trimmed,
        wallpaperIds: const <String>[],
        createdAt: DateTime.now(),
      ),
    ];
    notifyListeners();
    await _storageService.saveCollections(_collections);
  }

  Future<void> deleteCollection(String name) async {
    _collections = _collections.where((c) => c.name != name).toList();
    notifyListeners();
    await _storageService.saveCollections(_collections);
  }

  Future<void> addWallpaperToCollection(
    String collectionName,
    String wallpaperId,
  ) async {
    final trimmed = collectionName.trim();
    if (trimmed.isEmpty) return;

    var found = false;
    final updated = _collections.map((col) {
      if (col.name.toLowerCase() == trimmed.toLowerCase()) {
        found = true;
        if (col.wallpaperIds.contains(wallpaperId)) return col;
        return col.copyWith(
          wallpaperIds: <String>[...col.wallpaperIds, wallpaperId],
        );
      }
      return col;
    }).toList();

    if (!found) {
      updated.add(
        CustomCollection(
          name: trimmed,
          wallpaperIds: <String>[wallpaperId],
          createdAt: DateTime.now(),
        ),
      );
    }

    _collections = updated;
    notifyListeners();
    await _storageService.saveCollections(_collections);
  }

  Future<void> removeWallpaperFromCollection(
    String collectionName,
    String wallpaperId,
  ) async {
    _collections = _collections.map((col) {
      if (col.name == collectionName) {
        return col.copyWith(
          wallpaperIds: col.wallpaperIds
              .where((id) => id != wallpaperId)
              .toList(),
        );
      }
      return col;
    }).toList();
    notifyListeners();
    await _storageService.saveCollections(_collections);
  }

  List<WallpaperItem> wallpapersForCollection(CustomCollection collection) {
    final results = <WallpaperItem>[];
    for (final id in collection.wallpaperIds) {
      final match = _allWallpapersMap[id];
      if (match != null) {
        results.add(match);
      }
    }
    return results;
  }

  Future<WallpaperItem?> importFromDeviceGallery() async {
    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked == null) return null;
      return addImportedGalleryPath(picked.path);
    } catch (_) {
      return null;
    }
  }

  Future<WallpaperItem> addImportedGalleryPath(String filePath) async {
    final currentPaths = _galleryWallpapers.map((e) => e.path).toList();
    if (!currentPaths.contains(filePath)) {
      currentPaths.add(filePath);
      await _storageService.saveGalleryPaths(currentPaths);
      _galleryWallpapers = _buildGalleryItems(currentPaths);
      _rebuildCaches();
      notifyListeners();
    }
    return _galleryWallpapers.firstWhere((e) => e.path == filePath);
  }

  Future<bool> applyWallpaper(WallpaperItem item, String target) {
    return _nativeBridge.setWallpaper(item: item, target: target);
  }

  Future<bool> saveWallpaperToGallery(WallpaperItem item) {
    return _nativeBridge.saveToGallery(item);
  }
}
