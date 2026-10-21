import 'package:flutter/material.dart';
import '../../domain/models/wallpaper_item.dart';
import '../state/wallpaper_controller.dart';
import '../widgets/wallpaper_card.dart';
import 'wallpaper_detail_screen.dart';
import '../../data/services/wallpaper_catalog_service.dart';

class CategoryWallpapersScreen extends StatefulWidget {
  const CategoryWallpapersScreen({
    super.key,
    required this.category,
    required this.controller,
  });

  final String category;
  final WallpaperController controller;

  @override
  State<CategoryWallpapersScreen> createState() =>
      _CategoryWallpapersScreenState();
}

class _CategoryWallpapersScreenState extends State<CategoryWallpapersScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<WallpaperItem> _wallpapers;
  late List<WallpaperItem> _filteredWallpapers;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _wallpapers = widget.controller.offlineWallpapers
        .where((item) => item.category == widget.category)
        .toList();
    _filteredWallpapers = List.from(_wallpapers);

    _scrollController.addListener(() {
      if (_scrollController.offset > 400 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset <= 400 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _filterWallpapers(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    setState(() {
      _filteredWallpapers = _wallpapers.where((item) {
        return normalizedQuery.isEmpty ||
            item.title.toLowerCase().contains(normalizedQuery) ||
            item.fileName.toLowerCase().contains(normalizedQuery);
      }).toList();
    });
  }

  void _openWallpaperDetail(WallpaperItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WallpaperDetailScreen(
          item: item,
          controller: widget.controller,
          playlist: _filteredWallpapers,
        ),
      ),
    );
  }

  int _computeGridColumns(double maxWidth, bool compact) {
    if (maxWidth >= 1100) return compact ? 6 : 5;
    if (maxWidth >= 820) return compact ? 5 : 4;
    if (maxWidth >= 560) return compact ? 4 : 3;
    return compact ? 3 : 2;
  }

  @override
  Widget build(BuildContext context) {
    final activeAccent = WallpaperImageView.parseHexColor(
      WallpaperCatalogService.accentForCategory(widget.category),
    );

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF06080D),
          floatingActionButton: _showBackToTop
              ? FloatingActionButton(
                  onPressed: _scrollToTop,
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  mini: true,
                  child: const Icon(Icons.arrow_upward_rounded),
                )
              : null,
          appBar: AppBar(
            backgroundColor: const Color(0xFF06080D),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${widget.category} Wallpapers',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = widget.controller.compactGrid;
              final cols = _computeGridColumns(constraints.maxWidth, isCompact);

              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            controller: _searchTextController,
                            onChanged: _filterWallpapers,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search in ${widget.category}...',
                              hintStyle: const TextStyle(
                                color: Color(0xFFA0AAB8),
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: activeAccent,
                              ),
                              suffixIcon: _searchTextController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchTextController.clear();
                                        _filterWallpapers('');
                                      },
                                      icon: const Icon(
                                        Icons.clear_rounded,
                                        color: Colors.white70,
                                      ),
                                    )
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFF111520),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Colors.white12,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Colors.white12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: activeAccent,
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '${_filteredWallpapers.length} results',
                                  style: TextStyle(
                                    color: activeAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                  if (_filteredWallpapers.isEmpty)
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
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.62,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = _filteredWallpapers[index];
                          return WallpaperCard(
                            item: item,
                            compact: isCompact,
                            isFavorite: widget.controller.isFavorite(item.id),
                            onTap: () => _openWallpaperDetail(item),
                            onToggleFavorite: () =>
                                widget.controller.toggleFavorite(item.id),
                          );
                        }, childCount: _filteredWallpapers.length),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
