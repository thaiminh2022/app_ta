import 'dart:io';

import 'package:app_ta/features/dashboard/presentation/widgets/about_dialog.dart';
import 'package:app_ta/features/dashboard/presentation/ai_chat.dart';
import 'package:app_ta/features/dashboard/presentation/quick_action_card.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/settings_dialog.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/random_button.dart';
import 'package:app_ta/features/dashboard/presentation/stats_card.dart';
import 'package:app_ta/features/dashboard/presentation/streak_card.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    // Tiền tải hình ảnh dashboard.png để giảm độ trễ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/home_screen/dashboard.png'), context);
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Khởi tạo và preload video ngay lập tức
    _videoController = VideoPlayerController.asset(
      'assets/home_screen/video_background.mp4',
    )..initialize().then((_) {
      setState(() {
        _isVideoInitialized = true; // Cập nhật khi video sẵn sàng
      });
      _videoController.play();
      _videoController.setLooping(true);
    }).catchError((error) {
      //print("Lỗi khởi tạo video: $error");
      setState(() {
        _isVideoInitialized = false;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Hiển thị dashboard.png làm placeholder với BoxFit.cover
          if (!_isVideoInitialized || (Platform.isWindows || Platform.isLinux))
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    1, 0, 0, 0, 0,    // R: Giữ nguyên đỏ
                    0, 1, 0, 0, 0,    // G: Giữ nguyên xanh lá
                    0, 0, 1, 0, 0,    // B: Giữ nguyên xanh dương
                    0, 0, 0, 1, 0,    // A: Giữ nguyên alpha
                    // Thêm điều chỉnh gamma nếu cần
                    // Ví dụ: 0, 0, 0, 0, -10 để giảm độ sáng
                  ]),
                  child: Image.asset(
                    'assets/home_screen/dashboard.png',
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
          // Hiển thị video với BoxFit.cover khi đã tải xong
          if (_isVideoInitialized && _videoController.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      1, 0, 0, 0, 0,    // R: Giữ nguyên đỏ
                      0, 1, 0, 0, 0,    // G: Giữ nguyên xanh lá
                      0, 0, 1, 0, 0,    // B: Giữ nguyên xanh dương
                      0, 0, 0, 1, 0,    // A: Giữ nguyên alpha
                    ]),
                    child: VideoPlayer(_videoController),
                  ),
                ),
              ),
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
                        ],
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
                              child: const Icon(
                                Icons.person,
                                color: Color.fromRGBO(128, 128, 128, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      alignment: WrapAlignment.start,
                      children: [
                        AIChat(),
                        const StatsCard(),
                        const StreakCard(),
                        FadeTransition(
                          opacity: _animation,
                          child: const QuickActionCard(),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [RandomButton(context: context)],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}