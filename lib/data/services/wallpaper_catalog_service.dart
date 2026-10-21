import 'package:flutter/services.dart';
import '../../domain/models/wallpaper_item.dart';

class WallpaperCatalogService {
  static const String catAll = 'All';
  static const String catNature = 'Nature';
  static const String catAnime = 'Anime';
  static const String catAbstract = 'Abstract Art';
  static const String catBlack = 'Black Wallpapers';
  static const String catGame = 'Game Wallpapers';
  static const String catMinimal = 'Minimal & Aesthetic';
  static const String catQuotes = 'Quotes & Motivation';
  static const String catSciFiCars = 'Sci-Fi, Movies & Cars';
  static const String catRandom = 'Random Wallpapers';

  static const List<String> offlineCategories = <String>[
    catAll,
    catNature,
    catAnime,
    catAbstract,
    catBlack,
    catGame,
    catMinimal,
    catQuotes,
    catSciFiCars,
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
          .where(
            (path) =>
                path.startsWith('assets/wallpapers/') && isImageFile(path),
          )
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
    final fileName = slashIndex >= 0
        ? assetPath.substring(slashIndex + 1)
        : assetPath;
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

    // Deterministic prefix routing for curated & AI wallpapers
    if (lower.startsWith('nature__')) return catNature;
    if (lower.startsWith('anime__')) return catAnime;
    if (lower.startsWith('abstract__')) return catAbstract;
    if (lower.startsWith('black__')) return catBlack;
    if (lower.startsWith('game__')) return catGame;
    if (lower.startsWith('minimal__')) return catMinimal;
    if (lower.startsWith('quotes__')) return catQuotes;
    if (lower.startsWith('scifi__')) return catSciFiCars;
    if (lower.startsWith('random__')) return catRandom;

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
    if (lower.contains('quote') ||
        lower.contains('motivat') ||
        lower.contains('focus') ||
        lower.contains('believe')) {
      return catQuotes;
    }
    if (lower.contains('minimal') ||
        lower.contains('tapet') ||
        lower.contains('pastel')) {
      return catMinimal;
    }
    if (lower.contains('porsche') ||
        lower.contains('cyberpunk') ||
        lower.contains('blade runner') ||
        lower.contains('solar system')) {
      return catSciFiCars;
    }
    return catRandom;
  }

  static String formatDisplayName(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    var base = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    final prefixIndex = base.indexOf('__');
    if (prefixIndex >= 0) {
      base = base.substring(prefixIndex + 2);
      base = base.replaceFirst(RegExp(r'_\d{3}$'), '');
    }
    base = base
        .replaceAll('_', ' ')
        .replaceAll('~', ' ')
        .replaceAll('@', ' ')
        .replaceAll('#', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (base.isEmpty) return 'HD Wallpaper';
    return base
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
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
      case catMinimal:
        return '#FDCB6E';
      case catQuotes:
        return '#FF7675';
      case catSciFiCars:
        return '#00CEC9';
      default:
        return '#6C63FF';
    }
  }

  List<WallpaperItem> getCloudWallpapers() {
    return const <WallpaperItem>[
      WallpaperItem(
        id: 'cloud_1',
        title: 'Cyberpunk Neon Horizon 4K',
        path:
            'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1440&q=85',
        category: 'Cyberpunk',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF007F',
      ),
      WallpaperItem(
        id: 'cloud_2',
        title: 'Tokyo Midnight Synthwave',
        path:
            'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=1440&q=85',
        category: 'Cyberpunk',
        source: WallpaperSource.cloud,
        accentColorHex: '#00E5FF',
      ),
      WallpaperItem(
        id: 'cloud_3',
        title: 'Futuristic Cyber Grid',
        path:
            'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=1440&q=85',
        category: 'Cyberpunk',
        source: WallpaperSource.cloud,
        accentColorHex: '#6C63FF',
      ),
      WallpaperItem(
        id: 'cloud_4',
        title: 'Deep Space Carina Nebula',
        path:
            'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1440&q=85',
        category: 'Space',
        source: WallpaperSource.cloud,
        accentColorHex: '#9B59B6',
      ),
      WallpaperItem(
        id: 'cloud_5',
        title: 'Aurora Borealis Cosmic Sky',
        path:
            'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=1440&q=85',
        category: 'Space',
        source: WallpaperSource.cloud,
        accentColorHex: '#2ECC71',
      ),
      WallpaperItem(
        id: 'cloud_6',
        title: 'Milky Way Galactic Core',
        path:
            'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=1440&q=85',
        category: 'Space',
        source: WallpaperSource.cloud,
        accentColorHex: '#3498DB',
      ),
      WallpaperItem(
        id: 'cloud_7',
        title: 'Alpine Peaks at Golden Dusk',
        path:
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1440&q=85',
        category: 'Nature',
        source: WallpaperSource.cloud,
        accentColorHex: '#E67E22',
      ),
      WallpaperItem(
        id: 'cloud_8',
        title: 'Misty Emerald Pine Valley',
        path:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1440&q=85',
        category: 'Nature',
        source: WallpaperSource.cloud,
        accentColorHex: '#27AE60',
      ),
      WallpaperItem(
        id: 'cloud_9',
        title: 'Pitch Black OLED Crimson Ring',
        path:
            'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1440&q=85',
        category: 'AMOLED',
        source: WallpaperSource.cloud,
        accentColorHex: '#E74C3C',
      ),
      WallpaperItem(
        id: 'cloud_10',
        title: 'True Black Minimal Eclipse',
        path:
            'https://images.unsplash.com/photo-1532693322450-2cb5c511067d?w=1440&q=85',
        category: 'AMOLED',
        source: WallpaperSource.cloud,
        accentColorHex: '#00E5FF',
      ),
      WallpaperItem(
        id: 'cloud_11',
        title: 'AMOLED Neon Silhouette',
        path:
            'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1440&q=85',
        category: 'AMOLED',
        source: WallpaperSource.cloud,
        accentColorHex: '#9B59B6',
      ),
      WallpaperItem(
        id: 'cloud_12',
        title: 'Shibuya Sunset Anime Sky',
        path:
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=1440&q=85',
        category: 'Anime',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF6B81',
      ),
      WallpaperItem(
        id: 'cloud_13',
        title: 'Kyoto Torii Gate Lanterns',
        path:
            'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1440&q=85',
        category: 'Anime',
        source: WallpaperSource.cloud,
        accentColorHex: '#FF4757',
      ),
      WallpaperItem(
        id: 'cloud_14',
        title: 'Nordic Minimal Sand Dunes',
        path:
            'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=1440&q=85',
        category: 'Minimal',
        source: WallpaperSource.cloud,
        accentColorHex: '#FDCB6E',
      ),
      WallpaperItem(
        id: 'cloud_15',
        title: 'Serene Pastel Horizon',
        path:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1440&q=85',
        category: 'Minimal',
        source: WallpaperSource.cloud,
        accentColorHex: '#74B9FF',
      ),
      WallpaperItem(
        id: 'cloud_16',
        title: 'Brutalist Concrete Geometry',
        path:
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=1440&q=85',
        category: 'Architecture',
        source: WallpaperSource.cloud,
        accentColorHex: '#A29BFE',
      ),
      WallpaperItem(
        id: 'cloud_17',
        title: 'Glass Skyscraper Symmetry',
        path:
            'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1440&q=85',
        category: 'Architecture',
        source: WallpaperSource.cloud,
        accentColorHex: '#00CEC9',
      ),
    ];
  }

  static const List<String> fallbackAssetFileNames = <String>[
    '7bf68581-23d0-4345-ac9c-44524f89eb1a.jpeg',
    '84fefaf5-283d-487d-bae2-7ab39e1d2307.jpeg',
    '971b1792e0d8284f9ec391fc33a996de.jpg',
    'Abstract bub.jpg',
    'Abstract human.jpg',
    'Akatsuki.jpg',
    'Among Us Game 4K Ultra HD Mobile Wallpaper.jpeg',
    'Anime girl@ (2).jpg',
    'Apex Legends Octane Wallpaper 4K iPhone _ Desktop #366.jpeg',
    'Bg islam.jpg',
    'Black wallpaper (2).jpg',
    'Black wallpaper2.jpg',
    'Death~time.jpg',
    'DemiGirl.jpg',
    'Demon slayer.jpg',
    'Dice arts.jpg',
    'Dice black.jpg',
    'Dice wallpaper.jpg',
    'Error~code.jpg',
    'Feels bg.jpg',
    'Feels dark.jpg',
    'Fire#Force.jpg',
    'GTA 5 Wallpaper - iXpap.jpeg',
    'GTA Wallpapers.jpeg',
    'Garena Free Fire 2022 New Season 4K Ultra HD Mobile Wallpaper.jpeg',
    'God Of War.jfif',
    'Goku pastel.jpg',
    'Hero accademia.jpg',
    'I made Vergil Mobile Wallpaper.jpeg',
    'Iphone Nature.jpg',
    'Juijutsu Kaysen.jpg',
    'Kakashi hatake.jpg',
    'Kakasi x kurama.jpg',
    'Laugh Tale.jpg',
    'Luffy.jpg',
    'Lush greens and lake.jpg',
    'Mob Psycho.jpg',
    'Monkey D Luffy.jpg',
    'Mountain view.jpg',
    'Mountains in moonlight.jpg',
    'My hero accademia.jpg',
    'Neon abstract.jpg',
    'Obito~.jpg',
    'OnePiece.jpg',
    'Overwatch Mobile Wallpaper.jpeg',
    'Pain Bg.jpg',
    'Pallette painting.jpg',
    'Poker Cards And Dices IPhone Wallpaper HD - IPhone Wallpapers.png',
    'Poker Neon Ace Card IPhone Wallpaper HD - IPhone Wallpapers.png',
    'Power.jpg',
    'Quotes bg.jpg',
    'Sage mode naruto.jpg',
    'Sin of Pride.jpg',
    'Skull Mask Skydive Call of Duty Mobile 4K Ultra HD Mobile Wallpaper.jpeg',
    'Solar system.jpg',
    'Sombra Overwatch Warrior Wallpapers _ hdqwalls_com.jpeg',
    'Spider verse.jpg',
    'Spider-man Miles Morales Game Action 4K Ultra HD Mobile Wallpaper.jpeg',
    'Spidey@.jpg',
    'Team 7.jpg',
    'Trees and a road.jpg',
    'VALORANT Phone Wallpaper.png',
    'Valorant Player Cards.png',
    'Wallpaper (1).jpeg',
    'War Machine Titanfall 2 4K Ultra HD Mobile Wallpaper.jpeg',
    'Your Name.jpg',
    'abs1.jpg',
    'absd.jpeg',
    'abstract art wallpaper.jpg',
    'abstract art.jpg',
    'abstract art2.jpg',
    'abstract art@.jpg',
    'abstract arts.jpg',
    'abstract arts~.jpg',
    'abstract bg.jpg',
    'abstract black.jpg',
    'abstract bubbles.jpg',
    'abstract diag.jpg',
    'abstract lights.jpg',
    'abstract oil.jpg',
    'abstract paint.jpg',
    'abstract purple.jpg',
    'abstract space.jpg',
    'abstract splash.jpg',
    'abstract winds.jpg',
    'abstract__Abstract_Mountain_Landscape_028.jpg',
    'abstract__Amber_And_Cyan_Glass_Lotus_002.jpg',
    'abstract__Atlas_Holding_World_039.jpg',
    'abstract__Balanced_Stone_Stack_037.jpg',
    'abstract__Blue_Chair_Painting_042.jpg',
    'abstract__Blue_White_Pebbles_018.jpg',
    'abstract__Colorful_Abstract_Doodles_032.jpg',
    'abstract__Colorful_Feathered_Bird_011.jpg',
    'abstract__Colorful_Paint_Splatter_040.jpg',
    'abstract__Colorful_Textured_Blocks_034.jpg',
    'abstract__Cosmic_Neural_Synapse_Filaments_007.jpg',
    'abstract__Cosmic_Starburst_Galaxy_022.jpg',
    'abstract__Crimson_Pink_Flourish_046.jpg',
    'abstract__Dark_Crimson_Swirl_041.jpg',
    'abstract__Dark_Green_Flourish_048.jpg',
    'abstract__Fading_Square_Overlays_045.jpg',
    'abstract__Fiery_Lion_Profile_015.jpg',
    'abstract__Fiery_Stone_Blocks_043.jpg',
    'abstract__Floral_Spiral_Path_024.jpg',
    'abstract__Geometric_Sunset_Peaks_026.jpg',
    'abstract__Geometric_Tiger_Art_020.jpg',
    'abstract__Glowing_Beach_Pebbles_038.jpg',
    'abstract__Glowing_Teal_Squares_023.jpg',
    'abstract__Golden_Chess_King_012.jpg',
    'abstract__Golden_City_Blocks_052.jpg',
    'abstract__Golden_Green_Flourish_050.jpg',
    'abstract__Golden_Meteor_Shower_030.jpg',
    'abstract__Golden_Pendulum_Prism_Shards_004.jpg',
    'abstract__Happy_Dark_Faces_055.jpg',
    'abstract__Japanese_Mountain_Grid_017.jpg',
    'abstract__Kintsugi_Gold_Porcelain_Sphere_001.jpg',
    'abstract__Kitsune_Mask_Flames_054.jpg',
    'abstract__Moon_Goddess_Raven_036.jpg',
    'abstract__Neon_Blocks_Pattern_013.jpg',
    'abstract__Neon_Ferrofluid_Crown_Splash_003.jpg',
    'abstract__Obsidian_Fault_Line_Magma_005.jpg',
    'abstract__Orange_Brown_Flourish_047.jpg',
    'abstract__Overgrown_Piano_Glow_033.jpg',
    'abstract__Overlapping_Teal_Circles_025.jpg',
    'abstract__Pastel_Wavy_Layers_027.jpg',
    'abstract__Peachy_Watercolor_Bubbles_051.jpg',
    'abstract__Red_Rose_Vase_035.jpg',
    'abstract__Reflective_Black_Orbs_029.jpg',
    'abstract__Suspended_Ocean_Jellyfish_Cube_006.jpg',
    'abstract__Swirling_Storm_Glass_Sphere_010.jpg',
    'abstract__Teal_Gold_Pebbles_019.jpg',
    'abstract__Teal_Orange_Flourish_049.jpg',
    'abstract__Uncut_Black_Diamond_Amethyst_009.jpg',
    'abstract__Vibrant_Bokeh_Lights_044.jpg',
    'abstract__Vibrant_Cityscape_Park_021.jpg',
    'abstract__Vibrant_Floral_Pattern_053.jpg',
    'abstract__Vibrant_Fluid_Art_014.jpg',
    'abstract__Vibrant_Paint_Splash_031.jpg',
    'abstract__Vibrant_Sunset_Seascape_016.jpg',
    'abstract__Violet_Smoke_Ceramic_Mask_008.jpg',
    'abtract purple~.jpg',
    'anime boy.jpg',
    'anime city.jpg',
    'anime dark.jpg',
    'anime emblems.jpg',
    'anime girl 2.jpg',
    'anime girl.jpg',
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
    'anime__Ace_Of_Spades_135.jpg',
    'anime__Albedo_Dark_Smile_125.jpg',
    'anime__Allen_Walker_Power_080.jpg',
    'anime__Anime_Character_Silhouette_131.jpg',
    'anime__Anime_Mountain_Valley_066.jpg',
    'anime__Anime_Title_Collage_095.jpg',
    'anime__Armored_Red_Knightess_081.jpg',
    'anime__Astral_Spirit_Kitsune_04_004.jpg',
    'anime__Astral_Spirit_Kitsune_24_024.jpg',
    'anime__Astral_Spirit_Kitsune_44_044.jpg',
    'anime__Beast_City_Lights_098.jpg',
    'anime__Blood_Moon_Vampire_Lord_16_016.jpg',
    'anime__Blood_Moon_Vampire_Lord_36_036.jpg',
    'anime__Blue_Flame_Exorcist_11_011.jpg',
    'anime__Blue_Flame_Exorcist_31_031.jpg',
    'anime__Blue_Haired_Oni_075.jpg',
    'anime__Blue_Sky_Ocean_110.jpg',
    'anime__Butterfly_Heart_Girl_104.jpg',
    'anime__Celestial_Valkyrie_Halo_09_009.jpg',
    'anime__Celestial_Valkyrie_Halo_29_029.jpg',
    'anime__Celestial_Valkyrie_Halo_49_049.jpg',
    'anime__Chainsaw_Man_Denji_077.jpg',
    'anime__Chibi_Goku_Super_Saiyan_051.jpg',
    'anime__Chibi_Naruto_Squat_087.jpg',
    'anime__Chibi_Naruto_Street_127.jpg',
    'anime__Chibi_Nezuko_Sitting_052.jpg',
    'anime__City_Lights_Gazer_089.jpg',
    'anime__City_Rooftop_Night_123.jpg',
    'anime__Cliffside_Anime_City_101.jpg',
    'anime__Crimson_Sharingan_Eclipse_02_002.jpg',
    'anime__Crimson_Sharingan_Eclipse_22_022.jpg',
    'anime__Crimson_Sharingan_Eclipse_42_042.jpg',
    'anime__Cute_Girl_Kitten_094.jpg',
    'anime__Cyber_Shogun_Overlook_20_020.jpg',
    'anime__Cyber_Shogun_Overlook_40_040.jpg',
    'anime__Cyberpunk_Ronin_Neon_Rain_01_001.jpg',
    'anime__Cyberpunk_Ronin_Neon_Rain_21_021.jpg',
    'anime__Cyberpunk_Ronin_Neon_Rain_41_041.jpg',
    'anime__Cyberpunk_Rooftop_Angel_086.jpg',
    'anime__Dark_Hollow_Mask_Duel_13_013.jpg',
    'anime__Dark_Hollow_Mask_Duel_33_033.jpg',
    'anime__Dark_Power_Unleashed_082.jpg',
    'anime__Demoness_Bar_Night_097.jpg',
    'anime__Devil_Fruit_Sketch_134.jpg',
    'anime__Dragon_Katana_Blade_084.jpg',
    'anime__Emerald_Wind_Ninja_19_019.jpg',
    'anime__Emerald_Wind_Ninja_39_039.jpg',
    'anime__Evangelion_Unit_Despair_074.jpg',
    'anime__Falling_Through_Fire_099.jpg',
    'anime__Fiery_Anime_Warrior_126.jpg',
    'anime__Frieren_Journey_Reflection_073.jpg',
    'anime__Gear_Five_Luffy_122.jpg',
    'anime__Geto_Suguru_Cursed_079.jpg',
    'anime__Ghost_In_The_Cyber_Shell_010.jpg',
    'anime__Ghost_In_The_Cyber_Shell_030.jpg',
    'anime__Ghost_In_The_Cyber_Shell_050.jpg',
    'anime__Gohan_Flying_Nimbus_112.jpg',
    'anime__Gojo_Neon_Aura_085.jpg',
    'anime__Gojo_Satoru_Smile_083.jpg',
    'anime__Goku_Black_Grin_121.jpg',
    'anime__Golden_Aura_Sage_Mode_12_012.jpg',
    'anime__Golden_Aura_Sage_Mode_32_032.jpg',
    'anime__Golden_Oni_Mask_106.jpg',
    'anime__Guts_Starry_Night_055.jpg',
    'anime__Guts_Starry_Night_072.jpg',
    'anime__Haikyuu_Hinata_Spike_132.jpg',
    'anime__Hanekawa_Rainy_City_120.jpg',
    'anime__Haruka_Sakura_Smile_119.jpg',
    'anime__Ichigo_Moon_Sword_078.jpg',
    'anime__Impressionist_Anime_Girl_124.jpg',
    'anime__Inosuke_Wild_Roar_118.jpg',
    'anime__Isagi_Intense_Gaze_117.jpg',
    'anime__Itachi_Sharingan_Crows_116.jpg',
    'anime__Itadori_City_Reflection_129.jpg',
    'anime__Jin_Mori_Dragon_115.jpg',
    'anime__Kakashi_Mountain_View_114.jpg',
    'anime__Killua_Lightning_Mountain_070.jpg',
    'anime__Lucy_Cyberpunk_Edgerunners_053.jpg',
    'anime__Luffy_Gear_Five_069.jpg',
    'anime__Luffy_Gear_Four_091.jpg',
    'anime__Luffy_Nami_Falling_093.jpg',
    'anime__Luffy_Sky_Lanterns_111.jpg',
    'anime__Maki_Zenin_Stance_068.jpg',
    'anime__Makima_Chains_Black_128.jpg',
    'anime__Moonlit_Katana_Shrine_03_003.jpg',
    'anime__Moonlit_Katana_Shrine_23_023.jpg',
    'anime__Moonlit_Katana_Shrine_43_043.jpg',
    'anime__Naruto_Falling_Sky_092.jpg',
    'anime__Naruto_Kakashi_Silhouette_113.jpg',
    'anime__Naruto_Sasuke_Bond_067.jpg',
    'anime__Neon_Tokyo_Mecha_Pilot_06_006.jpg',
    'anime__Neon_Tokyo_Mecha_Pilot_26_026.jpg',
    'anime__Neon_Tokyo_Mecha_Pilot_46_046.jpg',
    'anime__Obsidian_Dragon_Slayer_08_008.jpg',
    'anime__Obsidian_Dragon_Slayer_28_028.jpg',
    'anime__Obsidian_Dragon_Slayer_48_048.jpg',
    'anime__Oni_Girl_Sakura_103.jpg',
    'anime__Orange_Sky_Ocean_109.jpg',
    'anime__Pink_Cherry_Blossom_056.jpg',
    'anime__Pirate_Girl_Stance_133.jpg',
    'anime__Purple_Sky_Ocean_108.jpg',
    'anime__Rainy_Day_Anime_130.jpg',
    'anime__Red_Oni_Girl_107.jpg',
    'anime__Satoru_Gojo_Intense_061.jpg',
    'anime__Shadow_Monarch_Awakening_05_005.jpg',
    'anime__Shadow_Monarch_Awakening_25_025.jpg',
    'anime__Shadow_Monarch_Awakening_45_045.jpg',
    'anime__Shadow_Monster_Battle_100.jpg',
    'anime__Silver_Eyed_Phantom_15_015.jpg',
    'anime__Silver_Eyed_Phantom_35_035.jpg',
    'anime__Stargazing_Anime_Couple_096.jpg',
    'anime__Starlight_Alchemist_Circle_14_014.jpg',
    'anime__Starlight_Alchemist_Circle_34_034.jpg',
    'anime__Sukuna_Crimson_Gaze_090.jpg',
    'anime__Sukuna_Dark_Throne_105.jpg',
    'anime__Sukuna_Fiery_Power_071.jpg',
    'anime__Sukuna_King_Cursed_054.jpg',
    'anime__Sukuna_Sunset_Sky_059.jpg',
    'anime__Sunset_Ocean_Clouds_064.jpg',
    'anime__Tanjiro_Water_Dragon_076.jpg',
    'anime__Thorfinn_Forest_River_060.jpg',
    'anime__Thunder_Breathing_Flash_17_017.jpg',
    'anime__Thunder_Breathing_Flash_37_037.jpg',
    'anime__Trafalgar_Law_Reflection_102.jpg',
    'anime__Twilight_Sakura_Swordsman_07_007.jpg',
    'anime__Twilight_Sakura_Swordsman_27_027.jpg',
    'anime__Twilight_Sakura_Swordsman_47_047.jpg',
    'anime__Valley_End_Waterfall_088.jpg',
    'anime__Vibrant_Mountain_Valley_065.jpg',
    'anime__Vibrant_Ocean_Sunset_063.jpg',
    'anime__Void_Domain_Sorcerer_18_018.jpg',
    'anime__Void_Domain_Sorcerer_38_038.jpg',
    'anime__Zenitsu_Neon_Thunder_062.jpg',
    'anime__Zenitsu_Rainy_Day_058.jpg',
    'anime__Zero_Two_Winter_Embrace_057.jpg',
    'aniw.jpeg',
    'anya cute.jpg',
    'anya on fury.jpg',
    'astro wallpaper.jpg',
    'asuka.jpg',
    'b2b.jpg',
    'baki.jpg',
    'bb.jpg',
    'bbb.jpg',
    'bbbb.jpg',
    'beast.jpg',
    'black bg wallpaper.jpg',
    'black halo.jpg',
    'black smile.jpg',
    'black smiley wallpaper.jpg',
    'black wallpaper.jpg',
    'black walpaper Msc.jpg',
    'black wllp.jpg',
    'black1.jpg',
    'black2.jpg',
    'black3.jpg',
    'black4.jpg',
    'black7.jpg',
    'black__Aang_Avatar_State_055.jpg',
    'black__Acoustic_Starlight_Embers_044.jpg',
    'black__Amoled_Shadow_Dragon_02_002.jpg',
    'black__Amoled_Shadow_Dragon_10_010.jpg',
    'black__Amoled_Shadow_Dragon_18_018.jpg',
    'black__Amoled_Shadow_Dragon_26_026.jpg',
    'black__Amoled_Shadow_Dragon_34_034.jpg',
    'black__Astronaut_Fishing_Stars_091.jpg',
    'black__Astronaut_Starry_Void_063.jpg',
    'black__Attack_Titan_Emblem_071.jpg',
    'black__Baka_Anime_Girl_086.jpg',
    'black__Black_Dragon_Bamboo_065.jpg',
    'black__Black_White_Typography_087.jpg',
    'black__Blindfolded_Guardian_White_Lotus_041.jpg',
    'black__Blue_Hexagon_Glitch_075.jpg',
    'black__Broken_Katana_Spirit_Butterfly_039.jpg',
    'black__Cliff_Edge_Moon_085.jpg',
    'black__Crimson_Embrace_Sword_068.jpg',
    'black__Curious_Black_Cat_061.jpg',
    'black__Dark_Floral_Bloom_060.jpg',
    'black__Dark_Geometric_Horizon_082.jpg',
    'black__Dark_Matter_Glitch_05_005.jpg',
    'black__Dark_Matter_Glitch_13_013.jpg',
    'black__Dark_Matter_Glitch_21_021.jpg',
    'black__Dark_Matter_Glitch_29_029.jpg',
    'black__Dark_Square_Cascade_079.jpg',
    'black__Deep_Green_Thorns_080.jpg',
    'black__Deep_Void_Astronaut_04_004.jpg',
    'black__Deep_Void_Astronaut_12_012.jpg',
    'black__Deep_Void_Astronaut_20_020.jpg',
    'black__Deep_Void_Astronaut_28_028.jpg',
    'black__Demon_Butterfly_Night_050.jpg',
    'black__Dodge_Demon_Logo_064.jpg',
    'black__Elegant_Dark_Foliage_059.jpg',
    'black__Faceless_Red_Tie_046.jpg',
    'black__Fallen_Queen_Chess_066.jpg',
    'black__Floral_Woman_Silhouette_078.jpg',
    'black__Gaming_Hand_Controller_092.jpg',
    'black__Girl_On_Moon_073.jpg',
    'black__Glitch_Purple_Bust_070.jpg',
    'black__Glitch_Spider_Man_Logo_048.jpg',
    'black__Golden_Hand_Outline_094.jpg',
    'black__Heart_On_Chopsticks_077.jpg',
    'black__Japanese_Wave_Art_069.jpg',
    'black__Jar_Of_Butterflies_053.jpg',
    'black__Kaneki_I_Don_T_Care_049.jpg',
    'black__Lone_Wolf_Falling_Star_035.jpg',
    'black__Melting_Smiley_Face_084.jpg',
    'black__Midnight_Blue_Petals_057.jpg',
    'black__Midnight_Eclipse_Ring_07_007.jpg',
    'black__Midnight_Eclipse_Ring_15_015.jpg',
    'black__Midnight_Eclipse_Ring_23_023.jpg',
    'black__Midnight_Eclipse_Ring_31_031.jpg',
    'black__Minimal_Black_Cat_062.jpg',
    'black__Minimal_Camera_Outline_093.jpg',
    'black__Minimalist_Black_Teapot_089.jpg',
    'black__Mirrored_Black_Text_088.jpg',
    'black__Molten_Compass_Spectral_Door_038.jpg',
    'black__Monochrome_Floral_Swirl_056.jpg',
    'black__Mood_Swing_Silhouette_083.jpg',
    'black__Moonlit_Knight_Runesword_Vigil_043.jpg',
    'black__Noir_Violinist_Starlight_Birds_040.jpg',
    'black__Obito_Mangekyo_Sharingan_052.jpg',
    'black__Obsidian_Crown_Minimal_03_003.jpg',
    'black__Obsidian_Crown_Minimal_11_011.jpg',
    'black__Obsidian_Crown_Minimal_19_019.jpg',
    'black__Obsidian_Crown_Minimal_27_027.jpg',
    'black__Orange_Hexagon_Glitch_076.jpg',
    'black__Paws_Off_Cat_081.jpg',
    'black__Pink_Roses_Black_054.jpg',
    'black__Pitch_Black_Neon_Halo_01_001.jpg',
    'black__Pitch_Black_Neon_Halo_09_009.jpg',
    'black__Pitch_Black_Neon_Halo_17_017.jpg',
    'black__Pitch_Black_Neon_Halo_25_025.jpg',
    'black__Pitch_Black_Neon_Halo_33_033.jpg',
    'black__Pure_Black_Cyber_Skull_06_006.jpg',
    'black__Pure_Black_Cyber_Skull_14_014.jpg',
    'black__Pure_Black_Cyber_Skull_22_022.jpg',
    'black__Pure_Black_Cyber_Skull_30_030.jpg',
    'black__Red_Orb_Skull_072.jpg',
    'black__Red_Thread_Of_Fate_036.jpg',
    'black__Shadow_Samurai_Moon_045.jpg',
    'black__Shadow_Samurai_Silhouette_08_008.jpg',
    'black__Shadow_Samurai_Silhouette_16_016.jpg',
    'black__Shadow_Samurai_Silhouette_24_024.jpg',
    'black__Shadow_Samurai_Silhouette_32_032.jpg',
    'black__Shattered_Amethyst_Kingdom_042.jpg',
    'black__Soft_Text_Repetition_090.jpg',
    'black__Sparkling_Black_Ring_051.jpg',
    'black__Subtle_Crimson_Flora_058.jpg',
    'black__Volcanic_Lightning_Storm_047.jpg',
    'black__White_Oni_Mask_067.jpg',
    'black__Winter_Cabin_In_Silver_Drop_037.jpg',
    'black__World_Map_Journey_074.jpg',
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
    'denji.jpg',
    'download.jfif',
    'dragon black.jpg',
    'dream.jpg',
    'ds.jpeg',
    'ds2.jpeg',
    'feel bg.jpg',
    'feels bg\'.jpg',
    'feels dark bg.jpg',
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
    'game__Agent_47_Stealth_062.jpg',
    'game__Apex_Octane_Adrenaline_07_006.jpg',
    'game__Apex_Octane_Adrenaline_17_015.jpg',
    'game__Apex_Octane_Adrenaline_27_024.jpg',
    'game__Apex_Octane_Adrenaline_37_032.jpg',
    'game__Apex_Octane_Adrenaline_47_041.jpg',
    'game__Assassin_S_Creed_Archer_060.jpg',
    'game__Crimson_Eye_Gaze_055.jpg',
    'game__Dark_Masked_Warrior_061.jpg',
    'game__Devil_Hunter_Yamato_Blade_09_008.jpg',
    'game__Devil_Hunter_Yamato_Blade_19_017.jpg',
    'game__Devil_Hunter_Yamato_Blade_39_034.jpg',
    'game__Devil_Hunter_Yamato_Blade_49_043.jpg',
    'game__Elden_Ring_Tarnished_Grace_10_009.jpg',
    'game__Elden_Ring_Tarnished_Grace_20_018.jpg',
    'game__Elden_Ring_Tarnished_Grace_30_026.jpg',
    'game__Elden_Ring_Tarnished_Grace_40_035.jpg',
    'game__Elden_Ring_Tarnished_Grace_50_044.jpg',
    'game__Genshin_Lantern_Festival_054.jpg',
    'game__Ghost_Masked_Gaze_049.jpg',
    'game__Ghost_Red_Ops_050.jpg',
    'game__Ghost_Tactical_Recon_05_005.jpg',
    'game__Ghost_Tactical_Recon_25_022.jpg',
    'game__Ghost_Tactical_Recon_35_031.jpg',
    'game__Ghost_Tactical_Recon_45_039.jpg',
    'game__Ghost_Urban_Recon_048.jpg',
    'game__Green_Armored_Warrior_064.jpg',
    'game__Hollow_Knight_Emergence_066.jpg',
    'game__Hu_Tao_Serenity_053.jpg',
    'game__Meditating_Cyber_Ninja_052.jpg',
    'game__Miles_Morales_Relaxing_059.jpg',
    'game__Nier_Android_Ruins_16_014.jpg',
    'game__Nier_Android_Ruins_26_023.jpg',
    'game__Nier_Android_Ruins_46_040.jpg',
    'game__Nier_Automata_2b_065.jpg',
    'game__Nier_Automata_Battle_046.jpg',
    'game__Nier_Automata_Rooftop_051.jpg',
    'game__Night_City_Cyber_Mercenary_03_003.jpg',
    'game__Night_City_Cyber_Mercenary_13_012.jpg',
    'game__Night_City_Cyber_Mercenary_23_021.jpg',
    'game__Night_City_Cyber_Mercenary_33_029.jpg',
    'game__Night_City_Cyber_Mercenary_43_038.jpg',
    'game__Raiden_Shogun_Ukiyo_045.jpg',
    'game__Retro_Gaming_Night_057.jpg',
    'game__Samurai_Falling_Leaves_056.jpg',
    'game__Scorpion_Dark_Profile_047.jpg',
    'game__Spartan_God_Of_War_Ember_001.jpg',
    'game__Spartan_God_Of_War_Ember_010.jpg',
    'game__Spartan_God_Of_War_Ember_019.jpg',
    'game__Spartan_God_Of_War_Ember_027.jpg',
    'game__Spartan_God_Of_War_Ember_036.jpg',
    'game__Spider_Verse_Midnight_Leap_08_007.jpg',
    'game__Spider_Verse_Midnight_Leap_18_016.jpg',
    'game__Spider_Verse_Midnight_Leap_28_025.jpg',
    'game__Spider_Verse_Midnight_Leap_38_033.jpg',
    'game__Spider_Verse_Midnight_Leap_48_042.jpg',
    'game__Sub_Zero_Ice_Power_063.jpg',
    'game__Titanfall_Mech_Drop_04_004.jpg',
    'game__Titanfall_Mech_Drop_14_013.jpg',
    'game__Titanfall_Mech_Drop_34_030.jpg',
    'game__Valorant_Phantom_Agent_02_002.jpg',
    'game__Valorant_Phantom_Agent_12_011.jpg',
    'game__Valorant_Phantom_Agent_22_020.jpg',
    'game__Valorant_Phantom_Agent_32_028.jpg',
    'game__Valorant_Phantom_Agent_42_037.jpg',
    'game__Wattson_Cyberpunk_Style_058.jpg',
    'gg.jpg',
    'goku red.jpg',
    'goku.jpg',
    'hounds.jpg',
    'human bg.jpg',
    'itachi bg.jpg',
    'itachi glitch.jpg',
    'itachi sharingan.jpg',
    'itachi.jpg',
    'juijutsu Kaisen.jpg',
    'juijutsu Kaisin.jpg',
    'juijutsu kaisen ff.jpg',
    'king black.jpg',
    'leaves in many shades.jpg',
    'lke.jpg',
    'lone samurai.jpg',
    'low Bar.jpg',
    'mcu.jpg',
    'minimal__Abstract_Coastal_Landscape_032.jpg',
    'minimal__Abstract_Red_Geometry_052.jpg',
    'minimal__Angel_Girl_Sitting_060.jpg',
    'minimal__Arctic_Fox_Ice_Floe_004.jpg',
    'minimal__Bamboo_Shadow_Texture_066.jpg',
    'minimal__Better_Things_Ahead_040.jpg',
    'minimal__Blue_Hexagon_Layers_024.jpg',
    'minimal__Blue_Neon_City_033.jpg',
    'minimal__Blue_Square_Flow_044.jpg',
    'minimal__Brutalist_Archway_Violet_Eclipse_007.jpg',
    'minimal__Brutalist_Staircase_Ring_Of_Light_012.jpg',
    'minimal__Cherry_Blossom_Breeze_063.jpg',
    'minimal__Colorful_Diamond_Grid_023.jpg',
    'minimal__Cozy_Bedroom_Night_039.jpg',
    'minimal__Creation_Of_Adam_071.jpg',
    'minimal__Crescent_Moon_Black_Iceberg_006.jpg',
    'minimal__Crimson_Leaf_Black_Mirror_005.jpg',
    'minimal__Cyan_Geometric_Pattern_051.jpg',
    'minimal__Diagonal_Capsule_Pattern_050.jpg',
    'minimal__Earth_Tone_Swirl_020.jpg',
    'minimal__Enso_Brush_Stroke_058.jpg',
    'minimal__Floral_Maiden_Birds_069.jpg',
    'minimal__Floral_Woman_Portrait_038.jpg',
    'minimal__Forest_Reflection_Child_018.jpg',
    'minimal__Gold_Leaf_Origami_Cranes_010.jpg',
    'minimal__Golden_Crane_Blossom_034.jpg',
    'minimal__Golden_Cranes_Hourglass_001.jpg',
    'minimal__Green_Hexagon_Pattern_065.jpg',
    'minimal__Hand_Holding_Monstera_059.jpg',
    'minimal__Ink_And_Moonlight_Koi_002.jpg',
    'minimal__Intersecting_Lines_Pattern_025.jpg',
    'minimal__Karma_Minimal_Design_062.jpg',
    'minimal__Liquid_Mercury_Sound_Wave_009.jpg',
    'minimal__Little_Ghost_Minimal_056.jpg',
    'minimal__Minimal_Mountain_Birds_015.jpg',
    'minimal__Minimalist_Forest_Dawn_035.jpg',
    'minimal__Minimalist_Forest_Mountains_067.jpg',
    'minimal__Minimalist_Tree_Silhouette_068.jpg',
    'minimal__Misty_Cityscape_Dawn_031.jpg',
    'minimal__Misty_Forest_Deer_061.jpg',
    'minimal__Misty_Meadow_Flowers_054.jpg',
    'minimal__Oni_Butterfly_Gradient_037.jpg',
    'minimal__Oni_Mask_Sketch_053.jpg',
    'minimal__Orange_Teal_Circles_046.jpg',
    'minimal__Oriental_Study_View_042.jpg',
    'minimal__Pastel_Forest_Flowers_055.jpg',
    'minimal__Pastel_Mountain_Mist_016.jpg',
    'minimal__Pastel_Wave_Swirl_021.jpg',
    'minimal__Pawn_Casting_King_Shadow_014.jpg',
    'minimal__Pink_Cherry_Blossoms_028.jpg',
    'minimal__Pixel_Plane_Cloud_026.jpg',
    'minimal__Razor_Horizon_Orange_Pulse_013.jpg',
    'minimal__Red_Blue_Pentagons_048.jpg',
    'minimal__Retro_Cassette_Pattern_041.jpg',
    'minimal__Rose_Gold_Ink_Ripples_011.jpg',
    'minimal__Serene_Pastel_Mountains_030.jpg',
    'minimal__Smoked_Glass_Laser_Prisms_008.jpg',
    'minimal__Soft_Mandala_Pattern_070.jpg',
    'minimal__Soft_Pink_Blossoms_027.jpg',
    'minimal__Solitary_Mountain_View_029.jpg',
    'minimal__Solitary_Paddleboarder_Mist_019.jpg',
    'minimal__Solitary_Tree_Silhouette_043.jpg',
    'minimal__Spiral_Staircase_Lightkeeper_003.jpg',
    'minimal__Sunny_Study_Room_017.jpg',
    'minimal__Teal_Circle_Layers_047.jpg',
    'minimal__Textured_Tree_Silhouette_064.jpg',
    'minimal__Vibrant_Rooted_Tree_036.jpg',
    'minimal__Wavy_Red_Lines_045.jpg',
    'minimal__Wavy_Striped_Texture_049.jpg',
    'minimal__Woven_Teal_Squares_022.jpg',
    'minimal__Yin_Yang_Dragon_057.jpg',
    'mobile_wallpaper70-468.jpg',
    'moon.jpg',
    'mountain and trees.jpg',
    'mountain view (2).jpg',
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
    'nature__Abyssal_Sunbeam_Freediver_012.jpg',
    'nature__Autumn_Leaves_Glow_052.jpg',
    'nature__Bioluminescent_Rainforest_Frog_014.jpg',
    'nature__Bioluminescent_Volcanic_Wave_003.jpg',
    'nature__Cabin_Under_Moonlight_043.jpg',
    'nature__Castle_Waterfall_Sunset_029.jpg',
    'nature__Cherry_Blossom_Sunset_026.jpg',
    'nature__Clover_Field_Dewdrops_060.jpg',
    'nature__Dark_Green_Leaves_046.jpg',
    'nature__Deep_Blue_Ocean_061.jpg',
    'nature__Deep_Red_Hibiscus_062.jpg',
    'nature__Emerald_Aurora_Alpine_Boat_002.jpg',
    'nature__Enchanted_Forest_Lanterns_019.jpg',
    'nature__Enchanted_Moonlit_Forest_018.jpg',
    'nature__Enchanted_Mushroom_Moss_042.jpg',
    'nature__Enchanted_Waterfall_Glow_025.jpg',
    'nature__Floating_Lanterns_Lake_027.jpg',
    'nature__Frost_Rose_Volcanic_Twilight_011.jpg',
    'nature__Glowing_Beach_Pebbles_045.jpg',
    'nature__Glowworm_Cave_River_Kayak_008.jpg',
    'nature__Golden_Fireflies_Hollow_Sequoia_015.jpg',
    'nature__Golden_Fountain_Park_054.jpg',
    'nature__Golden_Moon_Tree_056.jpg',
    'nature__Golden_Ocean_Sunset_039.jpg',
    'nature__Green_Meadow_Flowers_063.jpg',
    'nature__Heavenly_Cloudscape_Sunset_022.jpg',
    'nature__Himalayan_Ridge_Starlight_Flags_013.jpg',
    'nature__Japanese_Cherry_Blossom_Temple_021.jpg',
    'nature__Lightning_Oak_Storm_Hill_006.jpg',
    'nature__Lucky_Clover_Stone_048.jpg',
    'nature__Lush_Jungle_Waterfall_040.jpg',
    'nature__Majestic_Eagle_Flight_050.jpg',
    'nature__Midnight_Bamboo_Stone_Lantern_010.jpg',
    'nature__Midnight_Storm_Cliff_Cabin_001.jpg',
    'nature__Milky_Way_Slot_Canyon_007.jpg',
    'nature__Misty_Cliffside_Retreat_035.jpg',
    'nature__Misty_Mountain_Boat_038.jpg',
    'nature__Misty_Mountain_Layers_059.jpg',
    'nature__Molten_Lava_Ocean_Ridge_005.jpg',
    'nature__Monochrome_Dewdrops_Flower_053.jpg',
    'nature__Moonlit_Mist_Bonsai_Spire_004.jpg',
    'nature__Mystical_Cloud_Lake_036.jpg',
    'nature__Neon_Waterfall_Moon_017.jpg',
    'nature__Obsidian_Lighthouse_Golden_Beam_016.jpg',
    'nature__Ocean_Wave_Sunset_037.jpg',
    'nature__Pastel_Mountain_Sunset_031.jpg',
    'nature__Purple_Moon_Tree_057.jpg',
    'nature__Rainy_Autumn_Drive_047.jpg',
    'nature__Serene_Winter_Mountains_024.jpg',
    'nature__Snowy_Lakeside_Road_044.jpg',
    'nature__Snowy_Lakeside_Village_033.jpg',
    'nature__Solar_Eclipse_Desert_Saguaro_009.jpg',
    'nature__Solitary_Red_Tree_032.jpg',
    'nature__Starry_Mountain_Night_030.jpg',
    'nature__Starry_Night_Valley_049.jpg',
    'nature__Sunflower_Sunset_Glow_058.jpg',
    'nature__Sunset_Mountain_Meadow_028.jpg',
    'nature__Swirling_Neon_Butterflies_051.jpg',
    'nature__Textured_White_Blossoms_055.jpg',
    'nature__Traditional_Waterfall_Painting_023.jpg',
    'nature__Tropical_Mountain_Coast_041.jpg',
    'nature__Tropical_Sunset_Cabin_020.jpg',
    'nature__Winter_Lake_Cabin_034.jpg',
    'nature_bg.jpg',
    'night lantern.jpg',
    'omen valorant 2020 artwork iPhone 11 Wallpapers.jpeg',
    'overwatch wallpapers 27.jpeg',
    'owl.jpg',
    'pass.png',
    'pine and dew.jpg',
    'quotes__Always_Believe_Yourself_012.jpg',
    'quotes__Always_Hope_Clover_026.jpg',
    'quotes__Awesome_Glitch_Text_015.jpg',
    'quotes__Beautiful_Peacock_Quote_019.jpg',
    'quotes__Believe_In_Yourself_038.jpg',
    'quotes__C_Est_La_Vie_008.jpg',
    'quotes__Crowned_Skull_Ongod_041.jpg',
    'quotes__Deserving_Universe_Affirmation_014.jpg',
    'quotes__Don_T_Kill_Kid_031.jpg',
    'quotes__Empty_Atelophobia_Quote_025.jpg',
    'quotes__God_Is_Always_037.jpg',
    'quotes__Gods_Plan_Heart_047.jpg',
    'quotes__Gojo_Study_Motivation_035.jpg',
    'quotes__Growth_Tree_Silhouettes_046.jpg',
    'quotes__Just_Do_It_009.jpg',
    'quotes__Just_Keep_Smiling_029.jpg',
    'quotes__Limited_Edition_Quote_023.jpg',
    'quotes__Live_Fast_Die_Last_003.jpg',
    'quotes__Love_Your_Enemies_039.jpg',
    'quotes__Motivational_Life_Quotes_006.jpg',
    'quotes__Never_Forget_Memories_032.jpg',
    'quotes__Never_Give_Up_Lion_005.jpg',
    'quotes__Never_Settle_Abstract_022.jpg',
    'quotes__Never_Settle_Coast_042.jpg',
    'quotes__Never_Settle_Dynamic_018.jpg',
    'quotes__Never_Settle_Gradient_016.jpg',
    'quotes__Never_Settle_Grunge_044.jpg',
    'quotes__Never_Settle_Lion_004.jpg',
    'quotes__Never_Settle_Marble_017.jpg',
    'quotes__Never_Settle_Ocean_002.jpg',
    'quotes__Never_Settle_Planet_021.jpg',
    'quotes__Never_Settle_Spirit_024.jpg',
    'quotes__Never_Settle_Stars_020.jpg',
    'quotes__No_One_Except_You_007.jpg',
    'quotes__Rise_Like_Toji_045.jpg',
    'quotes__Shoot_For_Moon_028.jpg',
    'quotes__Show_Me_Possibilities_033.jpg',
    'quotes__Starts_And_Ends_036.jpg',
    'quotes__Stay_Focused_Committed_011.jpg',
    'quotes__Stay_Humble_Hands_043.jpg',
    'quotes__Take_Leap_Faith_027.jpg',
    'quotes__Think_Outside_Box_013.jpg',
    'quotes__Tyler_Joseph_Lyrics_034.jpg',
    'quotes__Warrior_Mindset_Quote_001.jpg',
    'quotes__Winning_Streak_Arrow_040.jpg',
    'quotes__Words_Our_Hearts_030.jpg',
    'quotes__Work_For_It_010.jpg',
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
    'random__Adorable_Doodle_Cats_035.jpg',
    'random__Anonymous_Masked_Figure_039.jpg',
    'random__Autumn_Tram_Ride_015.jpg',
    'random__Black_Cat_Notes_022.jpg',
    'random__Cat_Butterfly_Spring_029.jpg',
    'random__Celestial_Library_Star_Reader_008.jpg',
    'random__Celestial_Whale_Above_Rooftops_001.jpg',
    'random__Chalkboard_Math_Formulas_033.jpg',
    'random__Chaotic_Doodle_World_034.jpg',
    'random__City_Sunset_Dream_010.jpg',
    'random__Cool_Lion_Sunglasses_024.jpg',
    'random__Cozy_Blanket_Cat_018.jpg',
    'random__Cozy_Night_Study_014.jpg',
    'random__Crowned_Pawn_Victory_020.jpg',
    'random__Cute_Doodle_Characters_036.jpg',
    'random__Dome_Of_Doves_025.jpg',
    'random__Electric_Blue_Panther_013.jpg',
    'random__Falling_Snowflakes_Blue_037.jpg',
    'random__Ferris_Wheel_Night_031.jpg',
    'random__Fiery_Warrior_Woman_009.jpg',
    'random__Finn_Jake_Relaxing_030.jpg',
    'random__Forest_Spirit_Cocoon_016.jpg',
    'random__Golden_Hundred_Dollar_017.jpg',
    'random__Holographic_Stardust_Vinyl_Turntable_005.jpg',
    'random__Lantern_Sky_Ship_Crescent_Moon_006.jpg',
    'random__Leaning_Cartoon_Boy_032.jpg',
    'random__Minions_Rope_Balance_023.jpg',
    'random__Noir_Detective_Whiskey_Radio_007.jpg',
    'random__Overhead_Apartment_View_019.jpg',
    'random__Overwhelmed_By_Books_028.jpg',
    'random__Pocket_Watch_Stormy_Lighthouse_004.jpg',
    'random__Post_Apocalyptic_Sunset_027.jpg',
    'random__Rainy_City_Night_011.jpg',
    'random__Rainy_Train_Window_Neon_Platform_002.jpg',
    'random__Red_Basketball_Court_021.jpg',
    'random__Sakura_Dragon_Forest_012.jpg',
    'random__Snowfall_Streetlamp_Barn_Owl_003.jpg',
    'random__Strawberry_Water_Splash_038.jpg',
    'random__Underwater_Dog_Surprise_040.jpg',
    'random__Wizard_Forest_Entrance_026.jpg',
    'rwby.jfif',
    'saber_fate-932 (1).jpg',
    'saber_fate-932.jpg',
    'scifi__Abyssal_Planet_Campfire_007.jpg',
    'scifi__Alien_Mountain_Planet_030.jpg',
    'scifi__Astronaut_Streetlamp_In_Space_008.jpg',
    'scifi__Autumn_Road_King_037.jpg',
    'scifi__Blade_Runner_Desert_028.jpg',
    'scifi__Blade_Runner_Glitch_053.jpg',
    'scifi__Blade_Runner_Hologram_017.jpg',
    'scifi__Blade_Runner_Logo_051.jpg',
    'scifi__Bumblebee_Blue_Sky_039.jpg',
    'scifi__Carbon_Biomech_Amber_Core_012.jpg',
    'scifi__Code_Breaker_Hacker_062.jpg',
    'scifi__Colorful_Cosmic_Swirl_045.jpg',
    'scifi__Colorful_Vintage_Car_038.jpg',
    'scifi__Cosmic_Mountain_Highway_032.jpg',
    'scifi__Cosmic_Nebula_Planet_023.jpg',
    'scifi__Cosmic_Nebula_Planets_022.jpg',
    'scifi__Cosmic_Road_Journey_034.jpg',
    'scifi__Custom_Porsche_Gt3_033.jpg',
    'scifi__Cyber_Noir_Stray_Cat_009.jpg',
    'scifi__Cybernetic_Human_Interface_056.jpg',
    'scifi__Cyberpunk_Hooded_Smoker_025.jpg',
    'scifi__Cyberpunk_Neon_City_016.jpg',
    'scifi__Cyberpunk_Night_Apex_06_001.jpg',
    'scifi__Cyberpunk_Night_Apex_15_002.jpg',
    'scifi__Cyberpunk_Night_Apex_29_004.jpg',
    'scifi__Cyberpunk_Night_Apex_36_005.jpg',
    'scifi__Cyberpunk_Night_Apex_44_006.jpg',
    'scifi__Deadpool_Red_Logo_057.jpg',
    'scifi__Desert_Race_Car_040.jpg',
    'scifi__Desert_Race_Car_042.jpg',
    'scifi__Dreamy_Cosmic_Night_018.jpg',
    'scifi__Dune_Desert_Landscape_049.jpg',
    'scifi__Dune_Sandworm_Attack_026.jpg',
    'scifi__Dusty_Barn_Muscle_054.jpg',
    'scifi__Emerald_Nebula_Dimensional_Rift_011.jpg',
    'scifi__Fiery_Cosmic_Planet_047.jpg',
    'scifi__Fiery_Sports_Car_036.jpg',
    'scifi__Floating_Village_Planet_015.jpg',
    'scifi__Futuristic_Car_Speed_058.jpg',
    'scifi__Giant_Robot_Guardian_041.jpg',
    'scifi__Green_Challenger_Headlights_043.jpg',
    'scifi__Joi_Neon_Gaze_052.jpg',
    'scifi__Lamborghini_Forest_Drive_031.jpg',
    'scifi__Mandalorian_Holocron_Shrine_003.jpg',
    'scifi__Midnight_Highway_Retro_Payphone_014.jpg',
    'scifi__Midnight_Salt_Flat_Motorcycle_010.jpg',
    'scifi__Neon_City_Train_019.jpg',
    'scifi__Neon_Joi_Reflection_027.jpg',
    'scifi__Neon_Tokyo_Alley_060.jpg',
    'scifi__Never_Settle_Mclaren_024.jpg',
    'scifi__Pagani_Never_Settle_029.jpg',
    'scifi__Palm_Tree_Boulevard_044.jpg',
    'scifi__Pink_Moon_Night_046.jpg',
    'scifi__Porsche_911_Gt3rs_021.jpg',
    'scifi__Purple_Neon_Fog_050.jpg',
    'scifi__Purple_Spider_Web_063.jpg',
    'scifi__Red_Moon_Cityscape_035.jpg',
    'scifi__Rooftop_Hacker_View_055.jpg',
    'scifi__Skyscrapers_Night_Glow_059.jpg',
    'scifi__Sliced_Obelisk_Cyan_Energy_013.jpg',
    'scifi__Spider_Web_Symbol_061.jpg',
    'scifi__Steampunk_Skull_Soldier_020.jpg',
    'scifi__Tactical_Metro_Escalator_048.jpg',
    'shoreline.jpg',
    'skyAni.jfif',
    'smiley black.jpg',
    'snowy night.jpg',
    'stones.jpg',
    'stream.jpg',
    'time splash.jpg',
    'valo.jfif',
    'valo2.jfif',
    'valo3.jfif',
    'valo4.jfif',
    'valo5.jfif',
    'water.jpg',
    'waterfall anime.jpg',
    'whale.jpg',
    'woods.jpg',
    '🍎Valorant Wallpaper Time, Jr Pencil.jpeg',
  ];
}
