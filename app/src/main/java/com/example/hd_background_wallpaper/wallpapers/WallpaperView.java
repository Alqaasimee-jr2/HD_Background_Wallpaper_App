package com.example.hd_background_wallpaper.wallpapers;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.app.WallpaperManager;
import android.content.ContentValues;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.hd_background_wallpaper.R;
import com.example.hd_background_wallpaper.utils.CollectionsManager;
import com.example.hd_background_wallpaper.utils.ImageLoader;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class WallpaperView extends AppCompatActivity {

    private static final int MOCKUP_CLEAN = 0;
    private static final int MOCKUP_LOCK = 1;
    private static final int MOCKUP_HOME = 2;

    private Bitmap wallpaper;
    private String imgPathOrUrl;
    private String wallpaperTitle;
    private String sourceType;
    private int currentMockupMode = MOCKUP_CLEAN;

    private CollectionsManager collectionsManager;
    private final ExecutorService backgroundExecutor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallpaper_view);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        collectionsManager = new CollectionsManager(this);

        final ImageView wallpaperImg = findViewById(R.id.wallpaperImg);
        final ImageView backBtn = findViewById(R.id.backBtn);
        final Button favBtn = findViewById(R.id.favBtn);
        final Button folderBtn = findViewById(R.id.folderBtn);
        final Button saveBtn = findViewById(R.id.saveBtn);
        final Button mockupBtn = findViewById(R.id.mockupBtn);
        final Button setBtn = findViewById(R.id.setBtn);
        final View lockMockupOverlay = findViewById(R.id.lockMockupOverlay);
        final View homeMockupOverlay = findViewById(R.id.homeMockupOverlay);

        imgPathOrUrl = getIntent().getStringExtra("img");
        wallpaperTitle = getIntent().getStringExtra("title");
        sourceType = getIntent().getStringExtra("sourceType");
        if (sourceType == null || sourceType.isEmpty()) {
            sourceType = WallpapersList.SOURCE_ASSET;
        }
        if (wallpaperTitle == null || wallpaperTitle.isEmpty()) {
            wallpaperTitle = WallpaperCatalog.formatDisplayName(imgPathOrUrl);
        }

        if (backBtn != null) {
            backBtn.setOnClickListener(v -> finish());
        }

        updateFavoriteButton(favBtn);

        if (favBtn != null) {
            favBtn.setOnClickListener(v -> {
                boolean isNowFav = collectionsManager.toggleFavorite(imgPathOrUrl);
                updateFavoriteButton(favBtn);
                Toast.makeText(
                        WallpaperView.this,
                        isNowFav ? "Added to Favorites" : "Removed from Favorites",
                        Toast.LENGTH_SHORT
                ).show();
            });
        }

        if (folderBtn != null) {
            folderBtn.setOnClickListener(v -> showAddToFolderDialog());
        }

        if (saveBtn != null) {
            saveBtn.setOnClickListener(v -> saveCurrentWallpaperToGallery());
        }

        if (mockupBtn != null) {
            mockupBtn.setOnClickListener(v -> {
                currentMockupMode = (currentMockupMode + 1) % 3;
                if (currentMockupMode == MOCKUP_CLEAN) {
                    mockupBtn.setText("Preview: Clean");
                    if (lockMockupOverlay != null) lockMockupOverlay.setVisibility(View.GONE);
                    if (homeMockupOverlay != null) homeMockupOverlay.setVisibility(View.GONE);
                } else if (currentMockupMode == MOCKUP_LOCK) {
                    mockupBtn.setText("Preview: Lock");
                    if (lockMockupOverlay != null) lockMockupOverlay.setVisibility(View.VISIBLE);
                    if (homeMockupOverlay != null) homeMockupOverlay.setVisibility(View.GONE);
                } else {
                    mockupBtn.setText("Preview: Home");
                    if (lockMockupOverlay != null) lockMockupOverlay.setVisibility(View.GONE);
                    if (homeMockupOverlay != null) homeMockupOverlay.setVisibility(View.VISIBLE);
                }
            });
        }

        backgroundExecutor.execute(() -> {
            final Bitmap decoded = ImageLoader.getInstance().decodeFullBitmap(WallpaperView.this, imgPathOrUrl, sourceType);
            runOnUiThread(() -> {
                if (decoded != null) {
                    wallpaper = decoded;
                    wallpaperImg.setImageBitmap(wallpaper);
                } else {
                    Toast.makeText(WallpaperView.this, "Unable to decode wallpaper image", Toast.LENGTH_SHORT).show();
                }
            });
        });

        setBtn.setOnClickListener(view -> showSetWallpaperTargetDialog());
    }

    private void updateFavoriteButton(Button favBtn) {
        if (favBtn == null || imgPathOrUrl == null) return;
        boolean fav = collectionsManager.isFavorite(imgPathOrUrl);
        favBtn.setText(fav ? "★ Saved" : "☆ Fav");
    }

    private void showSetWallpaperTargetDialog() {
        if (wallpaper == null) {
            Toast.makeText(this, "Wallpaper is still loading...", Toast.LENGTH_SHORT).show();
            return;
        }
        final String[] options = new String[]{"Home Screen", "Lock Screen", "Both (Home & Lock)"};
        new AlertDialog.Builder(this)
                .setTitle("Apply Wallpaper To")
                .setItems(options, (dialog, which) -> applyWallpaperWithTarget(which))
                .setNegativeButton("Cancel", null)
                .show();
    }

    private void applyWallpaperWithTarget(final int targetOption) {
        backgroundExecutor.execute(() -> {
            WallpaperManager manager = WallpaperManager.getInstance(WallpaperView.this);
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    if (targetOption == 0) {
                        manager.setBitmap(wallpaper, null, true, WallpaperManager.FLAG_SYSTEM);
                    } else if (targetOption == 1) {
                        manager.setBitmap(wallpaper, null, true, WallpaperManager.FLAG_LOCK);
                    } else {
                        manager.setBitmap(wallpaper, null, true, WallpaperManager.FLAG_SYSTEM | WallpaperManager.FLAG_LOCK);
                    }
                } else {
                    manager.setBitmap(wallpaper);
                }
                runOnUiThread(() -> Toast.makeText(WallpaperView.this, "Wallpaper applied successfully!", Toast.LENGTH_SHORT).show());
            } catch (IOException e) {
                runOnUiThread(() -> Toast.makeText(WallpaperView.this, "Failed to set wallpaper: " + e.getMessage(), Toast.LENGTH_SHORT).show());
            }
        });
    }

    private void showAddToFolderDialog() {
        List<String> folders = collectionsManager.getCustomFolders();
        final String[] items = new String[folders.size() + 1];
        for (int i = 0; i < folders.size(); i++) {
            items[i] = folders.get(i);
        }
        items[folders.size()] = "+ Create New Collection Folder";

        new AlertDialog.Builder(this)
                .setTitle("Add to Custom Collection")
                .setItems(items, (dialog, which) -> {
                    if (which == folders.size()) {
                        showCreateFolderDialog();
                    } else {
                        String chosenFolder = folders.get(which);
                        collectionsManager.addWallpaperToFolder(chosenFolder, imgPathOrUrl);
                        Toast.makeText(WallpaperView.this, "Added to " + chosenFolder, Toast.LENGTH_SHORT).show();
                    }
                })
                .setNegativeButton("Cancel", null)
                .show();
    }

    private void showCreateFolderDialog() {
        final EditText input = new EditText(this);
        input.setHint("e.g. Cyberpunk Favorites");
        new AlertDialog.Builder(this)
                .setTitle("New Collection Folder")
                .setView(input)
                .setPositiveButton("Create & Add", (dialog, which) -> {
                    String folderName = input.getText().toString().trim();
                    if (!folderName.isEmpty()) {
                        collectionsManager.addWallpaperToFolder(folderName, imgPathOrUrl);
                        Toast.makeText(WallpaperView.this, "Added to " + folderName, Toast.LENGTH_SHORT).show();
                    }
                })
                .setNegativeButton("Cancel", null)
                .show();
    }

    private void saveCurrentWallpaperToGallery() {
        if (wallpaper == null) {
            Toast.makeText(this, "Wallpaper is still loading...", Toast.LENGTH_SHORT).show();
            return;
        }
        backgroundExecutor.execute(() -> {
            try {
                ContentValues values = new ContentValues();
                String cleanTitle = wallpaperTitle.replaceAll("[^a-zA-Z0-9_\\-]", "_");
                values.put(MediaStore.Images.Media.DISPLAY_NAME, "HD_" + cleanTitle + "_" + System.currentTimeMillis() + ".jpg");
                values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg");
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/HDWallpapers");
                }

                Uri uri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
                if (uri != null) {
                    try (OutputStream out = getContentResolver().openOutputStream(uri)) {
                        if (out != null) {
                            wallpaper.compress(Bitmap.CompressFormat.JPEG, 95, out);
                        }
                    }
                    runOnUiThread(() -> Toast.makeText(WallpaperView.this, "Saved to Gallery (Pictures/HDWallpapers)", Toast.LENGTH_SHORT).show());
                } else {
                    runOnUiThread(() -> Toast.makeText(WallpaperView.this, "Could not create gallery entry", Toast.LENGTH_SHORT).show());
                }
            } catch (Exception e) {
                runOnUiThread(() -> Toast.makeText(WallpaperView.this, "Failed to save image: " + e.getMessage(), Toast.LENGTH_SHORT).show());
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        backgroundExecutor.shutdownNow();
    }
}