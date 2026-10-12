import 'package:flutter/material.dart';

class LockScreenMockupOverlay extends StatelessWidget {
  const LockScreenMockupOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompactHeight = constraints.maxHeight < 560;
          final topPad = isCompactHeight ? 24.0 : 56.0;
          final bottomPad = isCompactHeight ? 88.0 : 132.0;
          final clockFontSize = isCompactHeight ? 48.0 : 74.0;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x55000000),
                  Color(0x00000000),
                  Color(0x66000000),
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(24, topPad, 24, bottomPad),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                    SizedBox(height: isCompactHeight ? 4 : 8),
                    Text(
                      '22:18',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: clockFontSize,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -2,
                        height: 1.0,
                        shadows: const <Shadow>[
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Mon, Oct 12  •  21°C Clear',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: isCompactHeight ? 12 : 26),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isCompactHeight ? 10 : 14),
                      decoration: BoxDecoration(
                        color: const Color(0xA6111520),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: Color(0xFF6C63FF),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'HD Wallpaper Studio • Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Lock screen depth & contrast check active.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const _LockShortcutButton(
                          icon: Icons.flashlight_on_rounded,
                        ),
                        Container(
                          width: 110,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const _LockShortcutButton(
                          icon: Icons.camera_alt_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LockShortcutButton extends StatelessWidget {
  const _LockShortcutButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0x88111520),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white, size: 19),
    );
  }
}

class HomeScreenMockupOverlay extends StatelessWidget {
  const HomeScreenMockupOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompactHeight = constraints.maxHeight < 560;
          final topPad = isCompactHeight ? 24.0 : 48.0;
          final bottomPad = isCompactHeight ? 88.0 : 132.0;

          return Container(
            padding: EdgeInsets.fromLTRB(20, topPad, 20, bottomPad),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '22:18',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.wifi_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.signal_cellular_4_bar_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.battery_full_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: isCompactHeight ? 12 : 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xAA111520),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: <Widget>[
                          Icon(
                            Icons.search_rounded,
                            color: Color(0xFF00E5FF),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search apps, web & widgets...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.mic_none_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _MockAppIcon(
                          icon: Icons.photo_library_rounded,
                          label: 'Gallery',
                          color: Color(0xFF6C63FF),
                        ),
                        _MockAppIcon(
                          icon: Icons.music_note_rounded,
                          label: 'Music',
                          color: Color(0xFFFF5252),
                        ),
                        _MockAppIcon(
                          icon: Icons.cloud_queue_rounded,
                          label: 'Weather',
                          color: Color(0xFF00E5FF),
                        ),
                        _MockAppIcon(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          color: Color(0xFF2ECC71),
                        ),
                      ],
                    ),
                    SizedBox(height: isCompactHeight ? 12 : 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xAA111520),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _DockIcon(
                            icon: Icons.call_rounded,
                            color: Color(0xFF2ECC71),
                          ),
                          _DockIcon(
                            icon: Icons.chat_bubble_rounded,
                            color: Color(0xFF3498DB),
                          ),
                          _DockIcon(
                            icon: Icons.public_rounded,
                            color: Color(0xFF9B59B6),
                          ),
                          _DockIcon(
                            icon: Icons.camera_alt_rounded,
                            color: Color(0xFFE67E22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MockAppIcon extends StatelessWidget {
  const _MockAppIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 25),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
