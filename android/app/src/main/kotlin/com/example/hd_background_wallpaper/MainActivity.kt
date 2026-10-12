package com.example.hd_background_wallpaper

import android.app.WallpaperManager
import android.content.ContentValues
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.hd_background_wallpaper/wallpaper"
    private val ioExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setWallpaper" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        val target = call.argument<String>("target") ?: "both"
                        if (bytes == null || bytes.isEmpty()) {
                            result.error("INVALID_BYTES", "Image bytes cannot be empty", null)
                            return@setMethodCallHandler
                        }
                        ioExecutor.execute {
                            try {
                                val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                                if (bitmap == null) {
                                    mainHandler.post { result.success(false) }
                                    return@execute
                                }
                                val wallpaperManager = WallpaperManager.getInstance(applicationContext)
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                    when (target) {
                                        "home" -> wallpaperManager.setBitmap(
                                            bitmap,
                                            null,
                                            true,
                                            WallpaperManager.FLAG_SYSTEM
                                        )
                                        "lock" -> wallpaperManager.setBitmap(
                                            bitmap,
                                            null,
                                            true,
                                            WallpaperManager.FLAG_LOCK
                                        )
                                        else -> {
                                            wallpaperManager.setBitmap(
                                                bitmap,
                                                null,
                                                true,
                                                WallpaperManager.FLAG_SYSTEM
                                            )
                                            wallpaperManager.setBitmap(
                                                bitmap,
                                                null,
                                                true,
                                                WallpaperManager.FLAG_LOCK
                                            )
                                        }
                                    }
                                } else {
                                    wallpaperManager.setBitmap(bitmap)
                                }
                                mainHandler.post { result.success(true) }
                            } catch (e: Exception) {
                                mainHandler.post { result.success(false) }
                            }
                        }
                    }
                    "saveToGallery" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        val fileName = call.argument<String>("fileName")
                            ?: "hd_wallpaper_${System.currentTimeMillis()}.jpg"
                        if (bytes == null || bytes.isEmpty()) {
                            result.error("INVALID_BYTES", "Image bytes cannot be empty", null)
                            return@setMethodCallHandler
                        }
                        ioExecutor.execute {
                            try {
                                val values = ContentValues().apply {
                                    put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
                                    put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                        put(
                                            MediaStore.Images.Media.RELATIVE_PATH,
                                            Environment.DIRECTORY_PICTURES + "/HDWallpapers"
                                        )
                                    }
                                }
                                val resolver = applicationContext.contentResolver
                                val uri = resolver.insert(
                                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                                    values
                                )
                                if (uri == null) {
                                    mainHandler.post { result.success(false) }
                                    return@execute
                                }
                                resolver.openOutputStream(uri)?.use { stream ->
                                    stream.write(bytes)
                                    stream.flush()
                                }
                                mainHandler.post { result.success(true) }
                            } catch (e: Exception) {
                                mainHandler.post { result.success(false) }
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
