package com.example.hd_background_wallpaper;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.example.hd_background_wallpaper.categories.CategoriesAdapter;
import com.example.hd_background_wallpaper.categories.CategoriesList;
import com.example.hd_background_wallpaper.utils.CollectionsManager;
import com.example.hd_background_wallpaper.wallpapers.WallpaperCatalog;
import com.example.hd_background_wallpaper.wallpapers.Wallpapers;
import com.example.hd_background_wallpaper.wallpapers.WallpapersList;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private static final int REQ_IMPORT_GALLERY = 1001;

    private final List<CategoriesList> categoriesLists = new ArrayList<>();
    private CategoriesAdapter categoriesAdapter;
    private CollectionsManager collectionsManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        collectionsManager = new CollectionsManager(this);

        final RecyclerView categoriesRecyclerView = findViewById(R.id.categoriesRecyclerView);
        final EditText searchInput = findViewById(R.id.searchInput);
        final Button importGalleryBtn = findViewById(R.id.importGalleryBtn);

        categoriesRecyclerView.setHasFixedSize(true);
        categoriesRecyclerView.setLayoutManager(new GridLayoutManager(MainActivity.this, 2));

        categoriesAdapter = new CategoriesAdapter(MainActivity.this, categoriesLists);
        categoriesRecyclerView.setAdapter(categoriesAdapter);

        refreshCategories();

        if (searchInput != null) {
            searchInput.setOnEditorActionListener((textView, actionId, keyEvent) -> {
                if (actionId == EditorInfo.IME_ACTION_SEARCH
                        || actionId == EditorInfo.IME_ACTION_DONE
                        || (keyEvent != null && keyEvent.getKeyCode() == KeyEvent.KEYCODE_ENTER && keyEvent.getAction() == KeyEvent.ACTION_DOWN)) {
                    String query = searchInput.getText().toString().trim();
                    Intent intent = new Intent(MainActivity.this, Wallpapers.class);
                    intent.putExtra("category", WallpaperCatalog.CAT_ALL);
                    intent.putExtra("query", query);
                    startActivity(intent);
                    return true;
                }
                return false;
            });
        }

        if (importGalleryBtn != null) {
            importGalleryBtn.setOnClickListener(v -> openGalleryPicker());
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        refreshCategories();
    }

    private void refreshCategories() {
        List<WallpapersList> allAssets = WallpaperCatalog.loadAllAssets(this);
        int favCount = collectionsManager.getFavorites().size();
        int customCount = collectionsManager.getImportedGalleryUris().size() + collectionsManager.getCustomFolders().size();

        categoriesLists.clear();
        categoriesLists.addAll(WallpaperCatalog.buildCategories(allAssets, favCount, customCount));
        if (categoriesAdapter != null) {
            categoriesAdapter.updateList(categoriesLists);
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
            refreshCategories();
            Toast.makeText(this, "Wallpaper imported to My Collections & Gallery", Toast.LENGTH_SHORT).show();

            Intent intent = new Intent(this, Wallpapers.class);
            intent.putExtra("category", WallpaperCatalog.CAT_CUSTOM);
            startActivity(intent);
        }
    }
}