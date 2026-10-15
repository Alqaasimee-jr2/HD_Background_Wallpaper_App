import 'package:flutter/material.dart';
import '../../data/services/wallpaper_catalog_service.dart';
import '../state/wallpaper_controller.dart';
import '../widgets/wallpaper_card.dart';
import 'category_wallpapers_screen.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({
    super.key,
    required this.controller,
  });

  final WallpaperController controller;

  @override
  Widget build(BuildContext context) {
    final categories = controller.offlineCategories.where((c) => c != WallpaperCatalogService.catAll).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final count = controller.countForCategory(category);
        final coverItem = controller.coverForCategory(category);
        final accent = WallpaperImageView.parseHexColor(
          WallpaperCatalogService.accentForCategory(category),
        );

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CategoryWallpapersScreen(
                  category: category,
                  controller: controller,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF111520),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (coverItem != null)
                  WallpaperImageView(
                    item: coverItem,
                    isThumbnail: true,
                  ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$count wallpapers',
                        style: TextStyle(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
