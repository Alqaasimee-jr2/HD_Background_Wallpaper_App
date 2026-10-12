# HD Background Wallpaper App (Phase 3 & Phase 4) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Sequentially overhaul the existing Java Android wallpaper app (fixing all 8 critical crashes/memory leaks, unlocking all 266 assets, and adding Search, Favorites, Custom Collections, Device Gallery Import, Cloud 4K Wallpapers, and Live Lock/Home Screen Mockup Previews) and then perform a full in-place migration to Flutter with complete feature parity and native Android wallpaper integration.

**Architecture:**
- **Phase 3 (Java/Android Overhaul):** Replaces hardcoded `Bitmap` lists with lightweight `WallpapersList` item models backed by `WallpaperCatalog` (dynamic asset classification across all 266 images + cloud items + imported gallery URIs), `ImageLoader` (`LruCache` + subsampled background decoding), `CollectionsManager` (`SharedPreferences` persistence for Favorites and custom folders), and interactive `WallpaperView` overlays.
- **Phase 4 (Full Flutter In-Place Migration):** Replaces the legacy Gradle project root with a layered Flutter architecture (`lib/domain`, `lib/data`, `lib/presentation`) housing all 266 wallpaper assets in `assets/wallpapers/`, online cloud wallpaper fetching, custom collections & gallery import, interactive pinch-to-zoom + Live Lock/Home Screen mockup overlays, and an Android `MethodChannel` (`com.example.hd_background_wallpaper/wallpaper`) for setting Home/Lock/Both wallpapers and saving to `MediaStore`.

**Tech Stack:**
- **Phase 3:** Java 8, Android SDK 33, AndroidX AppCompat/RecyclerView/ConstraintLayout, JUnit 4.
- **Phase 4:** Flutter / Dart 3, Material 3, `shared_preferences`, `http`, `image_picker`, `flutter_test`, Android Kotlin/Java `MethodChannel` (`WallpaperManager`, `MediaStore`).

---

## PART 1: PHASE 3 — JAVA / ANDROID OVERHAUL & FEATURE EXPANSION

### Task 1: Dynamic Asset Catalog & Smart Categorizer (Unlocking All 266 Wallpapers + Fixing Asset Bugs)

**Files:**
- Create: `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/WallpaperCatalog.java`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/categories/CategoriesList.java`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/WallpapersList.java`
- Modify: `app/src/test/java/com/example/hd_background_wallpaper/ExampleUnitTest.java`

- [ ] **Step 1: Write unit tests for `WallpaperCatalog` classification, search, and lightweight models**

Update `app/src/test/java/com/example/hd_background_wallpaper/ExampleUnitTest.java`:

```java
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
```

- [ ] **Step 2: Refactor `CategoriesList.java` and `WallpapersList.java` to eliminate raw `Bitmap` references**

Update `app/src/main/java/com/example/hd_background_wallpaper/categories/CategoriesList.java`:

```java
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
```

Update `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/WallpapersList.java`:

```java
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
```

- [ ] **Step 3: Create `WallpaperCatalog.java` to index all 266 assets, cloud items, and search queries**

Create `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/WallpaperCatalog.java`:

```java
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
        categories.add(new CategoriesList(CAT_CLOUD, "Solar system.jpg", 24));
        categories.add(new CategoriesList(CAT_FAVORITES, "anya cute.jpg", favoritesCount));
        categories.add(new CategoriesList(CAT_CUSTOM, "Pallette painting.jpg", customCount));
        return categories;
    }
}
```

---

### Task 2: Async Thumbnail Loader (`LruCache`), Collections/Gallery Manager & Cloud 4K Service

**Files:**
- Create: `app/src/main/java/com/example/hd_background_wallpaper/utils/ImageLoader.java`
- Create: `app/src/main/java/com/example/hd_background_wallpaper/utils/CollectionsManager.java`
- Create: `app/src/main/java/com/example/hd_background_wallpaper/utils/CloudWallpaperService.java`

- [ ] **Step 1: Create `ImageLoader.java` with `LruCache`, subsampled decoding (`inSampleSize`), URI & HTTPS support, and safe stream closing**

Create `app/src/main/java/com/example/hd_background_wallpaper/utils/ImageLoader.java`:

```java
package com.example.hd_background_wallpaper.utils;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.LruCache;
import android.widget.ImageView;

import com.example.hd_background_wallpaper.wallpapers.WallpapersList;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ImageLoader {

    private static ImageLoader instance;
    private final LruCache<String, Bitmap> memoryCache;
    private final ExecutorService executorService;
    private final Handler mainHandler;

    private ImageLoader() {
        final int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
        final int cacheSize = Math.max(4 * 1024, maxMemory / 6);
        memoryCache = new LruCache<String, Bitmap>(cacheSize) {
            @Override
            protected int sizeOf(String key, Bitmap bitmap) {
                return bitmap.getByteCount() / 1024;
            }
        };
        executorService = Executors.newFixedThreadPool(4);
        mainHandler = new Handler(Looper.getMainLooper());
    }

    public static synchronized ImageLoader getInstance() {
        if (instance == null) {
            instance = new ImageLoader();
        }
        return instance;
    }

    public void loadThumbnail(final Context context, final WallpapersList item, final ImageView imageView, final int reqWidth, final int reqHeight) {
        final String cacheKey = item.getSourceType() + ":" + item.getFileName() + ":" + reqWidth + "x" + reqHeight;
        imageView.setTag(cacheKey);

        Bitmap cached = memoryCache.get(cacheKey);
        if (cached != null && !cached.isRecycled()) {
            imageView.setImageBitmap(cached);
            return;
        }

        imageView.setImageBitmap(null);
        final Context appContext = context.getApplicationContext();
        executorService.execute(() -> {
            final Bitmap decoded = decodeBitmap(appContext, item.getFileName(), item.getSourceType(), reqWidth, reqHeight);
            if (decoded != null) {
                memoryCache.put(cacheKey, decoded);
                mainHandler.post(() -> {
                    if (cacheKey.equals(imageView.getTag())) {
                        imageView.setImageBitmap(decoded);
                    }
                });
            }
        });
    }

    public void loadAssetThumbnail(final Context context, final String assetName, final ImageView imageView, final int reqWidth, final int reqHeight) {
        WallpapersList item = new WallpapersList(assetName, "");
        loadThumbnail(context, item, imageView, reqWidth, reqHeight);
    }

    public Bitmap decodeFullBitmap(Context context, String pathOrUrl, String sourceType) {
        return decodeBitmap(context.getApplicationContext(), pathOrUrl, sourceType, 1440, 2560);
    }

    private Bitmap decodeBitmap(Context context, String pathOrUrl, String sourceType, int reqWidth, int reqHeight) {
        try {
            byte[] bytes = readAllBytes(context, pathOrUrl, sourceType);
            if (bytes == null || bytes.length == 0) return null;

            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);

            options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
            options.inJustDecodeBounds = false;
            options.inPreferredConfig = Bitmap.Config.RGB_565;
            return BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);
        } catch (Exception e) {
            return null;
        }
    }

    private byte[] readAllBytes(Context context, String pathOrUrl, String sourceType) throws IOException {
        if (WallpapersList.SOURCE_CLOUD.equals(sourceType)) {
            HttpURLConnection conn = (HttpURLConnection) new URL(pathOrUrl).openConnection();
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(8000);
            conn.setInstanceFollowRedirects(true);
            try (InputStream is = conn.getInputStream()) {
                return streamToBytes(is);
            } finally {
                conn.disconnect();
            }
        } else if (WallpapersList.SOURCE_GALLERY.equals(sourceType)) {
            try (InputStream is = context.getContentResolver().openInputStream(Uri.parse(pathOrUrl))) {
                return is != null ? streamToBytes(is) : null;
            }
        } else {
            AssetManager assets = context.getAssets();
            try (InputStream is = assets.open(pathOrUrl)) {
                return streamToBytes(is);
            }
        }
    }

    private byte[] streamToBytes(InputStream is) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[8192];
        int nRead;
        while ((nRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        return buffer.toByteArray();
    }

    public static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {
            final int halfHeight = height / 2;
            final int halfWidth = width / 2;
            while ((halfHeight / inSampleSize) >= reqHeight && (halfWidth / inSampleSize) >= reqWidth) {
                inSampleSize *= 2;
            }
        }
        return Math.max(1, inSampleSize);
    }
}
```

- [ ] **Step 2: Create `CollectionsManager.java` for Favorites, Custom Folders, and Device Gallery Imports**

Create `app/src/main/java/com/example/hd_background_wallpaper/utils/CollectionsManager.java`:

```java
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
```

- [ ] **Step 3: Create `CloudWallpaperService.java` for online 4K wallpapers**

Create `app/src/main/java/com/example/hd_background_wallpaper/utils/CloudWallpaperService.java`:

```java
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
```

---

### Task 3: Overhaul Java Activities, Adapters & XML Layouts (Search, Import, Live Lock/Home Mockup, Target Picker)

**Files:**
- Modify: `app/src/main/res/layout/categories_adapter_layout.xml`
- Modify: `app/src/main/res/layout/wallpapers_adapter_layout.xml`
- Modify: `app/src/main/res/layout/activity_main.xml`
- Modify: `app/src/main/res/layout/activity_wallpapers.xml`
- Modify: `app/src/main/res/layout/activity_wallpaper_view.xml`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/categories/CategoriesAdapter.java`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/WallpapersAdapter.java`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/MainActivity.java`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/Wallpapers.java`
- Modify: `app/src/main/java/com/example/hd_background_wallpaper/wallpapers/WallpaperView.java`

- [ ] **Step 1: Fix `RecyclerView` adapter item XMLs and add Search, Gallery Import, and Live Lock/Home Screen Mockup UI in layouts**

Update `app/src/main/res/layout/categories_adapter_layout.xml` (`wrap_content` height + item count badge) and `app/src/main/res/layout/wallpapers_adapter_layout.xml` (`wrap_content` height + title/favorite badge).
Update `app/src/main/res/layout/activity_main.xml` to add a Search bar and Quick Import from Gallery button.
Update `app/src/main/res/layout/activity_wallpapers.xml` to add an inline Search input and Import button.
Update `app/src/main/res/layout/activity_wallpaper_view.xml` to include:
- Top bar with Back button, Favorite toggle button, Add to Collection button, and Save/Share button.
- **Live Lock Screen Mockup Overlay** (`lockMockupOverlay`: large `22:18` clock, date `Mon, Oct 12`, glassmorphic notification card).
- **Live Home Screen Mockup Overlay** (`homeMockupOverlay`: status bar, search pill, and bottom app dock icons).
- Bottom control bar with **Mockup Mode Toggle** (`Clean` / `Lock Screen` / `Home Screen`) and **Set Wallpaper** button.

- [ ] **Step 2: Update `CategoriesAdapter.java`, `WallpapersAdapter.java`, `MainActivity.java`, `Wallpapers.java`, and `WallpaperView.java`**

- `CategoriesAdapter` and `WallpapersAdapter` use `LayoutInflater.from(parent.getContext()).inflate(..., parent, false)` and `ImageLoader.getInstance().loadThumbnail(...)`.
- `MainActivity` loads all 266 assets dynamically via `WallpaperCatalog.loadAllAssets(this)`, supports live search jumping directly into filtered results, and allows importing custom wallpapers from the device gallery (`Intent.ACTION_OPEN_DOCUMENT`).
- `Wallpapers` replaces the 884-line hardcoded `BitmapFactory.decodeStream` block with clean dynamic filtering (`WallpaperCatalog`, `CloudWallpaperService`, `CollectionsManager`), eliminating all 8 bugs and OOMs.
- `WallpaperView` adds:
  - Cycling through **Clean View -> Lock Screen Mockup -> Home Screen Mockup**.
  - **Set Wallpaper Target Dialog** (`Home Screen`, `Lock Screen`, `Both`) using `WallpaperManager.FLAG_SYSTEM` and `WallpaperManager.FLAG_LOCK` on a background thread.
  - **Favorite toggle** & **Add to Custom Collection Folder dialog**.
  - **Save to Device Gallery (`MediaStore`)** & **Share**.

- [ ] **Step 3: Commit the completed Phase 3 Java Overhaul to git**

Run:
```powershell
git add -A; git commit -m "feat(phase3): fix all 8 critical bugs, unlock all 266 assets, add async cache, cloud 4K, collections, and live mockup preview"
```

---

## PART 2: PHASE 4 — FULL FLUTTER IN-PLACE MIGRATION

### Task 4: In-Place Flutter Project Structure & Asset Migration (266 Bundled Wallpapers)

**Files:**
- Move: `app/src/main/assets/*` -> `assets/wallpapers/*`
- Create: `pubspec.yaml`
- Create: `analysis_options.yaml`
- Modify: `android/app/src/main/kotlin/com/example/hd_background_wallpaper/MainActivity.kt` (or Java equivalent for native `MethodChannel`)

- [ ] **Step 1: Initialize Flutter scaffold in-place inside `HD_Background_Wallpaper_App` while preserving all 266 wallpaper assets in `assets/wallpapers/`**

Move the 266 images into `assets/wallpapers/`, configure `pubspec.yaml` with `assets/wallpapers/`, `shared_preferences`, `http`, and `image_picker`, and configure the Android host project with `SET_WALLPAPER` permission and a native `MethodChannel('com.example.hd_background_wallpaper/wallpaper')` that supports:
- `setWallpaper` (`target`: `home`, `lock`, `both`) via `WallpaperManager`
- `saveToGallery` (`bytes`, `fileName`) via `MediaStore.Images.Media`

---

### Task 5: Flutter Domain & Data Layers (266 Offline Assets + Cloud 4K + Custom Collections + Gallery Import)

**Files:**
- Create: `lib/domain/models/wallpaper_item.dart`
- Create: `lib/domain/models/custom_collection.dart`
- Create: `lib/data/services/wallpaper_catalog_service.dart`
- Create: `lib/data/services/collections_storage_service.dart`
- Create: `lib/data/services/native_wallpaper_bridge.dart`
- Create: `lib/presentation/state/wallpaper_controller.dart`

- [ ] **Step 1: Implement `WallpaperItem`, `CustomCollection`, and `WallpaperCatalogService`**
- Automatically loads all 266 bundled wallpapers from `AssetManifest.loadFromAssetBundle(rootBundle)` (with a deterministic fallback list of all 266 filenames for unit test environments).
- Categorizes every wallpaper into `Nature`, `Anime`, `Abstract Art`, `Black Wallpapers`, `Game Wallpapers`, and `Random Wallpapers`.
- Provides curated **Cloud 4K Wallpapers** with topic filtering (`Cyberpunk`, `Space`, `Nature`, `AMOLED`, `Anime`, `Minimal`).
- Extracts dominant accent color palette tags per category/wallpaper.

- [ ] **Step 2: Implement `CollectionsStorageService` & `WallpaperController`**
- Persists Favorites, user-created Custom Collections/Folders, and imported Device Gallery image paths via `SharedPreferences`.
- Exposes reactive `ChangeNotifier` state for search queries, active category, favorites, custom collections, and mockup overlay mode.

---

### Task 6: Flutter Presentation Layer (Material 3 Dark Glassmorphic UI & Live Preview Mockups)

**Files:**
- Create: `lib/main.dart`
- Create: `lib/presentation/screens/home_shell_screen.dart`
- Create: `lib/presentation/screens/explore_tab.dart`
- Create: `lib/presentation/screens/cloud_tab.dart`
- Create: `lib/presentation/screens/collections_tab.dart`
- Create: `lib/presentation/screens/category_wallpapers_screen.dart`
- Create: `lib/presentation/screens/wallpaper_detail_screen.dart`
- Create: `lib/presentation/widgets/live_mockup_overlays.dart`
- Create: `lib/presentation/widgets/wallpaper_card.dart`

- [ ] **Step 1: Build the 3-Tab Navigation Shell (`Explore 266`, `Cloud 4K`, `Collections & Gallery`)**
- **Explore Tab:** Search bar, horizontal category chips, featured banner, category grid cards with live item counts, and instant filtered wallpaper grid.
- **Cloud 4K Tab:** Online high-res wallpaper feed with topic chips and instant preview.
- **Collections Tab:** Favorites grid, user-created custom folders (`Create Collection` dialog), and `Import from Gallery` action (`ImagePicker`).

- [ ] **Step 2: Build `WallpaperDetailScreen` with Interactive Zoom, Live Lock/Home Screen Mockup Overviews, and Target Picker**
- Interactive pinch-to-zoom (`InteractiveViewer`).
- Segmented Mockup Mode switcher:
  1. **Clean View** (unobstructed 4K preview)
  2. **Lock Screen Mockup** (realistic digital clock, date, lock icon, notification cards, bottom camera/flashlight shortcuts)
  3. **Home Screen Mockup** (status bar, weather/search widget, app icon grid, glassmorphic bottom dock)
- Bottom action sheet:
  - **Set Wallpaper** -> Modal bottom sheet with **Home Screen**, **Lock Screen**, and **Both Screens** options.
  - **Add to Collection / Favorite** -> Toggle heart or assign to any custom folder.
  - **Save to Device Gallery** -> Writes image to gallery via native bridge.

---

### Task 7: Verification, Static Analysis & Automated Tests (`flutter test` & `dart analyze`)

**Files:**
- Create: `test/wallpaper_catalog_test.dart`
- Create: `test/widget_test.dart`

- [ ] **Step 1: Write unit and widget tests verifying categorization, search, collections, and UI flows**
- Verify `WallpaperCatalogService` categorizes `game22.jpg`, `waterfall anime.jpg`, `ds2.jpeg`, and all categories accurately.
- Verify `WallpaperController` toggles favorites, creates custom folders, and filters wallpapers by search query.
- Verify the Flutter app renders the Explore screen, switches to Cloud 4K and Collections tabs, and opens the Live Preview Mockup modes.

- [ ] **Step 2: Run `dart analyze` and `flutter test`, then commit Phase 4**
Run:
```powershell
flutter analyze
flutter test
git add -A; git commit -m "feat(phase4): complete full in-place Flutter migration with 266 assets, cloud 4K, custom collections, and live lock/home mockup preview"
```
