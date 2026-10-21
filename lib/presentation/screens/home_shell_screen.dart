import 'package:flutter/material.dart';
import '../../data/services/wallpaper_catalog_service.dart';
import '../../domain/models/custom_collection.dart';
import '../../domain/models/wallpaper_item.dart';
import '../state/wallpaper_controller.dart';
import '../widgets/wallpaper_card.dart';
import 'wallpaper_detail_screen.dart';
import 'categories_tab.dart';
import 'settings_tab.dart';
import '../state/theme_controller.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final WallpaperController controller;
  final ThemeController themeController;

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchTextController = TextEditingController();
  final ScrollController _exploreScrollController = ScrollController();
  final ScrollController _cloudScrollController = ScrollController();
  bool _showBackToTop = false;

  void _scrollListener(ScrollController controller) {
    if (controller.hasClients) {
      if (controller.offset > 400 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (controller.offset <= 400 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _exploreScrollController.addListener(
      () => _scrollListener(_exploreScrollController),
    );
    _cloudScrollController.addListener(
      () => _scrollListener(_cloudScrollController),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _exploreScrollController.dispose();
    _cloudScrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    final activeController = _selectedIndex == 0
        ? _exploreScrollController
        : _cloudScrollController;
    if (!activeController.hasClients) return;
    activeController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _openWallpaperDetail(
    WallpaperItem item, {
    List<WallpaperItem>? playlist,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WallpaperDetailScreen(
          item: item,
          controller: widget.controller,
          playlist: playlist,
        ),
      ),
    );
  }

  void _handleSurpriseMe() {
    final randomPick = widget.controller.pickRandomWallpaper();
    if (randomPick == null) return;
    _openWallpaperDetail(
      randomPick,
      playlist: widget.controller.filteredOfflineWallpapers,
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case WallpaperCatalogService.catAll:
        return Icons.auto_awesome_rounded;
      case WallpaperCatalogService.catNature:
        return Icons.forest_rounded;
      case WallpaperCatalogService.catAnime:
        return Icons.bolt_rounded;
      case WallpaperCatalogService.catAbstract:
        return Icons.blur_on_rounded;
      case WallpaperCatalogService.catBlack:
        return Icons.dark_mode_rounded;
      case WallpaperCatalogService.catGame:
        return Icons.sports_esports_rounded;
      case WallpaperCatalogService.catMinimal:
        return Icons.architecture_rounded;
      case WallpaperCatalogService.catQuotes:
        return Icons.format_quote_rounded;
      case WallpaperCatalogService.catSciFiCars:
        return Icons.directions_car_filled_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  int _computeGridColumns(double maxWidth, bool compact) {
    if (maxWidth >= 1100) return compact ? 6 : 5;
    if (maxWidth >= 820) return compact ? 5 : 4;
    if (maxWidth >= 560) return compact ? 4 : 3;
    return compact ? 3 : 2;
  }

  void _showCreateCollectionDialog() {
    final folderController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111520),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Colors.white12),
          ),
          title: const Text(
            'New Wallpaper Folder',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          content: TextField(
            controller: folderController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'e.g., Dark Story Mode Setup',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = folderController.text.trim();
                if (name.isEmpty) return;
                final navigator = Navigator.of(dialogContext);
                await widget.controller.createCollection(name);
                if (!mounted) return;
                navigator.pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleImportFromGallery() async {
    final imported = await widget.controller.importFromDeviceGallery();
    if (!mounted || imported == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Imported "${imported.title}" from device gallery'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _openWallpaperDetail(
      imported,
      playlist: widget.controller.galleryWallpapers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth >= 720;

            return Scaffold(
              backgroundColor: const Color(0xFF06080D),
              appBar: AppBar(
                backgroundColor: const Color(0xFF06080D),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF6C63FF), Color(0xFF00E5FF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_mosaic_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            '4K Wallpaper Studio',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '${widget.controller.offlineWallpapers.length} Offline • ${widget.controller.offlineCategories.length - 1} Curated Categories',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFA0AAB8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    tooltip: 'Surprise Me (Random Wallpaper)',
                    onPressed: _handleSurpriseMe,
                    icon: const Icon(
                      Icons.casino_outlined,
                      color: Color(0xFFFF9F43),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Import from Gallery',
                    onPressed: _handleImportFromGallery,
                    icon: const Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ],
              ),
              floatingActionButton:
                  _showBackToTop && (_selectedIndex == 0 || _selectedIndex == 2)
                  ? FloatingActionButton(
                      onPressed: _scrollToTop,
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      mini: true,
                      child: const Icon(Icons.arrow_upward_rounded),
                    )
                  : null,
              body: isWideScreen
                  ? Row(
                      children: <Widget>[
                        NavigationRail(
                          selectedIndex: _selectedIndex,
                          backgroundColor: const Color(0xFF0B0E17),
                          indicatorColor: const Color(0x336C63FF),
                          labelType: NavigationRailLabelType.all,
                          onDestinationSelected: (index) {
                            setState(() => _selectedIndex = index);
                          },
                          destinations: const <NavigationRailDestination>[
                            NavigationRailDestination(
                              icon: Icon(Icons.explore_outlined),
                              selectedIcon: Icon(
                                Icons.explore_rounded,
                                color: Color(0xFF6C63FF),
                              ),
                              label: Text('Explore'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.category_outlined),
                              selectedIcon: Icon(
                                Icons.category_rounded,
                                color: Color(0xFF6C63FF),
                              ),
                              label: Text('Categories'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.cloud_outlined),
                              selectedIcon: Icon(
                                Icons.cloud_rounded,
                                color: Color(0xFF00E5FF),
                              ),
                              label: Text('Cloud 4K'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.collections_bookmark_outlined),
                              selectedIcon: Icon(
                                Icons.collections_bookmark_rounded,
                                color: Color(0xFF6C63FF),
                              ),
                              label: Text('Collections'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.settings_outlined),
                              selectedIcon: Icon(
                                Icons.settings_rounded,
                                color: Color(0xFF6C63FF),
                              ),
                              label: Text('Settings'),
                            ),
                          ],
                        ),
                        const VerticalDivider(width: 1, color: Colors.white12),
                        Expanded(
                          child: _buildActiveTabBody(constraints.maxWidth - 88),
                        ),
                      ],
                    )
                  : _buildActiveTabBody(constraints.maxWidth),
              bottomNavigationBar: isWideScreen
                  ? null
                  : NavigationBar(
                      selectedIndex: _selectedIndex,
                      backgroundColor: const Color(0xFF0C101A),
                      indicatorColor: const Color(0x336C63FF),
                      onDestinationSelected: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      destinations: const <NavigationDestination>[
                        NavigationDestination(
                          icon: Icon(Icons.explore_outlined),
                          selectedIcon: Icon(
                            Icons.explore_rounded,
                            color: Color(0xFF6C63FF),
                          ),
                          label: 'Explore',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.category_outlined),
                          selectedIcon: Icon(
                            Icons.category_rounded,
                            color: Color(0xFF6C63FF),
                          ),
                          label: 'Categories',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.cloud_outlined),
                          selectedIcon: Icon(
                            Icons.cloud_rounded,
                            color: Color(0xFF00E5FF),
                          ),
                          label: 'Cloud 4K',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.collections_bookmark_outlined),
                          selectedIcon: Icon(
                            Icons.collections_bookmark_rounded,
                            color: Color(0xFF6C63FF),
                          ),
                          label: 'Collections',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(
                            Icons.settings_rounded,
                            color: Color(0xFF6C63FF),
                          ),
                          label: 'Settings',
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildActiveTabBody(double availableWidth) {
    return IndexedStack(
      index: _selectedIndex,
      children: <Widget>[
        _buildExploreTab(availableWidth),
        CategoriesTab(controller: widget.controller),
        _buildCloudTab(availableWidth),
        _buildCollectionsTab(),
        SettingsTab(themeController: widget.themeController),
      ],
    );
  }

  Widget _buildExploreTab(double availableWidth) {
    final items = widget.controller.filteredOfflineWallpapers;
    final isCompact = widget.controller.compactGrid;
    final cols = _computeGridColumns(availableWidth, isCompact);
    final activeAccent = const Color(0xFF6C63FF);
    final showSpotlight =
        widget.controller.searchQuery.trim().isEmpty &&
        widget.controller.spotlightWallpapers.isNotEmpty;

    return CustomScrollView(
      controller: _exploreScrollController,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  key: const Key('wallpaper_search_field'),
                  controller: _searchTextController,
                  onChanged: (val) {
                    widget.controller.setSelectedCategory(
                      WallpaperCatalogService.catAll,
                    );
                    widget.controller.setSearchQuery(val);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Search ${widget.controller.offlineWallpapers.length} wallpapers (anime, cars, quotes, nature...)',
                    hintStyle: const TextStyle(
                      color: Color(0xFFA0AAB8),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(Icons.search_rounded, color: activeAccent),
                    suffixIcon: widget.controller.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchTextController.clear();
                              widget.controller.setSearchQuery('');
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: Colors.white70,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF111520),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: activeAccent, width: 1.4),
                    ),
                  ),
                ),
                if (showSpotlight) ...<Widget>[
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.nights_stay_rounded,
                        color: Color(0xFF00E5FF),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Story-Mode & AMOLED Spotlight',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Negative Space',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 156,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.controller.spotlightWallpapers.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final spot =
                            widget.controller.spotlightWallpapers[index];
                        return SizedBox(
                          width: 112,
                          child: WallpaperCard(
                            item: spot,
                            compact: true,
                            isFavorite: widget.controller.isFavorite(spot.id),
                            onTap: () => _openWallpaperDetail(
                              spot,
                              playlist: widget.controller.spotlightWallpapers,
                            ),
                            onToggleFavorite: () =>
                                widget.controller.toggleFavorite(spot.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Explore Wallpapers',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${items.length} results',
                            style: TextStyle(
                              color: activeAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Shuffle Feed',
                      onPressed: widget.controller.shuffleWallpapers,
                      icon: Icon(
                        Icons.shuffle_rounded,
                        size: 19,
                        color: widget.controller.isShuffled
                            ? const Color(0xFF00E5FF)
                            : Colors.white70,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: isCompact
                          ? '2-Column View'
                          : '3-Column Compact View',
                      onPressed: widget.controller.toggleCompactGrid,
                      icon: Icon(
                        isCompact
                            ? Icons.grid_view_rounded
                            : Icons.apps_rounded,
                        size: 19,
                        color: isCompact
                            ? const Color(0xFF00E5FF)
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.search_off_rounded,
                      color: Colors.white38,
                      size: 42,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No wallpapers match your search filter.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () {
                        _searchTextController.clear();
                        widget.controller.setSearchQuery('');
                        widget.controller.setSelectedCategory(
                          WallpaperCatalogService.catAll,
                        );
                      },
                      child: const Text('Reset Filters'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: isCompact ? 10 : 14,
                crossAxisSpacing: isCompact ? 10 : 14,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = items[index];
                return WallpaperCard(
                  item: item,
                  compact: isCompact,
                  isFavorite: widget.controller.isFavorite(item.id),
                  onTap: () => _openWallpaperDetail(item, playlist: items),
                  onToggleFavorite: () =>
                      widget.controller.toggleFavorite(item.id),
                );
              }, childCount: items.length),
            ),
          ),
      ],
    );
  }

  Widget _buildCloudTab(double availableWidth) {
    final topics = widget.controller.cloudTopics;
    final selectedTopic = widget.controller.selectedCloudTopic;
    final cloudItems = widget.controller.filteredCloudWallpapers;
    final cols = _computeGridColumns(
      availableWidth,
      widget.controller.compactGrid,
    );

    return CustomScrollView(
      controller: _cloudScrollController,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFF151931), Color(0xFF0B1922)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Row(
                    children: <Widget>[
                      Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFF00E5FF),
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Cloud 4K Ultra HD Stream',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Curated online 4K drops with live Lock/Home screen preview.',
                              style: TextStyle(
                                color: Color(0xFFA0AAB8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: topics.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      final isSelected = topic == selectedTopic;
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Text(topic),
                        selected: isSelected,
                        onSelected: (_) =>
                            widget.controller.setSelectedCloudTopic(topic),
                        selectedColor: const Color(0xFF00E5FF),
                        backgroundColor: const Color(0xFF111520),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF06080D)
                              : const Color(0xFFA0AAB8),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = cloudItems[index];
              return WallpaperCard(
                item: item,
                isFavorite: widget.controller.isFavorite(item.id),
                onTap: () => _openWallpaperDetail(item, playlist: cloudItems),
                onToggleFavorite: () =>
                    widget.controller.toggleFavorite(item.id),
              );
            }, childCount: cloudItems.length),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionsTab() {
    final favorites = widget.controller.favoriteWallpapers;
    final collections = widget.controller.collections;
    final galleryItems = widget.controller.galleryWallpapers;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _showCreateCollectionDialog,
                    icon: const Icon(Icons.create_new_folder_rounded, size: 18),
                    label: const Text('+ New Folder'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00E5FF),
                      side: const BorderSide(color: Color(0xFF00E5FF)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _handleImportFromGallery,
                    icon: const Icon(Icons.photo_library_rounded, size: 18),
                    label: const Text('Import Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Favorites (${favorites.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            if (favorites.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111520),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Text(
                  'Tap the heart icon on any offline or cloud wallpaper to pin it here.',
                  style: TextStyle(color: Color(0xFFA0AAB8), fontSize: 13),
                ),
              )
            else
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = favorites[index];
                    return SizedBox(
                      width: 136,
                      child: WallpaperCard(
                        item: item,
                        isFavorite: true,
                        onTap: () =>
                            _openWallpaperDetail(item, playlist: favorites),
                        onToggleFavorite: () =>
                            widget.controller.toggleFavorite(item.id),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Custom Collections (${collections.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...collections.map(_buildCollectionCard),
            const SizedBox(height: 24),
            Text(
              'Imported from Device Gallery (${galleryItems.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            if (galleryItems.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111520),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Text(
                  'Use "Import Gallery" to test your own photos with the Lock/Home Screen mockup overlays.',
                  style: TextStyle(color: Color(0xFFA0AAB8), fontSize: 13),
                ),
              )
            else
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: galleryItems.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = galleryItems[index];
                    return SizedBox(
                      width: 136,
                      child: WallpaperCard(
                        item: item,
                        isFavorite: widget.controller.isFavorite(item.id),
                        onTap: () =>
                            _openWallpaperDetail(item, playlist: galleryItems),
                        onToggleFavorite: () =>
                            widget.controller.toggleFavorite(item.id),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(CustomCollection collection) {
    final items = widget.controller.wallpapersForCollection(collection);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111520),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.folder_special_rounded,
                color: Color(0xFF00E5FF),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  collection.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '${items.length} items',
                style: const TextStyle(color: Color(0xFFA0AAB8), fontSize: 12),
              ),
              if (collection.name != 'AMOLED Setup') ...<Widget>[
                const SizedBox(width: 4),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Delete Folder',
                  onPressed: () {
                    widget.controller.deleteCollection(collection.name);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white54,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
          if (items.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: 100,
                    child: WallpaperCard(
                      item: item,
                      compact: true,
                      isFavorite: widget.controller.isFavorite(item.id),
                      onTap: () => _openWallpaperDetail(item, playlist: items),
                      onToggleFavorite: () =>
                          widget.controller.toggleFavorite(item.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
