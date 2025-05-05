import 'package:app_ta/features/dashboard/presentation/quick_action_card.dart';
import 'package:app_ta/features/dashboard/presentation/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Show Settings Dialog
  void _showSettingsDialog() {
    final appState = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor:
                Theme.of(dialogContext).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(dialogContext).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  onPressed: () {
                    appState.toggleTheme();
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    appState.isDarkTheme
                        ? 'Switch to Light Theme'
                        : 'Switch to Dark Theme',
                    style: TextStyle(
                      color: Theme.of(dialogContext).colorScheme.onPrimary,
                    ),
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

  // Show About Dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor:
                Theme.of(dialogContext).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.white,
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

  // Quit the app
  void _quitApp() {
    SystemNavigator.pop();
  }

  // Show profile menu on avatar tap
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
              const Icon(Icons.exit_to_app, color: Colors.redAccent),
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
              ? Colors.grey[800]
              : Colors.white,
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_screen/dashboard.png'),
            fit: BoxFit.cover,
            opacity: 0.8,
            onError: (_, __) {},
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DailyE Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showProfileMenu,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/icon/icon.png'),
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Stats Card
                    FadeTransition(opacity: _animation, child: StatsCard()),
                    const SizedBox(height: 16),
                    // Quick Actions Card
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
      ),
    );
  }
}
