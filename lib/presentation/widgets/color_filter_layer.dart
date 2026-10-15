import 'package:flutter/material.dart';

enum WallpaperFilterMode {
  none,
  grayscale,
  inverted,
  sepia,
}

class ColorFilterLayer extends StatelessWidget {
  const ColorFilterLayer({
    super.key,
    required this.child,
    required this.mode,
  });

  final Widget child;
  final WallpaperFilterMode mode;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case WallpaperFilterMode.none:
        return child;
      case WallpaperFilterMode.grayscale:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0,      0,      0,      1, 0,
          ]),
          child: child,
        );
      case WallpaperFilterMode.inverted:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            -1,  0,  0, 0, 255,
             0, -1,  0, 0, 255,
             0,  0, -1, 0, 255,
             0,  0,  0, 1, 0,
          ]),
          child: child,
        );
      case WallpaperFilterMode.sepia:
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.393, 0.769, 0.189, 0, 0,
            0.349, 0.686, 0.168, 0, 0,
            0.272, 0.534, 0.131, 0, 0,
            0,     0,     0,     1, 0,
          ]),
          child: child,
        );
    }
  }
}
