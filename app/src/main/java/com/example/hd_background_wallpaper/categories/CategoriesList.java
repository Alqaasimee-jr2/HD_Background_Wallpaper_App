package com.example.hd_background_wallpaper.categories;

public class CategoriesList {
    private final String name;
    private final String coverAsset;
    private final int count;

    public CategoriesList(String name, String coverAsset, int count) {
        this.name = name;
        this.coverAsset = coverAsset;
        this.count = count;
    }

    public String getName() {
        return name;
    }

    public String getCoverAsset() {
        return coverAsset;
    }

    public int getCount() {
        return count;
    }
}
