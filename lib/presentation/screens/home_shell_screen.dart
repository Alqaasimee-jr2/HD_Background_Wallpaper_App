import 'package:flutter/material.dart';
import '../../domain/models/custom_collection.dart';
import '../../domain/models/wallpaper_item.dart';
import '../state/wallpaper_controller.dart';
import '../widgets/wallpaper_card.dart';
import 'wallpaper_detail_screen.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key, required this.controller});

  final WallpaperController controller;

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void _openWallpaperDetail(WallpaperItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WallpaperDetailScreen(
          item: item,
          controller: widget.controller,
        ),
      ),
    );
  }

  void _showCreateCollectionDialog() {
    final folderController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161B26),
          title: const Text(
            'New Wallpaper Folder',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: TextField(
            controller: folderController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'e.g., AMOLED Dark Setup',
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
    _openWallpaperDetail(imported);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0B0E14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B0E14),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '4K Wallpaper Studio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${widget.controller.offlineWallpapers.length} Offline + ${widget.controller.cloudWallpapers.length} Cloud 4K',
                      style: const TextStyle(
                        color: Color(0xFFA0AAB8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
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
          body: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              _buildExploreTab(),
              _buildCloudTab(),
              _buildCollectionsTab(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            backgroundColor: const Color(0xFF121722),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildExploreTab() {
    final items = widget.controller.filteredOfflineWallpapers;
    final categories = widget.controller.offlineCategories;
    final selectedCat = widget.controller.selectedCategory;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  key: const Key('wallpaper_search_field'),
                  controller: _searchTextController,
                  onChanged: widget.controller.setSearchQuery,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search 266 wallpapers (anime, valorant, nature...)',
                    hintStyle: const TextStyle(
                      color: Color(0xFFA0AAB8),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF00E5FF),
                    ),
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
                    fillColor: const Color(0xFF161B26),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final count = widget.controller.countForCategory(cat);
                      final isSelected = selectedCat == cat;
                      return ChoiceChip(
                        label: Text('$cat ($count)'),
                        selected: isSelected,
                        onSelected: (_) =>
                            widget.controller.setSelectedCategory(cat),
                        selectedColor: const Color(0xFF6C63FF),
                        backgroundColor: const Color(0xFF161B26),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFA0AAB8),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '$selectedCat Wallpapers',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${items.length} results',
                      style: const TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No wallpapers match your search filter.',
                style: TextStyle(color: Color(0xFFA0AAB8)),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.64,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return WallpaperCard(
                    item: item,
                    isFavorite: widget.controller.isFavorite(item.id),
                    onTap: () => _openWallpaperDetail(item),
                    onToggleFavorite: () =>
                        widget.controller.toggleFavorite(item.id),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCloudTab() {
    final topics = widget.controller.cloudTopics;
    final selectedTopic = widget.controller.selectedCloudTopic;
    final cloudItems = widget.controller.filteredCloudWallpapers;

    return CustomScrollView(
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
                      colors: <Color>[Color(0xFF1B1F3B), Color(0xFF0F2027)],
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
                                fontWeight: FontWeight.w700,
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
                        label: Text(topic),
                        selected: isSelected,
                        onSelected: (_) =>
                            widget.controller.setSelectedCloudTopic(topic),
                        selectedColor: const Color(0xFF00E5FF),
                        backgroundColor: const Color(0xFF161B26),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF0B0E14)
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.64,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = cloudItems[index];
                return WallpaperCard(
                  item: item,
                  isFavorite: widget.controller.isFavorite(item.id),
                  onTap: () => _openWallpaperDetail(item),
                  onToggleFavorite: () =>
                      widget.controller.toggleFavorite(item.id),
                );
              },
              childCount: cloudItems.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionsTab() {
    final favorites = widget.controller.favoriteWallpapers;
    final collections = widget.controller.collections;
    final galleryItems = widget.controller.galleryWallpapers;

    return ListView(
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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        if (favorites.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF161B26),
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
                    onTap: () => _openWallpaperDetail(item),
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
            fontWeight: FontWeight.w700,
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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        if (galleryItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF161B26),
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
                    onTap: () => _openWallpaperDetail(item),
                    onToggleFavorite: () =>
                        widget.controller.toggleFavorite(item.id),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCollectionCard(CustomCollection collection) {
    final items = widget.controller.wallpapersForCollection(collection);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B26),
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
                      isFavorite: widget.controller.isFavorite(item.id),
                      onTap: () => _openWallpaperDetail(item),
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
