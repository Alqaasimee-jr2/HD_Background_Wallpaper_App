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
