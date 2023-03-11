package com.example.hd_background_wallpaper.wallpapers;

import android.graphics.Bitmap;

public class WallpapersList {
    private String fileName;
    private Bitmap bitmap;

    public WallpapersList(String fileName, Bitmap bitmap){
        this.fileName = fileName;
        this.bitmap = bitmap;
    }

    public String getFileName() {
        return fileName;
    }

    public Bitmap getBitmap() {
        return bitmap;
    }
}
