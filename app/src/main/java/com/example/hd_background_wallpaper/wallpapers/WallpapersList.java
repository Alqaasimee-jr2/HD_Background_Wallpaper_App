package com.example.hd_background_wallpaper.wallpapers;

public class WallpapersList {
    public static final String SOURCE_ASSET = "ASSET";
    public static final String SOURCE_CLOUD = "CLOUD";
    public static final String SOURCE_GALLERY = "GALLERY";

    private final String id;
    private final String title;
    private final String fileName;
    private final String category;
    private final String sourceType;

    public WallpapersList(String fileName, String category) {
        this(fileName, WallpaperCatalog.formatDisplayName(fileName), fileName, category, SOURCE_ASSET);
    }

    public WallpapersList(String id, String title, String fileName, String category, String sourceType) {
        this.id = id;
        this.title = title;
        this.fileName = fileName;
        this.category = category;
        this.sourceType = sourceType;
    }

    public String getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getFileName() {
        return fileName;
    }

    public String getCategory() {
        return category;
    }

    public String getSourceType() {
        return sourceType;
    }
}
