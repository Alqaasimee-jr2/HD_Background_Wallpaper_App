package com.example.hd_background_wallpaper.categories;

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
import com.example.hd_background_wallpaper.utils.ImageLoader;
import com.example.hd_background_wallpaper.wallpapers.Wallpapers;

import java.util.List;

public class CategoriesAdapter extends RecyclerView.Adapter<CategoriesAdapter.MyViewHolder> {

    private final Context context;
    private List<CategoriesList> list;

    public CategoriesAdapter(Context context, List<CategoriesList> list) {
        this.context = context;
        this.list = list;
    }

    public void updateList(List<CategoriesList> newList) {
        this.list = newList;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.categories_adapter_layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull CategoriesAdapter.MyViewHolder holder, int position) {
        final CategoriesList item = list.get(position);
        holder.categoryName.setText(item.getName());
        if (holder.categoryCount != null) {
            holder.categoryCount.setText(item.getCount() + " items");
        }
        ImageLoader.getInstance().loadAssetThumbnail(context, item.getCoverAsset(), holder.categoryImg, 400, 300);

        holder.itemView.setOnClickListener(view -> {
            Intent intent = new Intent(context, Wallpapers.class);
            intent.putExtra("category", item.getName());
            context.startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return list == null ? 0 : list.size();
    }

    static class MyViewHolder extends RecyclerView.ViewHolder {

        private final TextView categoryName;
        private final TextView categoryCount;
        private final ImageView categoryImg;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            categoryName = itemView.findViewById(R.id.categoryName);
            categoryCount = itemView.findViewById(R.id.categoryCount);
            categoryImg = itemView.findViewById(R.id.categoryImg);
        }
    }
}
