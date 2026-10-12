import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hd_background_wallpaper/domain/models/wallpaper_item.dart';
import 'package:hd_background_wallpaper/main.dart';
import 'package:hd_background_wallpaper/presentation/screens/wallpaper_detail_screen.dart';
import 'package:hd_background_wallpaper/presentation/state/wallpaper_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('HomeShellScreen renders 3 tabs (Explore, Cloud 4K, Collections)', (
    WidgetTester tester,
  ) async {
    final controller = WallpaperController();
    await controller.initialize();

    await tester.pumpWidget(HDWallpaperStudioApp(controller: controller));
    await tester.pump();

    expect(find.text('4K Wallpaper Studio'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Cloud 4K'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);
    expect(find.textContaining('266 results'), findsOneWidget);

    // Switch to Cloud 4K tab
    await tester.tap(find.text('Cloud 4K'));
    await tester.pump();
    expect(find.text('Cloud 4K Ultra HD Stream'), findsOneWidget);

    // Switch to Collections tab
    await tester.tap(find.text('Collections'));
    await tester.pump();
    expect(find.text('+ New Folder'), findsOneWidget);
    expect(find.text('AMOLED Setup'), findsOneWidget);
  });

  testWidgets(
    'WallpaperDetailScreen switches between Clean, Lock Screen, and Home Screen mockups',
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

      // Switch to Home Screen Mockup
      await tester.tap(find.text('Home Screen'));
      await tester.pump();
      expect(find.text('Search apps, web & widgets...'), findsOneWidget);

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
