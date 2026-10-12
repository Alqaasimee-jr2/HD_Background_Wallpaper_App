package com.example.hd_background_wallpaper.utils;

import com.example.hd_background_wallpaper.wallpapers.WallpaperCatalog;
import com.example.hd_background_wallpaper.wallpapers.WallpapersList;

import java.util.ArrayList;
import java.util.List;

public class CloudWallpaperService {

    private static final String[][] CURATED_CLOUD_WALLPAPERS = new String[][]{
            {"cloud_1", "Cyberpunk Neon Horizon 4K", "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1440&q=85"},
            {"cloud_2", "Aurora Borealis Night Sky", "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=1440&q=85"},
            {"cloud_3", "Alpine Peaks at Dusk", "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1440&q=85"},
            {"cloud_4", "Deep Space Nebula 4K", "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1440&q=85"},
            {"cloud_5", "Minimal Dark Architecture", "https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1440&q=85"},
            {"cloud_6", "Tokyo Midnight Rain", "https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=1440&q=85"},
            {"cloud_7", "Bioluminescent Ocean Waves", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1440&q=85"},
            {"cloud_8", "Liquid Gold & Obsidian Abstract", "https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=1440&q=85"},
            {"cloud_9", "Misty Redwood Forest", "https://images.unsplash.com/photo-1511497584788-876760111969?w=1440&q=85"},
            {"cloud_10", "Futuristic Synthwave Grid", "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1440&q=85"},
            {"cloud_11", "Desert Dunes Golden Hour", "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=1440&q=85"},
            {"cloud_12", "Emerald Glacier Lagoon", "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=1440&q=85"}
    };

    public static List<WallpapersList> getCloudWallpapers() {
        List<WallpapersList> list = new ArrayList<>();
        for (String[] entry : CURATED_CLOUD_WALLPAPERS) {
            list.add(new WallpapersList(
                    entry[0],
                    entry[1],
                    entry[2],
                    WallpaperCatalog.CAT_CLOUD,
                    WallpapersList.SOURCE_CLOUD
            ));
        }
        return list;
    }
}
