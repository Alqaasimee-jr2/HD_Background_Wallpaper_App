import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hd_background_wallpaper/domain/models/wallpaper_item.dart';
import 'package:hd_background_wallpaper/main.dart';
import 'package:hd_background_wallpaper/presentation/screens/wallpaper_detail_screen.dart';
import 'package:hd_background_wallpaper/presentation/state/wallpaper_controller.dart';
import 'package:hd_background_wallpaper/presentation/state/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('HomeShellScreen renders 3 tabs on mobile and adapts to tablet NavigationRail without overflow', (
    WidgetTester tester,
  ) async {
    final controller = WallpaperController();
    final themeController = ThemeController();
    await controller.initialize();

    // Test mobile viewport (390 x 844)
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(HDWallpaperStudioApp(
      controller: controller,
      themeController: themeController,
    ));
    await tester.pump();

    expect(find.text('4K Wallpaper Studio'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Cloud 4K'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);
    expect(find.textContaining('900 results'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // Switch to Cloud 4K tab
    await tester.tap(find.text('Cloud 4K'));
    await tester.pump();
    expect(find.text('Cloud 4K Ultra HD Stream'), findsOneWidget);

    // Switch to Collections tab
    await tester.tap(find.text('Collections'));
    await tester.pump();
    expect(find.text('+ New Folder'), findsOneWidget);
    expect(find.text('AMOLED Setup'), findsOneWidget);

    // Resize to tablet / landscape viewport (1024 x 600) and verify adaptive NavigationRail
    tester.view.physicalSize = const Size(1024, 600);
    await tester.pump();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'WallpaperDetailScreen switches between Clean, Lock Screen, and Home Screen mockups and handles compact height without overflow',
    (WidgetTester tester) async {
      final controller = WallpaperController();
      await controller.initialize();

      const sampleItem = WallpaperItem(
        id: 'assets/wallpapers/nature_bg.jpg',
        title: 'Nature bg',
        path: 'assets/wallpapers/nature_bg.jpg',
        category: 'Nature',
        source: WallpaperSource.asset,
        accentColorHex: '#2ECC71',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WallpaperDetailScreen(
            item: sampleItem,
            controller: controller,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Clean'), findsOneWidget);
      expect(find.text('Lock Screen'), findsOneWidget);
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Set Wallpaper'), findsOneWidget);

      // Switch to Lock Screen Mockup
      await tester.tap(find.text('Lock Screen'));
      await tester.pump();
      expect(
        find.text('Lock screen depth & contrast check active.'),
        findsOneWidget,
      );

      // Verify compact landscape height (e.g. 800 x 420) has zero overflow in Lock Screen mockup
      tester.view.physicalSize = const Size(800, 420);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pump();
      expect(tester.takeException(), isNull);

      // Switch to Home Screen Mockup
      await tester.tap(find.text('Home Screen'));
      await tester.pump();
      expect(find.text('Search apps, web & widgets...'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Switch back to Clean View
      await tester.tap(find.text('Clean'));
      await tester.pump();
      expect(
        find.text('Search apps, web & widgets...'),
        findsNothing,
      );
    },
  );
}
