import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/models/wallpaper_item.dart';

class WallpaperImageView extends StatelessWidget {
  const WallpaperImageView({
    super.key,
    required this.item,
    this.fit = BoxFit.cover,
    this.isThumbnail = false,
  });

  final WallpaperItem item;
  final BoxFit fit;
  final bool isThumbnail;

  static Color parseHexColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    return const Color(0xFF6C63FF);
  }

  Widget _buildFallback(BuildContext context) {
    final accent = parseHexColor(item.accentColorHex);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            accent.withValues(alpha: 0.45),
            const Color(0xFF111520),
            const Color(0xFF06080D),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          item.source == WallpaperSource.cloud
              ? Icons.cloud_done_rounded
              : Icons.wallpaper_rounded,
          color: Colors.white54,
          size: 32,
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
          cacheWidth: isThumbnail ? 540 : null,
          gaplessPlayback: true,
          filterQuality: isThumbnail ? FilterQuality.low : FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) => _buildFallback(context),
        );
      case WallpaperSource.cloud:
        return Image.network(
          item.path,
          fit: fit,
          gaplessPlayback: true,
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
          cacheWidth: isThumbnail ? 540 : null,
          gaplessPlayback: true,
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
    this.compact = false,
  });

  final WallpaperItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = WallpaperImageView.parseHexColor(item.accentColorHex);
    final radius = compact ? 16.0 : 20.0;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111520),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: isFavorite
                  ? const Color(0x88FF4757)
                  : accent.withValues(alpha: 0.22),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Hero(
                tag: 'wallpaper_${item.id}',
                child: WallpaperImageView(item: item, isThumbnail: true),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: <double>[0.0, 0.48, 1.0],
                    colors: <Color>[
                      Color(0x38000000),
                      Color(0x00000000),
                      Color(0xEB05070B),
                    ],
                  ),
                ),
              ),
              if (!compact)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xB806080D),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      item.resolutionLabel,
                      style: TextStyle(
                        color: accent,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: compact ? 4 : 6,
                right: compact ? 4 : 6,
                child: Material(
                  color: const Color(0x9906080D),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onToggleFavorite,
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 6.0 : 7.5),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite
                            ? const Color(0xFFFF4757)
                            : Colors.white70,
                        size: compact ? 16 : 18,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: compact ? 8 : 12,
                right: compact ? 8 : 12,
                bottom: compact ? 8 : 11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 11.5 : 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFFB4BECC),
                              fontSize: compact ? 10 : 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
