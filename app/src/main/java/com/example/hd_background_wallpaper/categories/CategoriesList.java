package com.example.hd_background_wallpaper.categories;

import android.graphics.Bitmap;

public class CategoriesList {

private String name;
private Bitmap bitmap;

public CategoriesList(String name, Bitmap bitmap){
    this.name = name;
    this.bitmap = bitmap;
}

    public String getName() {
        return name;
    }

    public Bitmap getBitmap() {
        return bitmap;
    }
}
