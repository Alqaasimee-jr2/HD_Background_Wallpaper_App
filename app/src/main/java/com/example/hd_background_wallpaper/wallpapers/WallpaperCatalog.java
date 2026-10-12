package com.example.hd_background_wallpaper.wallpapers;

import android.content.Context;
import android.content.res.AssetManager;

import com.example.hd_background_wallpaper.categories.CategoriesList;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

public class WallpaperCatalog {

    public static final String CAT_ALL = "All Wallpapers";
    public static final String CAT_NATURE = "Nature";
    public static final String CAT_ANIME = "Anime";
    public static final String CAT_ABSTRACT = "Abstract Art";
    public static final String CAT_BLACK = "Black Wallpapers";
    public static final String CAT_GAME = "Game Wallpapers";
    public static final String CAT_RANDOM = "Random Wallpapers";
    public static final String CAT_CLOUD = "Cloud 4K Online";
    public static final String CAT_FAVORITES = "Favorites";
    public static final String CAT_CUSTOM = "My Collections & Gallery";

    private static List<WallpapersList> cachedWallpapers = null;

    public static synchronized List<WallpapersList> loadAllAssets(Context context) {
        if (cachedWallpapers != null && !cachedWallpapers.isEmpty()) {
            return new ArrayList<>(cachedWallpapers);
        }
        AssetManager assetManager = context.getAssets();
        try {
            String[] files = assetManager.list("");
            if (files == null) {
                return Collections.emptyList();
            }
            cachedWallpapers = buildFromAssetNames(Arrays.asList(files));
            return new ArrayList<>(cachedWallpapers);
        } catch (IOException e) {
            return Collections.emptyList();
        }
    }

    public static List<WallpapersList> buildFromAssetNames(List<String> fileNames) {
        List<WallpapersList> result = new ArrayList<>();
        for (String name : fileNames) {
            if (isImageFile(name)) {
                String category = categorizeFileName(name);
                result.add(new WallpapersList(name, category));
            }
        }
        return result;
    }

    public static boolean isImageFile(String name) {
        if (name == null) return false;
        String lower = name.toLowerCase(Locale.US);
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".jfif") || lower.endsWith(".webp");
    }

    public static String categorizeFileName(String fileName) {
        String lower = fileName.toLowerCase(Locale.US);
        if (lower.startsWith("game") || lower.contains("valorant") || lower.contains("gta")
                || lower.contains("overwatch") || lower.contains("apex") || lower.contains("among us")
                || lower.contains("free fire") || lower.contains("god of war") || lower.contains("call of duty")
                || lower.contains("titanfall") || lower.contains("spider-man") || lower.contains("vergil")) {
            return CAT_GAME;
        }
        if (lower.contains("anime") || lower.startsWith("ani") || lower.contains("naruto")
                || lower.contains("luffy") || lower.contains("onepiece") || lower.contains("goku")
                || lower.contains("itachi") || lower.contains("kakas") || lower.contains("obito")
                || lower.contains("pain bg") || lower.contains("akatsuki") || lower.contains("team 7")
                || lower.contains("anya") || lower.contains("asuka") || lower.contains("baki")
                || lower.contains("demon slayer") || lower.startsWith("ds") || lower.contains("fire#force")
                || lower.contains("hero accademia") || lower.contains("juijutsu") || lower.contains("mob psycho")
                || lower.contains("power") || lower.contains("sin of pride") || lower.contains("your name")
                || lower.contains("laugh tale") || lower.contains("hounds") || lower.contains("dream")) {
            return CAT_ANIME;
        }
        if (lower.startsWith("nat") || lower.contains("nature") || lower.contains("mountain")
                || lower.contains("tree") || lower.contains("lush") || lower.contains("creek")
                || lower.contains("flower") || lower.contains("lke") || lower.contains("pine")
                || lower.contains("leaves") || lower.contains("snowy")) {
            return CAT_NATURE;
        }
        if (lower.startsWith("abs") || lower.contains("abstract") || lower.contains("neon")
                || lower.contains("pallette") || lower.contains("colab") || lower.contains("splash")) {
            return CAT_ABSTRACT;
        }
        if (lower.contains("black") || lower.contains("dark") || lower.startsWith("b2b")
                || lower.startsWith("bb") || lower.contains("error~code") || lower.contains("low bar")
                || lower.contains("astro") || lower.contains("death~time")) {
            return CAT_BLACK;
        }
        return CAT_RANDOM;
    }

    public static String formatDisplayName(String fileName) {
        if (fileName == null) return "Wallpaper";
        int dot = fileName.lastIndexOf('.');
        String base = dot > 0 ? fileName.substring(0, dot) : fileName;
        base = base.replace('_', ' ').replace('~', ' ').replace('@', ' ').replace('#', ' ').trim();
        if (base.isEmpty()) return "HD Wallpaper";
        return Character.toUpperCase(base.charAt(0)) + base.substring(1);
    }

    public static List<WallpapersList> filter(List<WallpapersList> source, String category, String query) {
        String normalizedQuery = query == null ? "" : query.trim().toLowerCase(Locale.US);
        List<WallpapersList> filtered = new ArrayList<>();
        for (WallpapersList item : source) {
            boolean matchesCategory = category == null || category.isEmpty()
                    || CAT_ALL.equalsIgnoreCase(category)
                    || item.getCategory().equalsIgnoreCase(category);
            boolean matchesQuery = normalizedQuery.isEmpty()
                    || item.getTitle().toLowerCase(Locale.US).contains(normalizedQuery)
                    || item.getFileName().toLowerCase(Locale.US).contains(normalizedQuery)
                    || item.getCategory().toLowerCase(Locale.US).contains(normalizedQuery);
            if (matchesCategory && matchesQuery) {
                filtered.add(item);
            }
        }
        return filtered;
    }

    public static List<CategoriesList> buildCategories(List<WallpapersList> allAssets, int favoritesCount, int customCount) {
        List<CategoriesList> categories = new ArrayList<>();
        categories.add(new CategoriesList(CAT_ALL, "nature_bg.jpg", allAssets.size()));
        categories.add(new CategoriesList(CAT_NATURE, "nature_bg.jpg", filter(allAssets, CAT_NATURE, "").size()));
        categories.add(new CategoriesList(CAT_ANIME, "anime boy.jpg", filter(allAssets, CAT_ANIME, "").size()));
        categories.add(new CategoriesList(CAT_ABSTRACT, "abstract art wallpaper.jpg", filter(allAssets, CAT_ABSTRACT, "").size()));
        categories.add(new CategoriesList(CAT_BLACK, "black bg wallpaper.jpg", filter(allAssets, CAT_BLACK, "").size()));
        categories.add(new CategoriesList(CAT_GAME, "game.jpeg", filter(allAssets, CAT_GAME, "").size()));
        categories.add(new CategoriesList(CAT_RANDOM, "Feels bg.jpg", filter(allAssets, CAT_RANDOM, "").size()));
        categories.add(new CategoriesList(CAT_CLOUD, "Solar system.jpg", 12));
        categories.add(new CategoriesList(CAT_FAVORITES, "anya cute.jpg", favoritesCount));
        categories.add(new CategoriesList(CAT_CUSTOM, "Pallette painting.jpg", customCount));
        return categories;
    }
}
