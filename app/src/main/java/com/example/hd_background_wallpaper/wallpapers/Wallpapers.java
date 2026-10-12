package com.example.hd_background_wallpaper.wallpapers;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.hd_background_wallpaper.R;
import com.example.hd_background_wallpaper.utils.CloudWallpaperService;
import com.example.hd_background_wallpaper.utils.CollectionsManager;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Wallpapers extends AppCompatActivity {

    private static final int REQ_IMPORT_GALLERY = 1002;

    private final List<WallpapersList> sourceWallpapers = new ArrayList<>();
    private final List<WallpapersList> displayedWallpapers = new ArrayList<>();
    private WallpapersAdapter wallpapersAdapter;
    private CollectionsManager collectionsManager;
    private String activeCategory = WallpaperCatalog.CAT_ALL;
    private String activeQuery = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallpapers);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        collectionsManager = new CollectionsManager(this);

        final ImageView backBtn = findViewById(R.id.backBtn);
        final TextView categoryName = findViewById(R.id.categoryName);
        final RecyclerView wallpaperRecyclerView = findViewById(R.id.wallpapersRecyclerView);
        final EditText searchInput = findViewById(R.id.searchInput);
        final Button importGalleryBtn = findViewById(R.id.importGalleryBtn);

        String categoryExtra = getIntent().getStringExtra("category");
        if (categoryExtra != null && !categoryExtra.trim().isEmpty()) {
            activeCategory = categoryExtra;
        }
        String queryExtra = getIntent().getStringExtra("query");
        if (queryExtra != null) {
            activeQuery = queryExtra;
        }

        categoryName.setText(activeCategory);
        backBtn.setOnClickListener(view -> finish());

        if (importGalleryBtn != null) {
            importGalleryBtn.setOnClickListener(view -> openGalleryPicker());
        }

        wallpaperRecyclerView.setLayoutManager(new GridLayoutManager(Wallpapers.this, 2));
        wallpaperRecyclerView.setItemViewCacheSize(20);

        wallpapersAdapter = new WallpapersAdapter(Wallpapers.this, displayedWallpapers);
        wallpaperRecyclerView.setAdapter(wallpapersAdapter);

        if (searchInput != null) {
            if (!activeQuery.isEmpty()) {
                searchInput.setText(activeQuery);
            }
            searchInput.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    activeQuery = s == null ? "" : s.toString();
                    applyFilter();
                }

                @Override
                public void afterTextChanged(Editable s) {
                }
            });
        }

        loadCategoryData();
    }

    @Override
    protected void onResume() {
        super.onResume();
        loadCategoryData();
    }

    private void loadCategoryData() {
        sourceWallpapers.clear();
        List<WallpapersList> allAssets = WallpaperCatalog.loadAllAssets(this);
        List<WallpapersList> cloudItems = CloudWallpaperService.getCloudWallpapers();
        List<WallpapersList> importedItems = collectionsManager.getImportedWallpapersList();

        if (WallpaperCatalog.CAT_CLOUD.equalsIgnoreCase(activeCategory)) {
            sourceWallpapers.addAll(cloudItems);
        } else if (WallpaperCatalog.CAT_FAVORITES.equalsIgnoreCase(activeCategory)) {
            Set<String> favs = collectionsManager.getFavorites();
            for (WallpapersList item : allAssets) {
                if (favs.contains(item.getFileName())) {
                    sourceWallpapers.add(item);
                }
            }
            for (WallpapersList item : cloudItems) {
                if (favs.contains(item.getFileName())) {
                    sourceWallpapers.add(item);
                }
            }
            for (WallpapersList item : importedItems) {
                if (favs.contains(item.getFileName())) {
                    sourceWallpapers.add(item);
                }
            }
        } else if (WallpaperCatalog.CAT_CUSTOM.equalsIgnoreCase(activeCategory)) {
            sourceWallpapers.addAll(importedItems);
            Set<String> addedFiles = new HashSet<>();
            for (String folder : collectionsManager.getCustomFolders()) {
                Set<String> folderFiles = collectionsManager.getFolderItems(folder);
                for (WallpapersList asset : allAssets) {
                    if (folderFiles.contains(asset.getFileName()) && addedFiles.add(asset.getFileName())) {
                        sourceWallpapers.add(new WallpapersList(
                                asset.getId(),
                                "[" + folder + "] " + asset.getTitle(),
                                asset.getFileName(),
                                WallpaperCatalog.CAT_CUSTOM,
                                asset.getSourceType()
                        ));
                    }
                }
                for (WallpapersList cloud : cloudItems) {
                    if (folderFiles.contains(cloud.getFileName()) && addedFiles.add(cloud.getFileName())) {
                        sourceWallpapers.add(new WallpapersList(
                                cloud.getId(),
                                "[" + folder + "] " + cloud.getTitle(),
                                cloud.getFileName(),
                                WallpaperCatalog.CAT_CUSTOM,
                                cloud.getSourceType()
                        ));
                    }
                }
            }
        } else if (WallpaperCatalog.CAT_ALL.equalsIgnoreCase(activeCategory)) {
            sourceWallpapers.addAll(allAssets);
            sourceWallpapers.addAll(cloudItems);
            sourceWallpapers.addAll(importedItems);
        } else {
            sourceWallpapers.addAll(WallpaperCatalog.filter(allAssets, activeCategory, ""));
        }

        applyFilter();
    }

    private void applyFilter() {
        displayedWallpapers.clear();
        displayedWallpapers.addAll(WallpaperCatalog.filter(sourceWallpapers, WallpaperCatalog.CAT_ALL, activeQuery));
        if (wallpapersAdapter != null) {
            wallpapersAdapter.updateList(displayedWallpapers);
        }
    }

    private void openGalleryPicker() {
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("image/*");
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
        startActivityForResult(intent, REQ_IMPORT_GALLERY);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQ_IMPORT_GALLERY && resultCode == RESULT_OK && data != null && data.getData() != null) {
            Uri uri = data.getData();
            try {
                getContentResolver().takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
            } catch (SecurityException ignored) {
            }
            collectionsManager.addImportedGalleryUri(uri.toString());
            activeCategory = WallpaperCatalog.CAT_CUSTOM;
            TextView categoryName = findViewById(R.id.categoryName);
            if (categoryName != null) {
                categoryName.setText(activeCategory);
            }
            loadCategoryData();
            Toast.makeText(this, "Imported image added to My Collections & Gallery", Toast.LENGTH_SHORT).show();
        }
    }
}