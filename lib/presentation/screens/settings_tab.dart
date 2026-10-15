import 'package:flutter/material.dart';
import '../state/theme_controller.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.themeController,
  });

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                ),
              ),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.brightness_medium_rounded),
                    title: const Text('Theme Mode'),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeController.themeMode,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          themeController.setThemeMode(mode);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.palette_rounded),
                    title: const Text('Accent Color'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ColorOption(
                          color: const Color(0xFF6C63FF),
                          selected: themeController.seedColor == const Color(0xFF6C63FF),
                          onTap: () => themeController.setSeedColor(const Color(0xFF6C63FF)),
                        ),
                        const SizedBox(width: 8),
                        _ColorOption(
                          color: const Color(0xFF00E5FF),
                          selected: themeController.seedColor == const Color(0xFF00E5FF),
                          onTap: () => themeController.setSeedColor(const Color(0xFF00E5FF)),
                        ),
                        const SizedBox(width: 8),
                        _ColorOption(
                          color: const Color(0xFFFF4757),
                          selected: themeController.seedColor == const Color(0xFFFF4757),
                          onTap: () => themeController.setSeedColor(const Color(0xFFFF4757)),
                        ),
                        const SizedBox(width: 8),
                        _ColorOption(
                          color: const Color(0xFF2ECC71),
                          selected: themeController.seedColor == const Color(0xFF2ECC71),
                          onTap: () => themeController.setSeedColor(const Color(0xFF2ECC71)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Wallpaper Options (Placeholder)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                ),
              ),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('High Quality Downloads'),
                    subtitle: const Text('Save wallpapers in maximum resolution'),
                    value: true,
                    onChanged: (val) {},
                    secondary: const Icon(Icons.hd_rounded),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Auto-save to Gallery'),
                    subtitle: const Text('Save applied wallpapers automatically'),
                    value: false,
                    onChanged: (val) {},
                    secondary: const Icon(Icons.save_alt_rounded),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 18,
              )
            : null,
      ),
    );
  }
}
