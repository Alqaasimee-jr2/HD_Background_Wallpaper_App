import 'package:flutter/services.dart';
import '../../domain/models/wallpaper_item.dart';

class WallpaperCatalogService {
  static const String catAll = 'All';
  static const String catNature = 'Nature';
  static const String catAnime = 'Anime';
  static const String catAbstract = 'Abstract Art';
  static const String catBlack = 'Black Wallpapers';
  static const String catGame = 'Game Wallpapers';
  static const String catRandom = 'Random Wallpapers';

  static const List<String> offlineCategories = <String>[
    catAll,
    catNature,
    catAnime,
    catAbstract,
    catBlack,
    catGame,
    catRandom,
  ];

  static const List<String> cloudTopics = <String>[
    'All',
    'Cyberpunk',
    'Space',
    'Nature',
    'AMOLED',
    'Anime',
    'Minimal',
    'Architecture',
  ];

  Future<List<WallpaperItem>> loadOfflineWallpapers() async {
    List<String> assetPaths = <String>[];
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      assetPaths = manifest
          .listAssets()
          .where((path) => path.startsWith('assets/wallpapers/') && isImageFile(path))
          .toList();
    } catch (_) {
      assetPaths = <String>[];
    }

    if (assetPaths.isEmpty) {
      assetPaths = fallbackAssetFileNames
          .map((fileName) => 'assets/wallpapers/$fileName')
          .toList();
    }

    assetPaths.sort();
    return assetPaths.map(buildFromAssetPath).toList();
  }

  static WallpaperItem buildFromAssetPath(String assetPath) {
    final slashIndex = assetPath.lastIndexOf('/');
    final fileName =
        slashIndex >= 0 ? assetPath.substring(slashIndex + 1) : assetPath;
    final category = categorizeFileName(fileName);
    return WallpaperItem(
      id: assetPath,
      title: formatDisplayName(fileName),
      path: assetPath,
      category: category,
      source: WallpaperSource.asset,
      accentColorHex: accentForCategory(category),
      resolutionLabel: '4K UHD',
    );
  }

  static bool isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.jfif') ||
        lower.endsWith('.webp');
  }

  static String categorizeFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.startsWith('game') ||
        lower.contains('valorant') ||
        lower.contains('valo') ||
        lower.contains('gta') ||
        lower.contains('overwatch') ||
        lower.contains('apex') ||
        lower.contains('among us') ||
        lower.contains('free fire') ||
        lower.contains('god of war') ||
        lower.contains('call of duty') ||
        lower.contains('titanfall') ||
        lower.contains('spider-man') ||
        lower.contains('vergil')) {
      return catGame;
    }
    if (lower.contains('anime') ||
        lower.startsWith('ani') ||
        lower.contains('naruto') ||
        lower.contains('luffy') ||
        lower.contains('onepiece') ||
        lower.contains('goku') ||
        lower.contains('itachi') ||
        lower.contains('kakas') ||
        lower.contains('obito') ||
        lower.contains('pain bg') ||
        lower.contains('akatsuki') ||
        lower.contains('team 7') ||
        lower.contains('anya') ||
        lower.contains('asuka') ||
        lower.contains('baki') ||
        lower.contains('demon slayer') ||
        lower.startsWith('ds') ||
        lower.contains('fire#force') ||
        lower.contains('hero accademia') ||
        lower.contains('juijutsu') ||
        lower.contains('mob psycho') ||
        lower.contains('power') ||
        lower.contains('sin of pride') ||
        lower.contains('your name') ||
        lower.contains('laugh tale') ||
        lower.contains('hounds') ||
        lower.contains('dream') ||
        lower.contains('denji') ||
        lower.contains('tanjiro') ||
        lower.contains('saber_fate') ||
        lower.contains('rwby') ||
        lower.contains('skyani')) {
      return catAnime;
    }
    if (lower.startsWith('nat') ||
        lower.contains('nature') ||
        lower.contains('mountain') ||
        lower.contains('tree') ||
        lower.contains('lush') ||
        lower.contains('creek') ||
        lower.contains('flower') ||
        lower.contains('lke') ||
        lower.contains('pine') ||
        lower.contains('leaves') ||
        lower.contains('snowy') ||
        lower.contains('woods') ||
        lower.contains('water.jpg') ||
        lower.contains('shoreline') ||
        lower.contains('stream')) {
      return catNature;
    }
    if (lower.startsWith('abs') ||
        lower.contains('abstract') ||
        lower.contains('abtract') ||
        lower.contains('neon') ||
        lower.contains('pallette') ||
        lower.contains('colab') ||
        lower.contains('splash')) {
      return catAbstract;
    }
    if (lower.contains('black') ||
        lower.contains('dark') ||
        lower.startsWith('b2b') ||
        lower.startsWith('bb') ||
        lower.contains('error~code') ||
        lower.contains('low bar') ||
        lower.contains('astro') ||
        lower.contains('death~time')) {
      return catBlack;
    }
    return catRandom;
  }

  static String formatDisplayName(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    var base = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    base = base
        .replaceAll('_', ' ')
        .replaceAll('~', ' ')
        .replaceAll('@', ' ')
        .replaceAll('#', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (base.isEmpty) return 'HD Wallpaper';
    return base[0].toUpperCase() + base.substring(1);
  }

  static String accentForCategory(String category) {
    switch (category) {
      case catNature:
        return '#2ECC71';
      case catAnime:
        return '#FF6B81';
      case catAbstract:
        return '#A29BFE';
      case catBlack:
        return '#00E5FF';
      case catGame:
        return '#FF9F43';
      default:
        return '#6C63FF';
    }
  }

  List<WallpaperItem> getCloudWallpapers() {
    return const <WallpaperItem>[
      WallpaperItem(
        id: 'cloud_1',
        title: 'Cyberpunk Neon Horizon 4K',
        path: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1440&q=85',
        category: 'Cyberpunk',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF007F',
      ),
      WallpaperItem(
        id: 'cloud_2',
        title: 'Tokyo Midnight Synthwave',
        path: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=1440&q=85',
        category: 'Cyberpunk',
        source: WallpaperSource.cloud,
        accentColorHex: '#00E5FF',
      ),
      WallpaperItem(
        id: 'cloud_3',
        title: 'Futuristic Cyber Grid',
        path: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1440&q=85',
        category: 'Cyberpunk',
        source: WallpaperSource.cloud,
        accentColorHex: '#6C63FF',
      ),
      WallpaperItem(
        id: 'cloud_4',
        title: 'Deep Space Carina Nebula',
        path: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1440&q=85',
        category: 'Space',
        source: WallpaperSource.cloud,
        accentColorHex: '#9B59B6',
      ),
      WallpaperItem(
        id: 'cloud_5',
        title: 'Aurora Borealis Cosmic Sky',
        path: 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=1440&q=85',
        category: 'Space',
        source: WallpaperSource.cloud,
        accentColorHex: '#2ECC71',
      ),
      WallpaperItem(
        id: 'cloud_6',
        title: 'Milky Way Galactic Core',
        path: 'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=1440&q=85',
        category: 'Space',
        source: WallpaperSource.cloud,
        accentColorHex: '#3498DB',
      ),
      WallpaperItem(
        id: 'cloud_7',
        title: 'Alpine Peaks at Golden Dusk',
        path: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1440&q=85',
        category: 'Nature',
        source: WallpaperSource.cloud,
        accentColorHex: '#E67E22',
      ),
      WallpaperItem(
        id: 'cloud_8',
        title: 'Misty Redwood Emerald Forest',
        path: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=1440&q=85',
        category: 'Nature',
        source: WallpaperSource.cloud,
        accentColorHex: '#27AE60',
      ),
      WallpaperItem(
        id: 'cloud_9',
        title: 'Emerald Glacier Lagoon 4K',
        path: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=1440&q=85',
        category: 'Nature',
        source: WallpaperSource.cloud,
        accentColorHex: '#1ABC9C',
      ),
      WallpaperItem(
        id: 'cloud_10',
        title: 'Obsidian Pitch Black AMOLED',
        path: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1440&q=85',
        category: 'AMOLED',
        source: WallpaperSource.cloud,
        accentColorHex: '#00E5FF',
      ),
      WallpaperItem(
        id: 'cloud_11',
        title: 'AMOLED Eclipse Ring',
        path: 'https://images.unsplash.com/photo-1532693322450-2cb5c511067d?w=1440&q=85',
        category: 'AMOLED',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF9F43',
      ),
      WallpaperItem(
        id: 'cloud_12',
        title: 'Neon Torii Shrine Night',
        path: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1440&q=85',
        category: 'Anime',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF6B81',
      ),
      WallpaperItem(
        id: 'cloud_13',
        title: 'Kyoto Lantern Alley Vibe',
        path: 'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=1440&q=85',
        category: 'Anime',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF4757',
      ),
      WallpaperItem(
        id: 'cloud_14',
        title: 'Liquid Gold & Obsidian Minimal',
        path: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=1440&q=85',
        category: 'Minimal',
        source: WallpaperSource.cloud,
        accentColorHex: '#F1C40F',
      ),
      WallpaperItem(
        id: 'cloud_15',
        title: 'Sahara Dunes Minimal Curves',
        path: 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=1440&q=85',
        category: 'Minimal',
        source: WallpaperSource.cloud,
        accentColorHex: '#E67E22',
      ),
      WallpaperItem(
        id: 'cloud_16',
        title: 'Nordic Dark Interior Geometry',
        path: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1440&q=85',
        category: 'Architecture',
        source: WallpaperSource.cloud,
        accentColorHex: '#95A5A6',
      ),
      WallpaperItem(
        id: 'cloud_17',
        title: 'Monolith Brutalist Facade',
        path: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1440&q=85',
        category: 'Architecture',
        source: WallpaperSource.cloud,
        accentColorHex: '#3498DB',
      ),
    ];
  }

  static const List<String> fallbackAssetFileNames = <String>[
    '7bf68581-23d0-4345-ac9c-44524f89eb1a.jpeg',
    '84fefaf5-283d-487d-bae2-7ab39e1d2307.jpeg',
    '971b1792e0d8284f9ec391fc33a996de.jpg',
    'abs1.jpg',
    'absd.jpeg',
    'abstract art wallpaper.jpg',
    'abstract art.jpg',
    'abstract art@.jpg',
    'abstract art2.jpg',
    'abstract arts.jpg',
    'abstract arts~.jpg',
    'abstract bg.jpg',
    'abstract black.jpg',
    'Abstract bub.jpg',
    'abstract bubbles.jpg',
    'abstract diag.jpg',
    'Abstract human.jpg',
    'abstract lights.jpg',
    'abstract oil.jpg',
    'abstract paint.jpg',
    'abstract purple.jpg',
    'abstract space.jpg',
    'abstract splash.jpg',
    'abstract winds.jpg',
    'abtract purple~.jpg',
    'Akatsuki.jpg',
    'Among Us Game 4K Ultra HD Mobile Wallpaper.jpeg',
    'anime boy.jpg',
    'anime city.jpg',
    'anime dark.jpg',
    'anime emblems.jpg',
    'anime girl 2.jpg',
    'anime girl.jpg',
    'Anime girl@ (2).jpg',
    'anime girl@.jpg',
    'anime girl~.jpg',
    'anime mountains.jpg',
    'anime names.jpg',
    'anime nature.jpg',
    'anime nature2.jpg',
    'anime tengu.jpg',
    'anime wallpaper (2).jpg',
    'anime wallpaper.jpg',
    'anime1.jpg',
    'anime2.jpg',
    'anime3.jpg',
    'aniw.jpeg',
    'anya cute.jpg',
    'anya on fury.jpg',
    'Apex Legends Octane Wallpaper 4K iPhone _ Desktop #366.jpeg',
    'astro wallpaper.jpg',
    'asuka.jpg',
    'b2b.jpg',
    'baki.jpg',
    'bb.jpg',
    'bbb.jpg',
    'bbbb.jpg',
    'beast.jpg',
    'Bg islam.jpg',
    'black bg wallpaper.jpg',
    'black halo.jpg',
    'black smile.jpg',
    'black smiley wallpaper.jpg',
    'Black wallpaper (2).jpg',
    'black wallpaper.jpg',
    'Black wallpaper2.jpg',
    'black walpaper Msc.jpg',
    'black wllp.jpg',
    'black1.jpg',
    'black2.jpg',
    'black3.jpg',
    'black4.jpg',
    'black7.jpg',
    'blackb1.jpg',
    'blackb2.jpg',
    'blackb3.jpg',
    'blackb4.jpg',
    'blackb5.jpg',
    'blackb6.jpg',
    'blackb7.jpg',
    'blacks.jpg',
    'c2054551-0254-4a32-9c7f-b2ecf5bb1fde.jpeg',
    'c7f4c535a9e45a5bcb96de5a6e1c9df6.jpg',
    'chess.jpg',
    'city (2).jpg',
    'city.jpg',
    'clock.jpg',
    'colab.jpg',
    'cool.jfif',
    'creek.jpg',
    'cyberPunk Tanjiro.jpg',
    'dark boy.jpg',
    'Death~time.jpg',
    'DemiGirl.jpg',
    'Demon slayer.jpg',
    'denji.jpg',
    'Dice arts.jpg',
    'Dice black.jpg',
    'Dice wallpaper.jpg',
    'download.jfif',
    'dragon black.jpg',
    'dream.jpg',
    'ds.jpeg',
    'ds2.jpeg',
    'Error~code.jpg',
    'feel bg.jpg',
    'Feels bg.jpg',
    "feels bg'.jpg",
    'feels dark bg.jpg',
    'Feels dark.jpg',
    'Fire#Force.jpg',
    'flower.jpg',
    'franklin_gta_v-915.jpg',
    'game.jpeg',
    'game1.jpg',
    'game10.jpg',
    'game11.jpeg',
    'game12.jpeg',
    'game13.jpeg',
    'game14.jpeg',
    'game15.jpeg',
    'game16.jpeg',
    'game17.jpeg',
    'game18.jpeg',
    'game19.jpeg',
    'game2.jpg',
    'game20.jpeg',
    'game21.jpeg',
    'game22.jpg',
    'game23.jpeg',
    'game24.jpeg',
    'game25.jpeg',
    'game26.jpeg',
    'game27.jpeg',
    'game28.jpeg',
    'game29.jpeg',
    'game3.jpg',
    'game30.png',
    'game4.jpg',
    'game5.jpg',
    'game6.jpg',
    'game7.jpeg',
    'game8.jpg',
    'game9.jpeg',
    'Garena Free Fire 2022 New Season 4K Ultra HD Mobile Wallpaper.jpeg',
    'gg.jpg',
    'God Of War.jfif',
    'Goku pastel.jpg',
    'goku red.jpg',
    'goku.jpg',
    'GTA 5 Wallpaper - iXpap.jpeg',
    'GTA Wallpapers.jpeg',
    'Hero accademia.jpg',
    'hounds.jpg',
    'human bg.jpg',
    'I made Vergil Mobile Wallpaper.jpeg',
    'Iphone Nature.jpg',
    'itachi bg.jpg',
    'itachi glitch.jpg',
    'itachi sharingan.jpg',
    'itachi.jpg',
    'juijutsu kaisen ff.jpg',
    'juijutsu Kaisen.jpg',
    'juijutsu Kaisin.jpg',
    'Juijutsu Kaysen.jpg',
    'Kakashi hatake.jpg',
    'Kakasi x kurama.jpg',
    'king black.jpg',
    'Laugh Tale.jpg',
    'leaves in many shades.jpg',
    'lke.jpg',
    'lone samurai.jpg',
    'low Bar.jpg',
    'Luffy.jpg',
    'Lush greens and lake.jpg',
    'mcu.jpg',
    'Mob Psycho.jpg',
    'mobile_wallpaper70-468.jpg',
    'Monkey D Luffy.jpg',
    'moon.jpg',
    'mountain and trees.jpg',
    'mountain view (2).jpg',
    'Mountain view.jpg',
    'Mountains in moonlight.jpg',
    'My hero accademia.jpg',
    'naru x jiraya.jpg',
    'narutoXsasuke.jpg',
    'nat.jpg',
    'nat1.jpg',
    'nat2.jpg',
    'nat3.jpg',
    'nat4.jpg',
    'nat5.jpg',
    'nat6.jpg',
    'natA.png',
    'natAr.jfif',
    'natl.jpg',
    'natp.jpg',
    'natsp.jpg',
    'nature.jpg',
    'nature_bg.jpg',
    'Neon abstract.jpg',
    'night lantern.jpg',
    'Obito~.jpg',
    'omen valorant 2020 artwork iPhone 11 Wallpapers.jpeg',
    'OnePiece.jpg',
    'Overwatch Mobile Wallpaper.jpeg',
    'overwatch wallpapers 27.jpeg',
    'owl.jpg',
    'Pain Bg.jpg',
    'Pallette painting.jpg',
    'pass.png',
    'pine and dew.jpg',
    'Poker Cards And Dices IPhone Wallpaper HD - IPhone Wallpapers.png',
    'Poker Neon Ace Card IPhone Wallpaper HD - IPhone Wallpapers.png',
    'Power.jpg',
    'Quotes bg.jpg',
    'ran1.jpg',
    'ran2.jpg',
    'ran3.jpg',
    'ran4.jpg',
    'random image.jpg',
    'random1.jpg',
    'random2.jpg',
    'random3.jpg',
    'random4.jpg',
    'random5.jpg',
    'random6.jpg',
    'random7.jpg',
    'random8.jpg',
    'random9.jpg',
    'rwby.jfif',
    'saber_fate-932 (1).jpg',
    'saber_fate-932.jpg',
    'Sage mode naruto.jpg',
    'shoreline.jpg',
    'Sin of Pride.jpg',
    'Skull Mask Skydive Call of Duty Mobile 4K Ultra HD Mobile Wallpaper.jpeg',
    'skyAni.jfif',
    'smiley black.jpg',
    'snowy night.jpg',
    'Solar system.jpg',
    'Sombra Overwatch Warrior Wallpapers _ hdqwalls_com.jpeg',
    'Spider verse.jpg',
    'Spider-man Miles Morales Game Action 4K Ultra HD Mobile Wallpaper.jpeg',
    'Spidey@.jpg',
    'stones.jpg',
    'stream.jpg',
    'Team 7.jpg',
    'time splash.jpg',
    'Trees and a road.jpg',
    'valo.jfif',
    'valo2.jfif',
    'valo3.jfif',
    'valo4.jfif',
    'valo5.jfif',
    'VALORANT Phone Wallpaper.png',
    'Valorant Player Cards.png',
    'Wallpaper (1).jpeg',
    'War Machine Titanfall 2 4K Ultra HD Mobile Wallpaper.jpeg',
    'water.jpg',
    'waterfall anime.jpg',
    'whale.jpg',
    'woods.jpg',
    'Your Name.jpg',
    '🍎Valorant Wallpaper Time, Jr Pencil.jpeg',
  ];
}
