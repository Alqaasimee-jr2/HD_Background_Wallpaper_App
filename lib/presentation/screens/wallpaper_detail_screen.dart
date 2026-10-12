import 'package:flutter/material.dart';
import '../../domain/models/wallpaper_item.dart';
import '../state/wallpaper_controller.dart';
import '../widgets/live_mockup_overlays.dart';
import '../widgets/wallpaper_card.dart';

class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({
    super.key,
    required this.item,
    required this.controller,
  });

  final WallpaperItem item;
  final WallpaperController controller;

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _isWorking = false;

  Future<void> _handleSetWallpaper(String target, String label) async {
    Navigator.of(context).pop();
    setState(() => _isWorking = true);
    final success = await widget.controller.applyWallpaper(widget.item, target);
    if (!mounted) return;
    setState(() => _isWorking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Wallpaper applied to $label!'
              : 'Could not apply wallpaper.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSetWallpaperSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF161B26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Apply 4K Wallpaper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select where you want this wallpaper applied:',
                  style: TextStyle(color: Color(0xFFA0AAB8), fontSize: 13),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    Icons.home_rounded,
                    color: Color(0xFF00E5FF),
                  ),
                  title: const Text(
                    'Home Screen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Set as main launcher background',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  onTap: () => _handleSetWallpaper('home', 'Home Screen'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF6C63FF),
                  ),
                  title: const Text(
                    'Lock Screen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Set as lock screen backdrop',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  onTap: () => _handleSetWallpaper('lock', 'Lock Screen'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.devices_rounded,
                    color: Color(0xFF2ECC71),
                  ),
                  title: const Text(
                    'Both Screens',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Synchronize Home & Lock screens',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  onTap: () => _handleSetWallpaper('both', 'Both Screens'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddToCollectionSheet() {
    final textController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161B26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Save to Custom Folder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...widget.controller.collections.map((collection) {
                final contains = collection.wallpaperIds.contains(widget.item.id);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.folder_special_rounded,
                    color: Color(0xFF6C63FF),
                  ),
                  title: Text(
                    collection.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${collection.wallpaperIds.length} wallpapers',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
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
                      widget.item.id,
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
                        hintText: 'New folder name (e.g. Cyberpunk Set)',
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
                        widget.item.id,
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
        );
      },
    );
  }

  Future<void> _handleSaveToGallery() async {
    setState(() => _isWorking = true);
    final success = await widget.controller.saveWallpaperToGallery(widget.item);
    if (!mounted) return;
    setState(() => _isWorking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Saved to Pictures/HDWallpapers!'
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
        final mode = widget.controller.mockupMode;
        final isFav = widget.controller.isFavorite(widget.item.id);

        return Scaffold(
          backgroundColor: const Color(0xFF0B0E14),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Hero(
                  tag: 'wallpaper_${widget.item.id}',
                  child: WallpaperImageView(
                    item: widget.item,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (mode == MockupMode.lockScreen) const LockScreenMockupOverlay(),
              if (mode == MockupMode.homeScreen) const HomeScreenMockupOverlay(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: const Color(0xAA0B0E14),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xAA0B0E14),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${widget.item.category} • ${widget.item.resolutionLabel}',
                                    style: const TextStyle(
                                      color: Color(0xFF00E5FF),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xCC0B0E14),
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
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xDD161B26),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              tooltip: 'Favorite',
                              onPressed: () {
                                widget.controller.toggleFavorite(widget.item.id);
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
                              onPressed: _isWorking ? null : _handleSaveToGallery,
                              icon: const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C63FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed:
                                    _isWorking ? null : _showSetWallpaperSheet,
                                icon: _isWorking
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.wallpaper_rounded),
                                label: const Text(
                                  'Set Wallpaper',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
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
