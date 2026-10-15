import 'package:flutter/material.dart';
import '../../domain/models/wallpaper_item.dart';
import '../state/wallpaper_controller.dart';
import '../widgets/live_mockup_overlays.dart';
import '../widgets/wallpaper_card.dart';
import '../widgets/color_filter_layer.dart';

class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({
    super.key,
    required this.item,
    required this.controller,
    this.playlist,
  });

  final WallpaperItem item;
  final WallpaperController controller;
  final List<WallpaperItem>? playlist;

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _isWorking = false;
  bool _hideControls = false;
  late List<WallpaperItem> _items;
  late int _currentIndex;
  late PageController _pageController;
  WallpaperFilterMode _filterMode = WallpaperFilterMode.none;

  WallpaperItem get _activeItem => _items[_currentIndex];

  @override
  void initState() {
    super.initState();
    final provided = widget.playlist;
    if (provided != null && provided.isNotEmpty) {
      _items = provided;
      final foundIdx = _items.indexWhere((e) => e.id == widget.item.id);
      _currentIndex = foundIdx >= 0 ? foundIdx : 0;
    } else {
      _items = <WallpaperItem>[widget.item];
      _currentIndex = 0;
    }
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleSetWallpaper(String target, String label) async {
    final current = _activeItem;
    Navigator.of(context).pop();
    setState(() => _isWorking = true);
    final success = await widget.controller.applyWallpaper(current, target);
    if (!mounted) return;
    setState(() => _isWorking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Applied "${current.title}" to $label'
              : 'Could not apply wallpaper on this device.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSetWallpaperSheet() {
    final current = _activeItem;
    final accent = WallpaperImageView.parseHexColor(current.accentColorHex);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111520),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Apply "${current.title}"',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Choose where to apply this QHD+ / 4K wallpaper:',
                    style: TextStyle(color: Color(0xFFA0AAB8), fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  _ApplyOptionTile(
                    icon: Icons.home_rounded,
                    iconColor: const Color(0xFF00E5FF),
                    title: 'Home Screen',
                    subtitle: 'Set as main launcher background',
                    onTap: () => _handleSetWallpaper('home', 'Home Screen'),
                  ),
                  const SizedBox(height: 8),
                  _ApplyOptionTile(
                    icon: Icons.lock_rounded,
                    iconColor: const Color(0xFF6C63FF),
                    title: 'Lock Screen',
                    subtitle: 'Set as lock screen backdrop',
                    onTap: () => _handleSetWallpaper('lock', 'Lock Screen'),
                  ),
                  const SizedBox(height: 8),
                  _ApplyOptionTile(
                    icon: Icons.devices_rounded,
                    iconColor: const Color(0xFF2ECC71),
                    title: 'Both Screens',
                    subtitle: 'Synchronize Home & Lock screens together',
                    onTap: () => _handleSetWallpaper('both', 'Both Screens'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddToCollectionSheet() {
    final current = _activeItem;
    final textController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111520),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18,
              bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 18,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Save to Custom Folder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pin "${current.title}" to a personal collection:',
                    style: const TextStyle(
                      color: Color(0xFFA0AAB8),
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.controller.collections.map((collection) {
                    final contains = collection.wallpaperIds.contains(current.id);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.folder_special_rounded,
                        color: Color(0xFF6C63FF),
                      ),
                      title: Text(
                        collection.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${collection.wallpaperIds.length} wallpapers',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(
                        contains
                            ? Icons.check_circle_rounded
                            : Icons.add_circle_outline_rounded,
                        color: contains
                            ? const Color(0xFF2ECC71)
                            : Colors.white70,
                      ),
                      onTap: () async {
                        final navigator = Navigator.of(sheetContext);
                        final messenger = ScaffoldMessenger.of(context);
                        await widget.controller.addWallpaperToCollection(
                          collection.name,
                          current.id,
                        );
                        if (!mounted) return;
                        navigator.pop();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Added to "${collection.name}"'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  }),
                  const Divider(color: Colors.white12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'New folder name (e.g. Dark Story Mode)',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () async {
                          final name = textController.text.trim();
                          if (name.isEmpty) return;
                          final navigator = Navigator.of(sheetContext);
                          final messenger = ScaffoldMessenger.of(context);
                          await widget.controller.addWallpaperToCollection(
                            name,
                            current.id,
                          );
                          if (!mounted) return;
                          navigator.pop();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text('Created "$name" & added wallpaper'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Create & Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSaveToGallery() async {
    final current = _activeItem;
    setState(() => _isWorking = true);
    final success = await widget.controller.saveWallpaperToGallery(current);
    if (!mounted) return;
    setState(() => _isWorking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Saved "${current.title}" to Pictures/HDWallpapers'
              : 'Could not save image to gallery.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final current = _activeItem;
        final mode = widget.controller.mockupMode;
        final isFav = widget.controller.isFavorite(current.id);
        final accent = WallpaperImageView.parseHexColor(current.accentColorHex);

        return Scaffold(
          backgroundColor: const Color(0xFF06080D),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (mode == MockupMode.clean) {
                    setState(() => _hideControls = !_hideControls);
                  }
                },
                child: ColorFilterLayer(
                  mode: _filterMode,
                  child: _items.length == 1
                      ? InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: Hero(
                            tag: 'wallpaper_${current.id}',
                            child: WallpaperImageView(
                              item: current,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: _items.length,
                          onPageChanged: (idx) {
                            setState(() => _currentIndex = idx);
                          },
                          itemBuilder: (context, index) {
                            final pageItem = _items[index];
                            final imageWidget = WallpaperImageView(
                              item: pageItem,
                              fit: BoxFit.cover,
                            );
                            return InteractiveViewer(
                              minScale: 1.0,
                              maxScale: 4.0,
                              child: index == _currentIndex
                                  ? Hero(
                                      tag: 'wallpaper_${pageItem.id}',
                                      child: imageWidget,
                                    )
                                  : imageWidget,
                            );
                          },
                        ),
                ),
              ),
              if (mode == MockupMode.lockScreen) const LockScreenMockupOverlay(),
              if (mode == MockupMode.homeScreen) const HomeScreenMockupOverlay(),
              if (!_hideControls || mode != MockupMode.clean)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: const Color(0xBB06080D),
                                  child: IconButton(
                                    tooltip: 'Back',
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xBB06080D),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.35),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                current.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                              const SizedBox(height: 1),
                                              Text(
                                                '${current.category} • ${current.resolutionLabel}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: accent,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (_items.length > 1) ...<Widget>[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              '${_currentIndex + 1}/${_items.length}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xD806080D),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _MockupModeChip(
                                  label: 'Clean',
                                  selected: mode == MockupMode.clean,
                                  onTap: () => widget.controller
                                      .setMockupMode(MockupMode.clean),
                                ),
                                _MockupModeChip(
                                  label: 'Lock Screen',
                                  selected: mode == MockupMode.lockScreen,
                                  onTap: () => widget.controller
                                      .setMockupMode(MockupMode.lockScreen),
                                ),
                                _MockupModeChip(
                                  label: 'Home Screen',
                                  selected: mode == MockupMode.homeScreen,
                                  onTap: () => widget.controller
                                      .setMockupMode(MockupMode.homeScreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xD806080D),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _MockupModeChip(
                                  label: 'Normal',
                                  selected: _filterMode == WallpaperFilterMode.none,
                                  onTap: () => setState(() => _filterMode = WallpaperFilterMode.none),
                                ),
                                _MockupModeChip(
                                  label: 'B&W',
                                  selected: _filterMode == WallpaperFilterMode.grayscale,
                                  onTap: () => setState(() => _filterMode = WallpaperFilterMode.grayscale),
                                ),
                                _MockupModeChip(
                                  label: 'Inverted',
                                  selected: _filterMode == WallpaperFilterMode.inverted,
                                  onTap: () => setState(() => _filterMode = WallpaperFilterMode.inverted),
                                ),
                                _MockupModeChip(
                                  label: 'Sepia',
                                  selected: _filterMode == WallpaperFilterMode.sepia,
                                  onTap: () => setState(() => _filterMode = WallpaperFilterMode.sepia),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xEB111520),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    tooltip: 'Favorite',
                                    onPressed: () {
                                      widget.controller.toggleFavorite(
                                        current.id,
                                      );
                                    },
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: isFav
                                          ? const Color(0xFFFF4757)
                                          : Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Add to Folder',
                                    onPressed: _showAddToCollectionSheet,
                                    icon: const Icon(
                                      Icons.create_new_folder_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Save to Gallery',
                                    onPressed: _isWorking
                                        ? null
                                        : _handleSaveToGallery,
                                    icon: const Icon(
                                      Icons.download_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF6C63FF),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 13,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: _isWorking
                                          ? null
                                          : _showSetWallpaperSheet,
                                      icon: _isWorking
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.wallpaper_rounded,
                                              size: 19,
                                            ),
                                      label: const Text(
                                        'Set Wallpaper',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ApplyOptionTile extends StatelessWidget {
  const _ApplyOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF181E2C),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockupModeChip extends StatelessWidget {
  const _MockupModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6C63FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
