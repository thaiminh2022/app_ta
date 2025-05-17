import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:app_ta/features/dashboard/presentation/stats_card.dart';
import 'package:app_ta/features/dashboard/presentation/streak_card.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/gamespace_button.dart';
import 'package:app_ta/features/dashboard/presentation/ai_chat.dart';
import 'package:app_ta/features/dashboard/presentation/quick_action_card.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/level_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/leveling/presentation/cefr_test.dart';

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
        actions: [CheckLevelButton(), ProfileMenu()],
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
                // CEFR level up notification bar
                _CefrLevelUpBar(),
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

class _CefrLevelUpBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final exp = appState.exp;
    final milestones = AppState.cefrExpMilestones;
    final levels = AppState.cefrLevels;
    // Tìm cấp độ CEFR mới nhất đã unlock nhưng chưa lên cấp
    int unlockedIdx = -1;
    for (int i = 0; i < milestones.length; i++) {
      if (exp >= milestones[i] && appState.isCefrTestUnlocked(levels[i])) {
        unlockedIdx = i;
      }
    }
    if (unlockedIdx == -1) return SizedBox.shrink();
    final level = levels[unlockedIdx];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Bạn đã đủ kinh nghiệm để thi lên cấp ${level.name.toUpperCase()}!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => CefrTest(level: level)));
            },
            child: const Text('Thi lên cấp'),
          ),
        ],
      ),
    );
  }
}
