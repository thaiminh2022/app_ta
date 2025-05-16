import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/dashboard/presentation/stats_card.dart';
import 'package:app_ta/features/dashboard/presentation/streak_card.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/gamespace_button.dart';
import 'package:app_ta/features/dashboard/presentation/ai_chat.dart';
import 'package:app_ta/features/dashboard/presentation/quick_action_card.dart';
import 'package:flutter/material.dart';

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

  void _showGamespaceDialog() {
    showDialog(context: context, builder: (ctx) => const GamespaceDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: PageHeader("DailyE Dashboard"),
        actions: [ProfileMenu()],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
