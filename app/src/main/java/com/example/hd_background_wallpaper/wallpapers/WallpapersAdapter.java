package com.example.hd_background_wallpaper.wallpapers;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.hd_background_wallpaper.R;
import com.example.hd_background_wallpaper.utils.CollectionsManager;
import com.example.hd_background_wallpaper.utils.ImageLoader;

import java.util.List;

public class WallpapersAdapter extends RecyclerView.Adapter<WallpapersAdapter.MyViewHolder> {

    private final Context context;
    private List<WallpapersList> list;
    private final CollectionsManager collectionsManager;

    public WallpapersAdapter(Context context, List<WallpapersList> list) {
        this.context = context;
        this.list = list;
        this.collectionsManager = new CollectionsManager(context);
    }

    public void updateList(List<WallpapersList> newList) {
        this.list = newList;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public WallpapersAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.wallpapers_adapter_layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull WallpapersAdapter.MyViewHolder holder, int position) {
        final WallpapersList item = list.get(position);

        if (holder.wallpaperTitle != null) {
            holder.wallpaperTitle.setText(item.getTitle());
        }
        if (holder.favBadge != null) {
            boolean isFav = collectionsManager.isFavorite(item.getFileName());
            holder.favBadge.setVisibility(isFav ? View.VISIBLE : View.GONE);
        }

        ImageLoader.getInstance().loadThumbnail(context, item, holder.wallpaperImg, 450, 750);

        holder.itemView.setOnClickListener(view -> {
            Intent intent = new Intent(context, WallpaperView.class);
            intent.putExtra("img", item.getFileName());
            intent.putExtra("title", item.getTitle());
            intent.putExtra("sourceType", item.getSourceType());
            context.startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class MyViewHolder extends RecyclerView.ViewHolder {
        private final ImageView wallpaperImg;
        private final TextView wallpaperTitle;
        private final TextView favBadge;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            wallpaperImg = itemView.findViewById(R.id.wallpaperImg);
            wallpaperTitle = itemView.findViewById(R.id.wallpaperTitle);
            favBadge = itemView.findViewById(R.id.favBadge);
        }
    }
}
