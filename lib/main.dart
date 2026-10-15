import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/screens/home_shell_screen.dart';
import 'presentation/state/wallpaper_controller.dart';
import 'presentation/state/theme_controller.dart';

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
  final themeController = ThemeController();
  await controller.initialize();
  runApp(HDWallpaperStudioApp(controller: controller, themeController: themeController));
}

class HDWallpaperStudioApp extends StatelessWidget {
  const HDWallpaperStudioApp({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final WallpaperController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        if (!themeController.isInitialized) {
           return const MaterialApp(
             home: Scaffold(
               backgroundColor: Color(0xFF06080D),
               body: Center(
                 child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
               ),
             ),
           );
        }
        final seedColor = themeController.seedColor;

        final darkScheme = ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
          primary: seedColor,
          surface: const Color(0xFF111520),
        );

        final lightScheme = ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
          primary: seedColor,
          surface: Colors.white,
        );

        return MaterialApp(
          title: '4K Wallpaper Studio',
          debugShowCheckedModeBanner: false,
          themeMode: themeController.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF0F2F5),
            colorScheme: lightScheme,
            snackBarTheme: SnackBarThemeData(
              backgroundColor: const Color(0xFF2D3748),
              contentTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Colors.black12),
              ),
            ),
          ),
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
          home: HomeShellScreen(
            controller: controller,
            themeController: themeController,
          ),
        );
      },
    );
  }
}
