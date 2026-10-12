class CustomCollection {
  const CustomCollection({
    required this.name,
    required this.wallpaperIds,
    required this.createdAt,
  });

  final String name;
  final List<String> wallpaperIds;
  final DateTime createdAt;

  CustomCollection copyWith({
    String? name,
    List<String>? wallpaperIds,
    DateTime? createdAt,
  }) {
    return CustomCollection(
      name: name ?? this.name,
      wallpaperIds: wallpaperIds ?? this.wallpaperIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
