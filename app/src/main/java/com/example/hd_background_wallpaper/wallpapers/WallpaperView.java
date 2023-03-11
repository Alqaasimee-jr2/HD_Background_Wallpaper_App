package com.example.hd_background_wallpaper.wallpapers;

import androidx.appcompat.app.AppCompatActivity;

import android.app.WallpaperManager;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.hd_background_wallpaper.R;

import java.io.IOException;
import java.io.InputStream;

public class WallpaperView extends AppCompatActivity {

    private Bitmap wallpaper;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallpaper_view);

        final ImageView wallpaperImg = findViewById(R.id.wallpaperImg);
        final Button setBtn = findViewById(R.id.setBtn);

        final String getImg = getIntent().getStringExtra("img");

        AssetManager assetManager = getAssets();

        try {
            InputStream inputStream = assetManager.open(getImg);
            wallpaper = BitmapFactory.decodeStream(inputStream);

            wallpaperImg.setImageBitmap(wallpaper);

        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        setBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                WallpaperManager manager = WallpaperManager.getInstance(WallpaperView.this);
                try {
                    manager.setBitmap(wallpaper);
                    Toast.makeText(WallpaperView.this, "Wallpaper Set", Toast.LENGTH_SHORT).show();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }

            }
        });
    }
}