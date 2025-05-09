import 'package:app_ta/features/dashboard/presentation/widgets/gamespace_button.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/about_dialog.dart';
import 'package:app_ta/features/dashboard/presentation/ai_chat.dart';
import 'package:app_ta/features/dashboard/presentation/quick_action_card.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/settings_dialog.dart';
import 'package:app_ta/features/dashboard/presentation/stats_card.dart';
import 'package:app_ta/features/dashboard/presentation/streak_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _showSettingsDialog() {
    showDialog(context: context, builder: (ctx) => SettingsDialog());
  }

  void _showAboutDialog() {
    showDialog(context: context, builder: (ctx) => AboutDialogView());
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
              const Icon(
                Icons.exit_to_app,
                color: Color.fromRGBO(255, 66, 66, 1),
              ),
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
      color: Theme.of(context).cardColor,
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

  void _showGamespaceDialog() {
    showDialog(context: context, builder: (ctx) => const GamespaceDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(173, 216, 230, 1),
                              Color.fromRGBO(135, 206, 235, 1),
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
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _showProfileMenu,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: const AssetImage(
                                'assets/icon/icon.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AIChat(),
                StatsCard(),
                StreakCard(),
                QuickActionCard(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GamespaceButton(onPressed: _showGamespaceDialog),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Không gian thở dưới cùng
              ],
            ),
          ],
        ),
      ),
    );
  }
}
