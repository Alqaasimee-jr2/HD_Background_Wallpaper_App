import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/models/wallpaper_item.dart';

class WallpaperImageView extends StatelessWidget {
  const WallpaperImageView({
    super.key,
    required this.item,
    this.fit = BoxFit.cover,
  });

  final WallpaperItem item;
  final BoxFit fit;

  Color _parseHexColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    return const Color(0xFF6C63FF);
  }

  Widget _buildFallback(BuildContext context) {
    final accent = _parseHexColor(item.accentColorHex);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.55),
            const Color(0xFF161B26),
            const Color(0xFF0B0E14),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          item.source == WallpaperSource.cloud
              ? Icons.cloud_done_rounded
              : Icons.wallpaper_rounded,
          color: Colors.white54,
          size: 34,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (item.source) {
      case WallpaperSource.asset:
        return Image.asset(
          item.path,
          fit: fit,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) => _buildFallback(context),
        );
      case WallpaperSource.cloud:
        return Image.network(
          item.path,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _buildFallback(context),
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Color(0xFF00E5FF),
                    ),
                  ),
                ),
              ],
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildFallback(context),
        );
      case WallpaperSource.gallery:
        return Image.file(
          File(item.path),
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(context),
        );
    }
  }
}

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final WallpaperItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161B26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Hero(
                tag: 'wallpaper_${item.id}',
                child: WallpaperImageView(item: item),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0x22000000),
                      Color(0x00000000),
                      Color(0xDD080B11),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xAA0B0E14),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    item.resolutionLabel,
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite
                        ? const Color(0xFFFF4757)
                        : Colors.white70,
                    size: 20,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category,
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
        ),
      ),
    );
  }
}
