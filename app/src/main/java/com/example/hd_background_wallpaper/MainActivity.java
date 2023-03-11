package com.example.hd_background_wallpaper;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

import com.example.hd_background_wallpaper.categories.CategoriesAdapter;
import com.example.hd_background_wallpaper.categories.CategoriesList;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private final List<CategoriesList> categoriesLists = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final RecyclerView categoriesRecyclerview = findViewById(R.id.categoriesRecyclerView);
        categoriesRecyclerview.setHasFixedSize(true);
        categoriesRecyclerview.setLayoutManager(new GridLayoutManager(MainActivity.this,2));


        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getSupportActionBar().hide();
        AssetManager assetManager = getAssets();

        try {
            InputStream natureIs = assetManager.open("nature_bg.jpg");
            Bitmap natureCategoryImg = BitmapFactory.decodeStream(natureIs);

            InputStream AnimeIs = assetManager.open("anime boy.jpg");
            Bitmap AnimeCategoryImg = BitmapFactory.decodeStream(AnimeIs);

            InputStream AbstractArtIs = assetManager.open("abstract art wallpaper.jpg");
            Bitmap AbstractArtCategoryImg = BitmapFactory.decodeStream(AbstractArtIs);

            InputStream BlackBgIs = assetManager.open("black bg wallpaper.jpg");
            Bitmap BlackBgCategoryImg = BitmapFactory.decodeStream(BlackBgIs);

            InputStream RandomBgIs = assetManager.open("Feels bg.jpg");
            Bitmap RandomBgCategoryImg = BitmapFactory.decodeStream(RandomBgIs);

            InputStream gameIs = assetManager.open("game.jpeg");
            Bitmap gameCategoryImg = BitmapFactory.decodeStream(gameIs);


            CategoriesList natureCategory = new CategoriesList("Nature",natureCategoryImg);
            categoriesLists.add(natureCategory);

            CategoriesList AnimeCategory = new CategoriesList("Anime",AnimeCategoryImg);
            categoriesLists.add(AnimeCategory);

            CategoriesList AbstractArtCategory = new CategoriesList("Abstract Art",AbstractArtCategoryImg);
            categoriesLists.add(AbstractArtCategory);

            CategoriesList BlackBgCategory = new CategoriesList("Black Wallpapers",BlackBgCategoryImg);
            categoriesLists.add(BlackBgCategory);

            CategoriesList RandomBgCategory = new CategoriesList("Random Wallpapers",RandomBgCategoryImg);
            categoriesLists.add(RandomBgCategory);


            CategoriesList gameCategory = new CategoriesList("Game Wallpapers",gameCategoryImg);
            categoriesLists.add(gameCategory);


            categoriesRecyclerview.setAdapter(new CategoriesAdapter(MainActivity.this, categoriesLists));

        }catch (IOException e){
            e.printStackTrace();
        }

    }
}