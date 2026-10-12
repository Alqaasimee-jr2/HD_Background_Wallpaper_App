import 'package:flutter/material.dart';
import 'presentation/screens/home_shell_screen.dart';
import 'presentation/state/wallpaper_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      surface: const Color(0xFF161B26),
    );

    return MaterialApp(
      title: '4K Wallpaper Studio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        colorScheme: darkScheme,
      ),
      home: HomeShellScreen(controller: controller),
    );
  }
}
