import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/screens/home_shell_screen.dart';
import 'presentation/state/wallpaper_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF06080D),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  final controller = WallpaperController();
  await controller.initialize();
  runApp(HDWallpaperStudioApp(controller: controller));
}

class HDWallpaperStudioApp extends StatelessWidget {
  const HDWallpaperStudioApp({super.key, required this.controller});

  final WallpaperController controller;

  @override
  Widget build(BuildContext context) {
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C63FF),
      brightness: Brightness.dark,
      primary: const Color(0xFF6C63FF),
      secondary: const Color(0xFF00E5FF),
      surface: const Color(0xFF111520),
    );

    return MaterialApp(
      title: '4K Wallpaper Studio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF06080D),
        colorScheme: darkScheme,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF161B28),
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Colors.white12),
          ),
        ),
      ),
      home: HomeShellScreen(controller: controller),
    );
  }
}
