package com.example.hd_background_wallpaper.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.example.hd_background_wallpaper.wallpapers.WallpaperCatalog;
import com.example.hd_background_wallpaper.wallpapers.WallpapersList;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class CollectionsManager {

    private static final String PREF_NAME = "hd_wallpaper_collections_prefs";
    private static final String KEY_FAVORITES = "favorites_set";
    private static final String KEY_FOLDERS = "custom_folders_set";
    private static final String KEY_FOLDER_PREFIX = "folder_items_";
    private static final String KEY_GALLERY_URIS = "gallery_uris_set";

    private final SharedPreferences prefs;

    public CollectionsManager(Context context) {
        this.prefs = context.getApplicationContext().getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
    }

    public boolean isFavorite(String fileName) {
        return getFavorites().contains(fileName);
    }

    public boolean toggleFavorite(String fileName) {
        Set<String> favs = new LinkedHashSet<>(getFavorites());
        boolean added;
        if (favs.contains(fileName)) {
            favs.remove(fileName);
            added = false;
        } else {
            favs.add(fileName);
            added = true;
        }
        prefs.edit().putStringSet(KEY_FAVORITES, favs).apply();
        return added;
    }

    public Set<String> getFavorites() {
        return prefs.getStringSet(KEY_FAVORITES, new HashSet<>());
    }

    public List<String> getCustomFolders() {
        Set<String> set = prefs.getStringSet(KEY_FOLDERS, new LinkedHashSet<>());
        List<String> list = new ArrayList<>(set);
        if (list.isEmpty()) {
            list.add("AMOLED Setup");
            list.add("Lock Screen Picks");
        }
        return list;
    }

    public void createFolder(String folderName) {
        if (folderName == null || folderName.trim().isEmpty()) return;
        Set<String> folders = new LinkedHashSet<>(getCustomFolders());
        folders.add(folderName.trim());
        prefs.edit().putStringSet(KEY_FOLDERS, folders).apply();
    }

    public void addWallpaperToFolder(String folderName, String fileName) {
        createFolder(folderName);
        String key = KEY_FOLDER_PREFIX + folderName;
        Set<String> items = new LinkedHashSet<>(prefs.getStringSet(key, new HashSet<>()));
        items.add(fileName);
        prefs.edit().putStringSet(key, items).apply();
    }

    public Set<String> getFolderItems(String folderName) {
        return prefs.getStringSet(KEY_FOLDER_PREFIX + folderName, new HashSet<>());
    }

    public void addImportedGalleryUri(String uriString) {
        if (uriString == null || uriString.isEmpty()) return;
        Set<String> uris = new LinkedHashSet<>(getImportedGalleryUris());
        uris.add(uriString);
        prefs.edit().putStringSet(KEY_GALLERY_URIS, uris).apply();
    }

    public Set<String> getImportedGalleryUris() {
        return prefs.getStringSet(KEY_GALLERY_URIS, new HashSet<>());
    }

    public List<WallpapersList> getImportedWallpapersList() {
        List<WallpapersList> list = new ArrayList<>();
        int index = 1;
        for (String uri : getImportedGalleryUris()) {
            list.add(new WallpapersList(
                    "gallery_" + index,
                    "Imported Wallpaper #" + index,
                    uri,
                    WallpaperCatalog.CAT_CUSTOM,
                    WallpapersList.SOURCE_GALLERY
            ));
            index++;
        }
        return list;
    }
}
