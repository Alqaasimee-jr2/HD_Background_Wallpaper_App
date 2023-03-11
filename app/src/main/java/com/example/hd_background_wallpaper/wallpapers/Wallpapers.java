package com.example.hd_background_wallpaper.wallpapers;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.ProgressDialog;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.hd_background_wallpaper.R;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class Wallpapers extends AppCompatActivity {

    private  final List<WallpapersList> wallpapersLists = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallpapers);

        final ImageView backBtn = findViewById(R.id.backBtn);
        final TextView categoryName = findViewById(R.id.categoryName);
        final RecyclerView wallpaperRecyclerView = findViewById(R.id.wallpapersRecyclerView);

        final String getCategory = getIntent().getStringExtra("category");
        categoryName.setText(getCategory);

        wallpaperRecyclerView.setLayoutManager(new GridLayoutManager(Wallpapers.this, 2));
        wallpaperRecyclerView.setItemViewCacheSize(20);
        wallpaperRecyclerView.setDrawingCacheEnabled(true);

        AssetManager assetManager = getAssets();

        ProgressDialog progressDialog = new ProgressDialog(this);
        progressDialog.setCancelable(false);
        progressDialog.setMessage("Loading....");
        progressDialog.show();

        new Thread(new Runnable() {
            @Override
            public void run() {

                try {
                    if (getCategory.equals("Nature")) {


                        InputStream natureIs_1 = assetManager.open("nature_bg.jpg");
                        Bitmap natureImg1 = BitmapFactory.decodeStream(natureIs_1);

                        InputStream natureIs_2 = assetManager.open("nature.jpg");
                        Bitmap natureImg2 = BitmapFactory.decodeStream(natureIs_2);

                        InputStream natureIs_3 = assetManager.open("pine and dew.jpg");
                        Bitmap natureImg3 = BitmapFactory.decodeStream(natureIs_3);

                        InputStream natureIs_4 = assetManager.open("leaves in many shades.jpg");
                        Bitmap natureImg4 = BitmapFactory.decodeStream(natureIs_4);

                        InputStream natureIs_5 = assetManager.open("mountain and trees.jpg");
                        Bitmap natureImg5 = BitmapFactory.decodeStream(natureIs_5);

                        InputStream natureIs_6 = assetManager.open("mountain view (2).jpg");
                        Bitmap natureImg6 = BitmapFactory.decodeStream(natureIs_6);

                        InputStream natureIs_7 = assetManager.open("Lush greens and lake.jpg");
                        Bitmap natureImg7 = BitmapFactory.decodeStream(natureIs_7);

                        InputStream natureIs_8 = assetManager.open("snowy night.jpg");
                        Bitmap natureImg8 = BitmapFactory.decodeStream(natureIs_8);

                        InputStream natureIs_9 = assetManager.open("anime nature.jpg");
                        Bitmap natureImg9 = BitmapFactory.decodeStream(natureIs_9);

                        InputStream natureIs_10 = assetManager.open("natl.jpg");
                        Bitmap natureImg10 = BitmapFactory.decodeStream(natureIs_10);

                        InputStream natureIs_11 = assetManager.open("creek.jpg");
                        Bitmap natureImg11 = BitmapFactory.decodeStream(natureIs_11);

                        InputStream natureIs_12 = assetManager.open("flower.jpg");
                        Bitmap natureImg12 = BitmapFactory.decodeStream(natureIs_12);

                        InputStream natureIs_13 = assetManager.open("lke.jpg");
                        Bitmap natureImg13 = BitmapFactory.decodeStream(natureIs_13);

                        InputStream natureIs_14 = assetManager.open("natA.png");
                        Bitmap natureImg14 = BitmapFactory.decodeStream(natureIs_14);

                        InputStream natureIs_15 = assetManager.open("nat.jpg");
                        Bitmap natureImg15 = BitmapFactory.decodeStream(natureIs_15);

                        InputStream natureIs_16 = assetManager.open("nat1.jpg");
                        Bitmap natureImg16 = BitmapFactory.decodeStream(natureIs_16);

                        InputStream natureIs_17 = assetManager.open("nat2.jpg");
                        Bitmap natureImg17 = BitmapFactory.decodeStream(natureIs_17);

                        InputStream natureIs_18 = assetManager.open("nat3.jpg");
                        Bitmap natureImg18 = BitmapFactory.decodeStream(natureIs_18);

                        InputStream natureIs_19 = assetManager.open("nat4.jpg");
                        Bitmap natureImg19 = BitmapFactory.decodeStream(natureIs_19);

                        InputStream natureIs_20 = assetManager.open("nat5.jpg");
                        Bitmap natureImg20 = BitmapFactory.decodeStream(natureIs_20);

                        //add data
                        WallpapersList natureList1 = new WallpapersList("nature_bg.jpg", natureImg1);
                        wallpapersLists.add(natureList1);

                        WallpapersList natureList2 = new WallpapersList("nature.jpg", natureImg2);
                        wallpapersLists.add(natureList2);

                        WallpapersList natureList3 = new WallpapersList("pine and dew.jpg", natureImg3);
                        wallpapersLists.add(natureList3);

                        WallpapersList natureList4 = new WallpapersList("leaves in many shades.jpg", natureImg4);
                        wallpapersLists.add(natureList4);

                        WallpapersList natureList5 = new WallpapersList("mountain and trees.jpg", natureImg5);
                        wallpapersLists.add(natureList5);

                        WallpapersList natureList6 = new WallpapersList("mountain view (2).jpg", natureImg6);
                        wallpapersLists.add(natureList6);

                        WallpapersList natureList7 = new WallpapersList("Lush greens and lake.jpg", natureImg7);
                        wallpapersLists.add(natureList7);

                        WallpapersList natureList8 = new WallpapersList("snowy night.jpg", natureImg8);
                        wallpapersLists.add(natureList8);

                        WallpapersList natureList9 = new WallpapersList("anime nature.jpg", natureImg9);
                        wallpapersLists.add(natureList9);

                        WallpapersList natureList10 = new WallpapersList("natl.jpg", natureImg10);
                        wallpapersLists.add(natureList10);

                        WallpapersList natureList11 = new WallpapersList("creek.jpg", natureImg11);
                        wallpapersLists.add(natureList11);

                        WallpapersList natureList12 = new WallpapersList("flower.jpg", natureImg12);
                        wallpapersLists.add(natureList12);

                        WallpapersList natureList13 = new WallpapersList("lke.jpg", natureImg13);
                        wallpapersLists.add(natureList13);

                        WallpapersList natureList14 = new WallpapersList("natA.png", natureImg14);
                        wallpapersLists.add(natureList14);

                        WallpapersList natureList15 = new WallpapersList("nat.jpg", natureImg15);
                        wallpapersLists.add(natureList15);

                        WallpapersList natureList16 = new WallpapersList("nat1.jpg", natureImg16);
                        wallpapersLists.add(natureList16);

                        WallpapersList natureList17 = new WallpapersList("nat2.jpg", natureImg17);
                        wallpapersLists.add(natureList17);

                        WallpapersList natureList18 = new WallpapersList("nat3.jpg", natureImg18);
                        wallpapersLists.add(natureList18);

                        WallpapersList natureList19 = new WallpapersList("nat4.jpg", natureImg19);
                        wallpapersLists.add(natureList19);

                        WallpapersList natureList20 = new WallpapersList("nat5.jpg", natureImg20);
                        wallpapersLists.add(natureList20);




                    }
                    else if (getCategory.equals("Anime")) {

                        InputStream AnimeIs_1 = assetManager.open("anime girl.jpg");
                        Bitmap AnimeImg1 = BitmapFactory.decodeStream(AnimeIs_1);

                        InputStream AnimeIs_2 = assetManager.open("anime girl~.jpg");
                        Bitmap AnimeImg2 = BitmapFactory.decodeStream(AnimeIs_2);

                        InputStream AnimeIs_3 = assetManager.open("anime girl@.jpg");
                        Bitmap AnimeImg3 = BitmapFactory.decodeStream(AnimeIs_3);

                        InputStream AnimeIs_4 = assetManager.open("itachi.jpg");
                        Bitmap AnimeImg4 = BitmapFactory.decodeStream(AnimeIs_4);

                        InputStream AnimeIs_5 = assetManager.open("Kakasi x kurama.jpg");
                        Bitmap AnimeImg5 = BitmapFactory.decodeStream(AnimeIs_5);

                        InputStream AnimeIs_6 = assetManager.open("Your Name.jpg");
                        Bitmap AnimeImg6 = BitmapFactory.decodeStream(AnimeIs_6);

                        InputStream AnimeIs_7 = assetManager.open("Juijutsu Kaysen.jpg");
                        Bitmap AnimeImg7 = BitmapFactory.decodeStream(AnimeIs_7);

                        InputStream AnimeIs_8 = assetManager.open("Monkey D Luffy.jpg");
                        Bitmap AnimeImg8 = BitmapFactory.decodeStream(AnimeIs_8);

                        InputStream AnimeIs_9 = assetManager.open("My hero accademia.jpg");
                        Bitmap AnimeImg9 = BitmapFactory.decodeStream(AnimeIs_9);

                        InputStream AnimeIs_10 = assetManager.open("Power.jpg");
                        Bitmap AnimeImg10 = BitmapFactory.decodeStream(AnimeIs_10);

                        InputStream AnimeIs_11 = assetManager.open("Laugh Tale.jpg");
                        Bitmap AnimeImg11 = BitmapFactory.decodeStream(AnimeIs_11);

                        InputStream AnimeIs_12 = assetManager.open("Team 7.jpg");
                        Bitmap AnimeImg12 = BitmapFactory.decodeStream(AnimeIs_12);

                        InputStream AnimeIs_13 = assetManager.open("anya cute.jpg");
                        Bitmap AnimeImg13 = BitmapFactory.decodeStream(AnimeIs_13);

                        InputStream AnimeIs_14 = assetManager.open("anime1.jpg");
                        Bitmap AnimeImg14 = BitmapFactory.decodeStream(AnimeIs_14);

                        InputStream AnimeIs_15 = assetManager.open("anime3.jpg");
                        Bitmap AnimeImg15 = BitmapFactory.decodeStream(AnimeIs_15);

                        InputStream AnimeIs_16 = assetManager.open("goku.jpg");
                        Bitmap AnimeImg16 = BitmapFactory.decodeStream(AnimeIs_16);

                        InputStream AnimeIs_17 = assetManager.open("waterfall anime.jpg");
                        Bitmap AnimeImg17 = BitmapFactory.decodeStream(AnimeIs_17);

                        InputStream AnimeIs_18 = assetManager.open("Sin of Pride.jpg");
                        Bitmap AnimeImg18 = BitmapFactory.decodeStream(AnimeIs_18);

                        InputStream AnimeIs_19 = assetManager.open("Sage mode naruto.jpg");
                        Bitmap AnimeImg19 = BitmapFactory.decodeStream(AnimeIs_19);

                        InputStream AnimeIs_20 = assetManager.open("juijutsu kaisen ff.jpg");
                        Bitmap AnimeImg20 = BitmapFactory.decodeStream(AnimeIs_20);

                        InputStream AnimeIs_21 = assetManager.open("hounds.jpg");
                        Bitmap AnimeImg21 = BitmapFactory.decodeStream(AnimeIs_21);

                        InputStream AnimeIs_22 = assetManager.open("Fire#Force.jpg");
                        Bitmap AnimeImg22 = BitmapFactory.decodeStream(AnimeIs_22);

                        InputStream AnimeIs_23 = assetManager.open("ds.jpeg");
                        Bitmap AnimeImg23 = BitmapFactory.decodeStream(AnimeIs_23);

                        InputStream AnimeIs_24 = assetManager.open("ds2.jpeg");
                        Bitmap AnimeImg24 = BitmapFactory.decodeStream(AnimeIs_24);

                        InputStream AnimeIs_25 = assetManager.open("asuka.jpg");
                        Bitmap AnimeImg25 = BitmapFactory.decodeStream(AnimeIs_25);

                        InputStream AnimeIs_26 = assetManager.open("anya on fury.jpg");
                        Bitmap AnimeImg26 = BitmapFactory.decodeStream(AnimeIs_26);

                        InputStream AnimeIs_27 = assetManager.open("aniw.jpeg");
                        Bitmap AnimeImg27 = BitmapFactory.decodeStream(AnimeIs_27);

                        InputStream AnimeIs_28 = assetManager.open("baki.jpg");
                        Bitmap AnimeImg28 = BitmapFactory.decodeStream(AnimeIs_28);

                        InputStream AnimeIs_29 = assetManager.open("anime2.jpg");
                        Bitmap AnimeImg29 = BitmapFactory.decodeStream(AnimeIs_29);

                        InputStream AnimeIs_30 = assetManager.open("dream.jpg");
                        Bitmap AnimeImg30 = BitmapFactory.decodeStream(AnimeIs_30);

                        //add data
                        WallpapersList AnimeList1 = new WallpapersList("anime girl.jpg",AnimeImg1);
                        wallpapersLists.add(AnimeList1);

                        WallpapersList AnimeList2 = new WallpapersList("anime girl~.jpg",AnimeImg2);
                        wallpapersLists.add(AnimeList2);

                        WallpapersList AnimeList3 = new WallpapersList("anime girl@.jpg",AnimeImg3);
                        wallpapersLists.add(AnimeList3);

                        WallpapersList AnimeList4 = new WallpapersList("itachi.jpg",AnimeImg4);
                        wallpapersLists.add(AnimeList4);

                        WallpapersList AnimeList5 = new WallpapersList("Kakasi x kurama.jpg",AnimeImg5);
                        wallpapersLists.add(AnimeList5);

                        WallpapersList AnimeList6 = new WallpapersList("Your Name.jpg",AnimeImg6);
                        wallpapersLists.add(AnimeList6);

                        WallpapersList AnimeList7 = new WallpapersList("Juijutsu Kaysen.jpg",AnimeImg7);
                        wallpapersLists.add(AnimeList7);

                        WallpapersList AnimeList8 = new WallpapersList("Monkey D Luffy.jpg",AnimeImg8);
                        wallpapersLists.add(AnimeList8);

                        WallpapersList AnimeList9 = new WallpapersList("My hero accademia.jpg",AnimeImg9);
                        wallpapersLists.add(AnimeList9);

                        WallpapersList AnimeList10 = new WallpapersList("Power.jpg",AnimeImg10);
                        wallpapersLists.add(AnimeList10);

                        WallpapersList AnimeList11 = new WallpapersList("Laugh Tale.jpg",AnimeImg11);
                        wallpapersLists.add(AnimeList11);

                        WallpapersList AnimeList12 = new WallpapersList("Team 7.jpg",AnimeImg12);
                        wallpapersLists.add(AnimeList12);

                        WallpapersList AnimeList13 = new WallpapersList("anya cute.jpg",AnimeImg13);
                        wallpapersLists.add(AnimeList13);

                        WallpapersList AnimeList14 = new WallpapersList("anime1.jpg",AnimeImg14);
                        wallpapersLists.add(AnimeList14);

                        WallpapersList AnimeList15 = new WallpapersList("anime3.jpg",AnimeImg15);
                        wallpapersLists.add(AnimeList15);

                        WallpapersList AnimeList16 = new WallpapersList("goku.jpg",AnimeImg16);
                        wallpapersLists.add(AnimeList16);

                        WallpapersList AnimeList17 = new WallpapersList("waterfall anime.jpg.jpg",AnimeImg17);
                        wallpapersLists.add(AnimeList17);

                        WallpapersList AnimeList18 = new WallpapersList("Sin of Pride.jpg",AnimeImg18);
                        wallpapersLists.add(AnimeList18);

                        WallpapersList AnimeList19 = new WallpapersList("Sage mode naruto.jpg",AnimeImg19);
                        wallpapersLists.add(AnimeList19);

                        WallpapersList AnimeList20 = new WallpapersList("juijutsu kaisen ff.jpg",AnimeImg20);
                        wallpapersLists.add(AnimeList20);

                        WallpapersList AnimeList21 = new WallpapersList("hounds.jpg",AnimeImg21);
                        wallpapersLists.add(AnimeList21);

                        WallpapersList AnimeList22 = new WallpapersList("Fire#Force.jpg",AnimeImg22);
                        wallpapersLists.add(AnimeList22);

                        WallpapersList AnimeList23 = new WallpapersList("ds.jpeg",AnimeImg23);
                        wallpapersLists.add(AnimeList23);

                        WallpapersList AnimeList24 = new WallpapersList("ds.jpeg",AnimeImg24);
                        wallpapersLists.add(AnimeList24);

                        WallpapersList AnimeList25 = new WallpapersList("asuka.jpg",AnimeImg25);
                        wallpapersLists.add(AnimeList25);

                        WallpapersList AnimeList26 = new WallpapersList("anya on fury.jpg",AnimeImg26);
                        wallpapersLists.add(AnimeList26);

                        WallpapersList AnimeList27 = new WallpapersList("aniw.jpeg",AnimeImg27);
                        wallpapersLists.add(AnimeList27);

                        WallpapersList AnimeList28 = new WallpapersList("baki.jpg",AnimeImg28);
                        wallpapersLists.add(AnimeList28);

                        WallpapersList AnimeList29 = new WallpapersList("anime2.jpg",AnimeImg29);
                        wallpapersLists.add(AnimeList29);

                        WallpapersList AnimeList30 = new WallpapersList("dream.jpg",AnimeImg30);
                        wallpapersLists.add(AnimeList30);

                    }
                    else if (getCategory.equals("Abstract Art")) {
                        InputStream AbstractArtIs_1 = assetManager.open("abstract art.jpg");
                        Bitmap AbstractImg_1 = BitmapFactory.decodeStream(AbstractArtIs_1);

                        InputStream AbstractArtIs_2 = assetManager.open("abstract art2.jpg");
                        Bitmap AbstractImg_2 = BitmapFactory.decodeStream(AbstractArtIs_2);

                        InputStream AbstractArtIs_3 = assetManager.open("abstract arts.jpg");
                        Bitmap AbstractImg_3 = BitmapFactory.decodeStream(AbstractArtIs_3);

                        InputStream AbstractArtIs_4 = assetManager.open("abstract arts~.jpg");
                        Bitmap AbstractImg_4 = BitmapFactory.decodeStream(AbstractArtIs_4);

                        InputStream AbstractArtIs_5 = assetManager.open("abstract bg.jpg");
                        Bitmap AbstractImg_5 = BitmapFactory.decodeStream(AbstractArtIs_5);

                        InputStream AbstractArtIs_6 = assetManager.open("abstract splash.jpg");
                        Bitmap AbstractImg_6 = BitmapFactory.decodeStream(AbstractArtIs_6);

                        InputStream AbstractArtIs_7 = assetManager.open("abstract paint.jpg");
                        Bitmap AbstractImg_7 = BitmapFactory.decodeStream(AbstractArtIs_7);

                        InputStream AbstractArtIs_8 = assetManager.open("Abstract human.jpg");
                        Bitmap AbstractImg_8 = BitmapFactory.decodeStream(AbstractArtIs_8);

                        InputStream AbstractArtIs_9 = assetManager.open("abstract space.jpg");
                        Bitmap AbstractImg_9 = BitmapFactory.decodeStream(AbstractArtIs_9);

                        InputStream AbstractArtIs_10 = assetManager.open("Dice wallpaper.jpg");
                        Bitmap AbstractImg_10 = BitmapFactory.decodeStream(AbstractArtIs_10);

                        InputStream AbstractArtIs_11 = assetManager.open("colab.jpg");
                        Bitmap AbstractImg_11 = BitmapFactory.decodeStream(AbstractArtIs_11);

                        InputStream AbstractArtIs_12 = assetManager.open("abstract purple.jpg");
                        Bitmap AbstractImg_12 = BitmapFactory.decodeStream(AbstractArtIs_12);

                        InputStream AbstractArtIs_13 = assetManager.open("abstract winds.jpg");
                        Bitmap AbstractImg_13 = BitmapFactory.decodeStream(AbstractArtIs_13);

                        InputStream AbstractArtIs_14 = assetManager.open("abstract art@.jpg");
                        Bitmap AbstractImg_14 = BitmapFactory.decodeStream(AbstractArtIs_14);

                        InputStream AbstractArtIs_15 = assetManager.open("abstract oil.jpg");
                        Bitmap AbstractImg_15 = BitmapFactory.decodeStream(AbstractArtIs_15);

                        InputStream AbstractArtIs_16 = assetManager.open("abstract bubbles.jpg");
                        Bitmap AbstractImg_16 = BitmapFactory.decodeStream(AbstractArtIs_16);

                        InputStream AbstractArtIs_17 = assetManager.open("Abstract bub.jpg");
                        Bitmap AbstractImg_17 = BitmapFactory.decodeStream(AbstractArtIs_17);

                        InputStream AbstractArtIs_18 = assetManager.open("abs1.jpg");
                        Bitmap AbstractImg_18 = BitmapFactory.decodeStream(AbstractArtIs_18);

                        InputStream AbstractArtIs_19 = assetManager.open("absd.jpeg");
                        Bitmap AbstractImg_19 = BitmapFactory.decodeStream(AbstractArtIs_19);

                        InputStream AbstractArtIs_20 = assetManager.open("abstract art wallpaper.jpg");
                        Bitmap AbstractImg_20 = BitmapFactory.decodeStream(AbstractArtIs_20);

                        //add data
                        WallpapersList abstractList1 = new WallpapersList("abstract art.jpg",AbstractImg_1);
                        wallpapersLists.add(abstractList1);

                        WallpapersList abstractList2 = new WallpapersList("abstract art2.jpg",AbstractImg_2);
                        wallpapersLists.add(abstractList2);

                        WallpapersList abstractList3 = new WallpapersList("abstract arts.jpg",AbstractImg_3);
                        wallpapersLists.add(abstractList3);

                        WallpapersList abstractList4 = new WallpapersList("abstract arts~.jpg",AbstractImg_4);
                        wallpapersLists.add(abstractList4);

                        WallpapersList abstractList5 = new WallpapersList("abstract bg.jpg",AbstractImg_5);
                        wallpapersLists.add(abstractList5);

                        WallpapersList abstractList6 = new WallpapersList("abstract splash.jpg",AbstractImg_6);
                        wallpapersLists.add(abstractList6);

                        WallpapersList abstractList7 = new WallpapersList("abstract paint.jpg",AbstractImg_7);
                        wallpapersLists.add(abstractList7);

                        WallpapersList abstractList8 = new WallpapersList("Abstract human.jpg",AbstractImg_8);
                        wallpapersLists.add(abstractList8);

                        WallpapersList abstractList9 = new WallpapersList("abstract space.jpg",AbstractImg_9);
                        wallpapersLists.add(abstractList9);

                        WallpapersList abstractList10 = new WallpapersList("Dice wallpaper.jpg",AbstractImg_10);
                        wallpapersLists.add(abstractList10);

                        WallpapersList abstractList11 = new WallpapersList("colab.jpg",AbstractImg_11);
                        wallpapersLists.add(abstractList11);

                        WallpapersList abstractList12 = new WallpapersList("abstract purple.jpg",AbstractImg_12);
                        wallpapersLists.add(abstractList12);

                        WallpapersList abstractList13 = new WallpapersList("abstract winds.jpg",AbstractImg_13);
                        wallpapersLists.add(abstractList13);

                        WallpapersList abstractList14 = new WallpapersList("abstract art@.jpg",AbstractImg_14);
                        wallpapersLists.add(abstractList14);

                        WallpapersList abstractList15 = new WallpapersList("abstract oil.jpg",AbstractImg_15);
                        wallpapersLists.add(abstractList15);

                        WallpapersList abstractList16 = new WallpapersList("abstract bubbles.jpg",AbstractImg_16);
                        wallpapersLists.add(abstractList16);

                        WallpapersList abstractList17 = new WallpapersList("Abstract bub.jpg",AbstractImg_17);
                        wallpapersLists.add(abstractList17);

                        WallpapersList abstractList18 = new WallpapersList("abs1.jpg",AbstractImg_18);
                        wallpapersLists.add(abstractList18);

                        WallpapersList abstractList19 = new WallpapersList("absd.jpeg",AbstractImg_19);
                        wallpapersLists.add(abstractList19);

                        WallpapersList abstractList20 = new WallpapersList("abstract art wallpaper.jpg",AbstractImg_20);
                        wallpapersLists.add(abstractList20);
                    }
                    else if (getCategory.equals("Black Wallpapers")) {
                        InputStream BlackBgIs_1 = assetManager.open("abstract black.jpg");
                        Bitmap BlackBgImg_1 = BitmapFactory.decodeStream(BlackBgIs_1);

                        InputStream BlackBgIs_2 = assetManager.open("smiley black.jpg");
                        Bitmap BlackBgImg_2 = BitmapFactory.decodeStream(BlackBgIs_2);

                        InputStream BlackBgIs_3 = assetManager.open("Luffy.jpg");
                        Bitmap BlackBgImg_3 = BitmapFactory.decodeStream(BlackBgIs_3);

                        InputStream BlackBgIs_4 = assetManager.open("low Bar.jpg");
                        Bitmap BlackBgImg_4 = BitmapFactory.decodeStream(BlackBgIs_4);

                        InputStream BlackBgIs_5 = assetManager.open("king black.jpg");
                        Bitmap BlackBgImg_5 = BitmapFactory.decodeStream(BlackBgIs_5);

                        InputStream BlackBgIs_6 = assetManager.open("human bg.jpg");
                        Bitmap BlackBgImg_6 = BitmapFactory.decodeStream(BlackBgIs_6);

                        InputStream BlackBgIs_7 = assetManager.open("Feels dark.jpg");
                        Bitmap BlackBgImg_7 = BitmapFactory.decodeStream(BlackBgIs_7);

                        InputStream BlackBgIs_8 = assetManager.open("feels dark bg.jpg");
                        Bitmap BlackBgImg_8 = BitmapFactory.decodeStream(BlackBgIs_8);

                        InputStream BlackBgIs_9 = assetManager.open("Error~code.jpg");
                        Bitmap BlackBgImg_9 = BitmapFactory.decodeStream(BlackBgIs_9);

                        InputStream BlackBgIs_10 = assetManager.open("black1.jpg");
                        Bitmap BlackBgImg_10 = BitmapFactory.decodeStream(BlackBgIs_10);

                        InputStream BlackBgIs_11 = assetManager.open("black2.jpg");
                        Bitmap BlackBgImg_11 = BitmapFactory.decodeStream(BlackBgIs_11);

                        InputStream BlackBgIs_12 = assetManager.open("black3.jpg");
                        Bitmap BlackBgImg_12= BitmapFactory.decodeStream(BlackBgIs_12);

                        InputStream BlackBgIs_13 = assetManager.open("black halo.jpg");
                        Bitmap BlackBgImg_13= BitmapFactory.decodeStream(BlackBgIs_13);

                        InputStream BlackBgIs_14 = assetManager.open("astro wallpaper.jpg");
                        Bitmap BlackBgImg_14 = BitmapFactory.decodeStream(BlackBgIs_14);

                        InputStream BlackBgIs_15 = assetManager.open("black smile.jpg");
                        Bitmap BlackBgImg_15 = BitmapFactory.decodeStream(BlackBgIs_15);

                        InputStream BlackBgIs_16 = assetManager.open("blackb3.jpg");
                        Bitmap BlackBgImg_16 = BitmapFactory.decodeStream(BlackBgIs_16);

                        InputStream BlackBgIs_17 = assetManager.open("blackb1.jpg");
                        Bitmap BlackBgImg_17 = BitmapFactory.decodeStream(BlackBgIs_17);

                        InputStream BlackBgIs_18 = assetManager.open("blackb4.jpg");
                        Bitmap BlackBgImg_18 = BitmapFactory.decodeStream(BlackBgIs_18);

                        InputStream BlackBgIs_19 = assetManager.open("blackb6.jpg");
                        Bitmap BlackBgImg_19 = BitmapFactory.decodeStream(BlackBgIs_19);

                        InputStream BlackBgIs_20 = assetManager.open("black4.jpg");
                        Bitmap BlackBgImg_20 = BitmapFactory.decodeStream(BlackBgIs_20);

                        //add data
                        WallpapersList BlackBgList1 = new WallpapersList("abstract black.jpg",BlackBgImg_1);
                        wallpapersLists.add(BlackBgList1);

                        WallpapersList BlackBgList2 = new WallpapersList("smiley black.jpg",BlackBgImg_2);
                        wallpapersLists.add(BlackBgList2);

                        WallpapersList BlackBgList3 = new WallpapersList("Luffy.jpg",BlackBgImg_3);
                        wallpapersLists.add(BlackBgList3);

                        WallpapersList BlackBgList4 = new WallpapersList("low Bar.jpg",BlackBgImg_4);
                        wallpapersLists.add(BlackBgList4);

                        WallpapersList BlackBgList5 = new WallpapersList("king black.jpg",BlackBgImg_5);
                        wallpapersLists.add(BlackBgList5);

                        WallpapersList BlackBgList6 = new WallpapersList("human bg.jpg",BlackBgImg_6);
                        wallpapersLists.add(BlackBgList6);

                        WallpapersList BlackBgList7 = new WallpapersList("Feels dark.jpg",BlackBgImg_7);
                        wallpapersLists.add(BlackBgList7);

                        WallpapersList BlackBgList8 = new WallpapersList("feels dark bg.jpg",BlackBgImg_8);
                        wallpapersLists.add(BlackBgList8);

                        WallpapersList BlackBgList9 = new WallpapersList("Error~code.jpg",BlackBgImg_9);
                        wallpapersLists.add(BlackBgList9);

                        WallpapersList BlackBgList10 = new WallpapersList("black1.jpg",BlackBgImg_10);
                        wallpapersLists.add(BlackBgList10);

                        WallpapersList BlackBgList11 = new WallpapersList("black2.jpg",BlackBgImg_11);
                        wallpapersLists.add(BlackBgList11);

                        WallpapersList BlackBgList12 = new WallpapersList("black3.jpg",BlackBgImg_12);
                        wallpapersLists.add(BlackBgList12);

                        WallpapersList BlackBgList13 = new WallpapersList("black halo.jpg",BlackBgImg_13);
                        wallpapersLists.add(BlackBgList13);

                        WallpapersList BlackBgList14 = new WallpapersList("astro wallpaper.jpg",BlackBgImg_14);
                        wallpapersLists.add(BlackBgList14);

                        WallpapersList BlackBgList15 = new WallpapersList("black smile.jpg",BlackBgImg_15);
                        wallpapersLists.add(BlackBgList15);

                        WallpapersList BlackBgList16 = new WallpapersList("blackb3.jpg",BlackBgImg_16);
                        wallpapersLists.add(BlackBgList16);

                        WallpapersList BlackBgList17 = new WallpapersList("blackb1.jpg",BlackBgImg_17);
                        wallpapersLists.add(BlackBgList17);

                        WallpapersList BlackBgList18 = new WallpapersList("blackb4.jpg",BlackBgImg_18);
                        wallpapersLists.add(BlackBgList18);

                        WallpapersList BlackBgList19 = new WallpapersList("blackb6.jpg",BlackBgImg_19);
                        wallpapersLists.add(BlackBgList19);

                        WallpapersList BlackBgList20 = new WallpapersList("black4.jpg",BlackBgImg_20);
                        wallpapersLists.add(BlackBgList20);
                    }
                    else if (getCategory.equals("Random Wallpapers")) {
                        InputStream RandomBgIs_1 = assetManager.open("random1.jpg");
                        Bitmap RandomBgImg_1 = BitmapFactory.decodeStream(RandomBgIs_1);

                        InputStream RandomBgIs_2 = assetManager.open("random2.jpg");
                        Bitmap RandomBgImg_2 = BitmapFactory.decodeStream(RandomBgIs_2);

                        InputStream RandomBgIs_3 = assetManager.open("random3.jpg");
                        Bitmap RandomBgImg_3 = BitmapFactory.decodeStream(RandomBgIs_3);

                        InputStream RandomBgIs_4 = assetManager.open("random4.jpg");
                        Bitmap RandomBgImg_4 = BitmapFactory.decodeStream(RandomBgIs_4);

                        InputStream RandomBgIs_5 = assetManager.open("random5.jpg");
                        Bitmap RandomBgImg_5 = BitmapFactory.decodeStream(RandomBgIs_5);

                        InputStream RandomBgIs_6 = assetManager.open("random6.jpg");
                        Bitmap RandomBgImg_6 = BitmapFactory.decodeStream(RandomBgIs_6);

                        InputStream RandomBgIs_7 = assetManager.open("random7.jpg");
                        Bitmap RandomBgImg_7 = BitmapFactory.decodeStream(RandomBgIs_7);

                        InputStream RandomBgIs_8 = assetManager.open("chess.jpg");
                        Bitmap RandomBgImg_8 = BitmapFactory.decodeStream(RandomBgIs_8);

                        InputStream RandomBgIs_9 = assetManager.open("random9.jpg");
                        Bitmap RandomBgImg_9 = BitmapFactory.decodeStream(RandomBgIs_9);

                        InputStream RandomBgIs_10 = assetManager.open("clock.jpg");
                        Bitmap RandomBgImg_10 = BitmapFactory.decodeStream(RandomBgIs_10);

                        InputStream RandomBgIs_11 = assetManager.open("city (2).jpg");
                        Bitmap RandomBgImg_11 = BitmapFactory.decodeStream(RandomBgIs_11);

                        InputStream RandomBgIs_12 = assetManager.open("Dice arts.jpg");
                        Bitmap RandomBgImg_12 = BitmapFactory.decodeStream(RandomBgIs_12);

                        InputStream RandomBgIs_13 = assetManager.open("Feels bg.jpg");
                        Bitmap RandomBgImg_13 = BitmapFactory.decodeStream(RandomBgIs_13);

                        InputStream RandomBgIs_14 = assetManager.open("owl.jpg");
                        Bitmap RandomBgImg_14 = BitmapFactory.decodeStream(RandomBgIs_14);

                        InputStream RandomBgIs_15 = assetManager.open("ran1.jpg");
                        Bitmap RandomBgImg_15 = BitmapFactory.decodeStream(RandomBgIs_15);

                        InputStream RandomBgIs_16 = assetManager.open("ran3.jpg");
                        Bitmap RandomBgImg_16 = BitmapFactory.decodeStream(RandomBgIs_16);

                        InputStream RandomBgIs_17 = assetManager.open("ran2.jpg");
                        Bitmap RandomBgImg_17 = BitmapFactory.decodeStream(RandomBgIs_17);

                        InputStream RandomBgIs_18 = assetManager.open("random image.jpg");
                        Bitmap RandomBgImg_18 = BitmapFactory.decodeStream(RandomBgIs_18);

                        InputStream RandomBgIs_19 = assetManager.open("pass.png");
                        Bitmap RandomBgImg_19 = BitmapFactory.decodeStream(RandomBgIs_19);

                        InputStream RandomBgIs_20 = assetManager.open("ran4.jpg");
                        Bitmap RandomBgImg_20 = BitmapFactory.decodeStream(RandomBgIs_20);

                        //add data
                        WallpapersList RandomList1 = new WallpapersList("random1.jpg",RandomBgImg_1);
                        wallpapersLists.add(RandomList1);

                        WallpapersList RandomList2 = new WallpapersList("random2.jpg",RandomBgImg_2);
                        wallpapersLists.add(RandomList2);

                        WallpapersList RandomList3 = new WallpapersList("random3.jpg",RandomBgImg_3);
                        wallpapersLists.add(RandomList3);

                        WallpapersList RandomList4 = new WallpapersList("random4.jpg",RandomBgImg_4);
                        wallpapersLists.add(RandomList4);

                        WallpapersList RandomList5 = new WallpapersList("random5.jpg",RandomBgImg_5);
                        wallpapersLists.add(RandomList5);

                        WallpapersList RandomList6 = new WallpapersList("random6.jpg",RandomBgImg_6);
                        wallpapersLists.add(RandomList6);

                        WallpapersList RandomList7 = new WallpapersList("random7.jpg",RandomBgImg_7);
                        wallpapersLists.add(RandomList7);

                        WallpapersList RandomList8 = new WallpapersList("chess.jpg",RandomBgImg_8);
                        wallpapersLists.add(RandomList8);

                        WallpapersList RandomList9 = new WallpapersList("random9.jpg",RandomBgImg_9);
                        wallpapersLists.add(RandomList9);

                        WallpapersList RandomList10= new WallpapersList("clock.jpg",RandomBgImg_10);
                        wallpapersLists.add(RandomList10);

                        WallpapersList RandomList11 = new WallpapersList("city (2).jpg",RandomBgImg_11);
                        wallpapersLists.add(RandomList11);

                        WallpapersList RandomList12 = new WallpapersList("Dice arts.jpg",RandomBgImg_12);
                        wallpapersLists.add(RandomList12);

                        WallpapersList RandomList13 = new WallpapersList("Feels bg.jpg",RandomBgImg_13);
                        wallpapersLists.add(RandomList13);

                        WallpapersList RandomList14 = new WallpapersList("owl.jpg",RandomBgImg_14);
                        wallpapersLists.add(RandomList14);

                        WallpapersList RandomList15 = new WallpapersList("ran1.jpg",RandomBgImg_15);
                        wallpapersLists.add(RandomList15);

                        WallpapersList RandomList16 = new WallpapersList("ran3.jpg",RandomBgImg_16);
                        wallpapersLists.add(RandomList16);

                        WallpapersList RandomList17 = new WallpapersList("ran2.jpg",RandomBgImg_17);
                        wallpapersLists.add(RandomList17);

                        WallpapersList RandomList18 = new WallpapersList("random image.jpg",RandomBgImg_18);
                        wallpapersLists.add(RandomList18);

                        WallpapersList RandomList19 = new WallpapersList("pass.png",RandomBgImg_19);
                        wallpapersLists.add(RandomList19);

                        WallpapersList RandomList20= new WallpapersList("ran4.jpg",RandomBgImg_20);
                        wallpapersLists.add(RandomList20);

                    }
                    else if (getCategory.equals("Game Wallpapers")) {
                        InputStream gameIs_1 = assetManager.open("game1.jpg");
                        Bitmap gameImg1 = BitmapFactory.decodeStream(gameIs_1);
                        InputStream gameIs_2 = assetManager.open("game2.jpg");
                        Bitmap gameImg2 = BitmapFactory.decodeStream(gameIs_2);
                        InputStream gameIs_3 = assetManager.open("game3.jpg");
                        Bitmap gameImg3 = BitmapFactory.decodeStream(gameIs_3);
                        InputStream gameIs_4 = assetManager.open("game4.jpg");
                        Bitmap gameImg4 = BitmapFactory.decodeStream(gameIs_4);
                        InputStream gameIs_5 = assetManager.open("game5.jpg");
                        Bitmap gameImg5 = BitmapFactory.decodeStream(gameIs_5);
                        InputStream gameIs_6 = assetManager.open("game6.jpg");
                        Bitmap gameImg6 = BitmapFactory.decodeStream(gameIs_6);
                        InputStream gameIs_7 = assetManager.open("game7.jpeg");
                        Bitmap gameImg7 = BitmapFactory.decodeStream(gameIs_7);
                        InputStream gameIs_8 = assetManager.open("game8.jpg");
                        Bitmap gameImg8 = BitmapFactory.decodeStream(gameIs_8);
                        InputStream gameIs_9 = assetManager.open("game9.jpeg");
                        Bitmap gameImg9 = BitmapFactory.decodeStream(gameIs_9);
                        InputStream gameIs_10 = assetManager.open("game10.jpg");
                        Bitmap gameImg10 = BitmapFactory.decodeStream(gameIs_10);
                        InputStream gameIs_11 = assetManager.open("game11.jpeg");
                        Bitmap gameImg11 = BitmapFactory.decodeStream(gameIs_11);
                        InputStream gameIs_12 = assetManager.open("game12.jpeg");
                        Bitmap gameImg12 = BitmapFactory.decodeStream(gameIs_12);
                        InputStream gameIs_13 = assetManager.open("game13.jpeg");
                        Bitmap gameImg13 = BitmapFactory.decodeStream(gameIs_13);
                        InputStream gameIs_14 = assetManager.open("game14.jpeg");
                        Bitmap gameImg14 = BitmapFactory.decodeStream(gameIs_14);
                        InputStream gameIs_15 = assetManager.open("game15.jpeg");
                        Bitmap gameImg15 = BitmapFactory.decodeStream(gameIs_15);
                        InputStream gameIs_16 = assetManager.open("game16.jpeg");
                        Bitmap gameImg16 = BitmapFactory.decodeStream(gameIs_16);
                        InputStream gameIs_17 = assetManager.open("game17.jpeg");
                        Bitmap gameImg17 = BitmapFactory.decodeStream(gameIs_17);
                        InputStream gameIs_18 = assetManager.open("game18.jpeg");
                        Bitmap gameImg18 = BitmapFactory.decodeStream(gameIs_18);
                        InputStream gameIs_19 = assetManager.open("game19.jpeg");
                        Bitmap gameImg19 = BitmapFactory.decodeStream(gameIs_19);
                        InputStream gameIs_20 = assetManager.open("game20.jpeg");
                        Bitmap gameImg20 = BitmapFactory.decodeStream(gameIs_20);
                        InputStream gameIs_21 = assetManager.open("game21.jpeg");
                        Bitmap gameImg21 = BitmapFactory.decodeStream(gameIs_21);
                        InputStream gameIs_22 = assetManager.open("game22.jpeg");
                        Bitmap gameImg22 = BitmapFactory.decodeStream(gameIs_22);
                        InputStream gameIs_23 = assetManager.open("game23.jpeg");
                        Bitmap gameImg23 = BitmapFactory.decodeStream(gameIs_23);
                        InputStream gameIs_24 = assetManager.open("game24.jpeg");
                        Bitmap gameImg24 = BitmapFactory.decodeStream(gameIs_24);
                        InputStream gameIs_25 = assetManager.open("game25.jpeg");
                        Bitmap gameImg25 = BitmapFactory.decodeStream(gameIs_25);
                        InputStream gameIs_26 = assetManager.open("game26.jpeg");
                        Bitmap gameImg26 = BitmapFactory.decodeStream(gameIs_26);
                        InputStream gameIs_27 = assetManager.open("game27.jpeg");
                        Bitmap gameImg27 = BitmapFactory.decodeStream(gameIs_27);
                        InputStream gameIs_28 = assetManager.open("game28.jpeg");
                        Bitmap gameImg28 = BitmapFactory.decodeStream(gameIs_28);
                        InputStream gameIs_29 = assetManager.open("game29.jpeg");
                        Bitmap gameImg29 = BitmapFactory.decodeStream(gameIs_29);
                        InputStream gameIs_30 = assetManager.open("game30.png");
                        Bitmap gameImg30 = BitmapFactory.decodeStream(gameIs_30);

                        //add data

                        WallpapersList gameList1 = new WallpapersList("game1.jpg", gameImg1);
                        wallpapersLists.add(gameList1);
                        WallpapersList gameList2 = new WallpapersList("game2.jpg", gameImg2);
                        wallpapersLists.add(gameList2);
                        WallpapersList gameList3 = new WallpapersList("game3.jpg", gameImg3);
                        wallpapersLists.add(gameList3);
                        WallpapersList gameList4 = new WallpapersList("game4.jpg", gameImg4);
                        wallpapersLists.add(gameList4);
                        WallpapersList gameList5 = new WallpapersList("game5.jpg", gameImg5);
                        wallpapersLists.add(gameList5);
                        WallpapersList gameList6 = new WallpapersList("game6.jpg", gameImg6);
                        wallpapersLists.add(gameList6);
                        WallpapersList gameList7 = new WallpapersList("game7.jpeg", gameImg7);
                        wallpapersLists.add(gameList7);
                        WallpapersList gameList8 = new WallpapersList("game8.jpg", gameImg8);
                        wallpapersLists.add(gameList8);
                        WallpapersList gameList9 = new WallpapersList("game9.jpeg", gameImg9);
                        wallpapersLists.add(gameList9);
                        WallpapersList gameList10 = new WallpapersList("game10.jpg", gameImg10);
                        wallpapersLists.add(gameList10);
                        WallpapersList gameList11 = new WallpapersList("game11.jpeg", gameImg11);
                        wallpapersLists.add(gameList11);
                        WallpapersList gameList12 = new WallpapersList("game12.jpeg", gameImg12);
                        wallpapersLists.add(gameList12);
                        WallpapersList gameList13 = new WallpapersList("game13.jpeg", gameImg13);
                        wallpapersLists.add(gameList13);
                        WallpapersList gameList14 = new WallpapersList("game14.jpeg", gameImg14);
                        wallpapersLists.add(gameList14);
                        WallpapersList gameList15 = new WallpapersList("game15.jpeg", gameImg15);
                        wallpapersLists.add(gameList15);
                        WallpapersList gameList16 = new WallpapersList("game16.jpeg", gameImg16);
                        wallpapersLists.add(gameList16);
                        WallpapersList gameList17 = new WallpapersList("game17.jpeg", gameImg17);
                        wallpapersLists.add(gameList17);
                        WallpapersList gameList18 = new WallpapersList("game18.jpeg", gameImg18);
                        wallpapersLists.add(gameList18);
                        WallpapersList gameList19 = new WallpapersList("game19.jpeg", gameImg19);
                        wallpapersLists.add(gameList19);
                        WallpapersList gameList20 = new WallpapersList("game20.jpeg", gameImg20);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList21 = new WallpapersList("game21.jpeg", gameImg21);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList22 = new WallpapersList("game22.jpeg", gameImg22);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList23 = new WallpapersList("game23.jpeg", gameImg23);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList24 = new WallpapersList("game24.jpeg", gameImg24);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList25 = new WallpapersList("game25.jpeg", gameImg25);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList26 = new WallpapersList("game26.jpeg", gameImg26);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList27 = new WallpapersList("game27.jpeg", gameImg27);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList28 = new WallpapersList("game28.jpeg", gameImg28);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList29 = new WallpapersList("game29.jpeg", gameImg29);
                        wallpapersLists.add(gameList20);
                        WallpapersList gameList30 = new WallpapersList("game30.png", gameImg30);
                        wallpapersLists.add(gameList30);
                    }


                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            progressDialog.dismiss();

                            wallpaperRecyclerView.setAdapter(new WallpapersAdapter(Wallpapers.this, wallpapersLists));
                        }
                    });
                }
                    catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

    }
}