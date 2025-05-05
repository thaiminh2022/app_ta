import 'package:app_ta/features/dashboard/presentation/quick_action_card.dart';
import 'package:app_ta/features/dashboard/presentation/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _videoController = VideoPlayerController.asset('assets/home_screen/video_background.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _showSettingsDialog() {
    final appState = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor:
        Theme.of(dialogContext).brightness == Brightness.dark
            ? const Color.fromRGBO(66, 66, 66, 1)
            : const Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(dialogContext).colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text("Theme: ")),
                Switch(
                  thumbIcon: WidgetStatePropertyAll(
                    Icon(
                      appState.isDarkTheme
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  ),
                  value: !appState.isDarkTheme,
                  onChanged: (value) async {
                    if (appState.isDarkTheme == value) {
                      await appState.toggleTheme();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor:
        Theme.of(dialogContext).brightness == Brightness.dark
            ? const Color.fromRGBO(66, 66, 66, 1)
            : const Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'About',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(dialogContext).colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Name: DailyE',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.onSurface,
              ),
            ),
            Text(
              'Version: V1.0.0',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _quitApp() {
    SystemNavigator.pop();
  }

  void _showProfileMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: [
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Settings',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'about',
          child: Row(
            children: [
              Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'About',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'quit',
          child: Row(
            children: [
              const Icon(Icons.exit_to_app, color: Color.fromRGBO(255, 66, 66, 1)),
              const SizedBox(width: 8),
              Text(
                'Quit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:
      Theme.of(context).brightness == Brightness.dark
          ? const Color.fromRGBO(66, 66, 66, 1)
          : const Color.fromRGBO(255, 255, 255, 1),
    ).then((value) {
      if (value == 'settings') {
        _showSettingsDialog();
      } else if (value == 'about') {
        _showAboutDialog();
      } else if (value == 'quit') {
        _quitApp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _videoController.value.isInitialized
              ? Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: VideoPlayer(_videoController),
            ),
          )
              : Container(
            color: const Color.fromRGBO(0, 0, 0, 1), // Fallback background
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(173, 216, 230, 1), // Xanh nhạt
                                  Color.fromRGBO(135, 206, 235, 1), // Xanh dương nhạt hơn
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'DailyE Dashboard',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  shadows: [
                                    Shadow(
                                      color: const Color.fromRGBO(0, 0, 0, 0.3),
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _showProfileMenu,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/icon/icon.png'),
                          child: const Icon(Icons.person, color: Color.fromRGBO(128, 128, 128, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      FadeTransition(opacity: _animation, child: StatsCard()),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _animation,
                        child: QuickActionCard(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}