package com.example.hd_background_wallpaper;

import org.junit.Test;
import static org.junit.Assert.*;

import com.example.hd_background_wallpaper.wallpapers.WallpaperCatalog;
import com.example.hd_background_wallpaper.wallpapers.WallpapersList;

import java.util.Arrays;
import java.util.List;

public class ExampleUnitTest {

    @Test
    public void testCategorizeAsset_mapsAllCategoriesCorrectly() {
        assertEquals("Game Wallpapers", WallpaperCatalog.categorizeFileName("game22.jpg"));
        assertEquals("Game Wallpapers", WallpaperCatalog.categorizeFileName("VALORANT Phone Wallpaper.png"));
        assertEquals("Game Wallpapers", WallpaperCatalog.categorizeFileName("God Of War.jfif"));
        assertEquals("Anime", WallpaperCatalog.categorizeFileName("waterfall anime.jpg"));
        assertEquals("Anime", WallpaperCatalog.categorizeFileName("Sage mode naruto.jpg"));
        assertEquals("Nature", WallpaperCatalog.categorizeFileName("Lush greens and lake.jpg"));
        assertEquals("Abstract Art", WallpaperCatalog.categorizeFileName("abstract splash.jpg"));
        assertEquals("Black Wallpapers", WallpaperCatalog.categorizeFileName("black halo.jpg"));
        assertEquals("Random Wallpapers", WallpaperCatalog.categorizeFileName("chess.jpg"));
    }

    @Test
    public void testFilterWallpapers_byCategoryAndSearchQuery() {
        List<String> sampleAssets = Arrays.asList(
                "nature_bg.jpg",
                "game22.jpg",
                "waterfall anime.jpg",
                "ds2.jpeg",
                "black halo.jpg"
        );
        List<WallpapersList> all = WallpaperCatalog.buildFromAssetNames(sampleAssets);
        assertEquals(5, all.size());

        List<WallpapersList> games = WallpaperCatalog.filter(all, "Game Wallpapers", "");
        assertEquals(1, games.size());
        assertEquals("game22.jpg", games.get(0).getFileName());

        List<WallpapersList> searchAnime = WallpaperCatalog.filter(all, "All Wallpapers", "waterfall");
        assertEquals(1, searchAnime.size());
        assertEquals("waterfall anime.jpg", searchAnime.get(0).getFileName());
    }
}