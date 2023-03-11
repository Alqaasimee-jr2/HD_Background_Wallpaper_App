package com.example.hd_background_wallpaper.wallpapers;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.hd_background_wallpaper.R;

import java.util.List;

public class WallpapersAdapter extends RecyclerView.Adapter<WallpapersAdapter.MyViewHolder> {

  private final Context context;
  private List<WallpapersList> list;


    public WallpapersAdapter(Context context, List<WallpapersList> list) {
        this.context = context;
        this.list = list;
    }

    @NonNull
    @Override
    public WallpapersAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new MyViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.wallpapers_adapter_layout, null));
    }

    @Override
    public void onBindViewHolder(@NonNull WallpapersAdapter.MyViewHolder holder, int position) {
        WallpapersList list2 = list.get(position);

        holder.wallpaperImg.setImageBitmap(list2.getBitmap());
        holder.wallpaperImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, WallpaperView.class);
                intent.putExtra("img", list2.getFileName());
                context.startActivity(intent);

            }
        });
     }

    @Override
    public int getItemCount() {
        return list.size();
    }
    static class MyViewHolder extends RecyclerView.ViewHolder{
        private final ImageView wallpaperImg;

        public MyViewHolder(@NonNull View itemView){
            super(itemView);

            wallpaperImg = itemView.findViewById(R.id.wallpaperImg);
        }
    }
}
