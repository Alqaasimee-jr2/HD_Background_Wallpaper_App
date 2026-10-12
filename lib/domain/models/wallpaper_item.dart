enum WallpaperSource {
  asset,
  cloud,
  gallery,
}

enum MockupMode {
  clean,
  lockScreen,
  homeScreen,
}

class WallpaperItem {
  const WallpaperItem({
    required this.id,
    required this.title,
    required this.path,
    required this.category,
    required this.source,
    required this.accentColorHex,
    this.resolutionLabel = '4K UHD',
  });

  final String id;
  final String title;
  final String path;
  final String category;
  final WallpaperSource source;
  final String accentColorHex;
  final String resolutionLabel;

  String get fileName {
    final normalized = path.replaceAll('\\', '/');
    final slashIndex = normalized.lastIndexOf('/');
    return slashIndex >= 0 ? normalized.substring(slashIndex + 1) : normalized;
  }
}
