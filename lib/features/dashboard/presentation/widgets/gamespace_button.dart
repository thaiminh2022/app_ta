import 'dart:math';

import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/games/wordle/presentation/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ta/core/providers/app_state.dart';

// Widget cho nút Gamespace với icon tùy chỉnh
class GamespaceButton extends StatefulWidget {
  final VoidCallback onPressed;

  const GamespaceButton({super.key, required this.onPressed});

  @override
  State<GamespaceButton> createState() => _GamespaceButtonState();
}

class _GamespaceButtonState extends State<GamespaceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ClipOval(
              child: Image.asset(
                'assets/icon/gamespace_icon.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red, size: 60);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Dialog hiển thị vòng tròn 4 phần cho các tab game
class GamespaceDialog extends StatefulWidget {
  const GamespaceDialog({super.key});

  @override
  State<GamespaceDialog> createState() => _GamespaceDialogState();
}

class _GamespaceDialogState extends State<GamespaceDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 20,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.white.withAlpha(50),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vẽ vòng tròn với 4 phần gradient
              CustomPaint(
                size: const Size(300, 300),
                painter: GamespaceCirclePainter(),
              ),
              // Các nút game
              _buildGameButton(context, 'Hangman', 0, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: Stack(
                        children: [
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.matrix([
                                  1, 0, 0, 0, 0, // R
                                  0, 1, 0, 0, 0, // G
                                  0, 0, 1, 0, 0, // B
                                  0, 0, 0, 1, 0, // A
                                ]),
                                child: Image.asset(
                                  context.watch<AppState>().isDarkTheme
                                      ? "assets/home_screen/dashboard_black.png"
                                      : "assets/home_screen/dashboard.png",
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ),
                          Hangman(),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              _buildGameButton(context, 'Wordle', 1, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: Stack(
                        children: [
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.matrix([
                                  1, 0, 0, 0, 0, // R
                                  0, 1, 0, 0, 0, // G
                                  0, 0, 1, 0, 0, // B
                                  0, 0, 0, 1, 0, // A
                                ]),
                                child: Image.asset(
                                  context.watch<AppState>().isDarkTheme
                                      ? "assets/home_screen/dashboard_black.png"
                                      : "assets/home_screen/dashboard.png",
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ),
                          const WordleGame(),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              _buildGameButton(context, 'Puzzle', 2, () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Puzzle coming soon!')),
                );
              }),
              _buildGameButton(context, 'Quiz', 3, () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz coming soon!')),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(
      BuildContext context,
      String label,
      int index,
      VoidCallback onTap,
      ) {
    const double radius = 100;
    final double angle = (index * 90) * pi / 180;
    final double x = radius * cos(angle);
    final double y = radius * sin(angle);

    return Positioned(
      left: 150 + x - 40,
      top: 150 + y - 40,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(0, 180, 90, 1),
                  Color.fromRGBO(0, 140, 70, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white.withAlpha(50),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CustomPainter để vẽ vòng tròn 4 phần với gradient
class GamespaceCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 120;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // 4 phần, mỗi phần 90 độ
    const double sweepAngle = 90 * pi / 180;
    final List<LinearGradient> gradients = [
      const LinearGradient(
        colors: [
          Color.fromRGBO(173, 216, 230, 1),
          Color.fromRGBO(135, 206, 235, 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [
          Color.fromRGBO(135, 206, 235, 0.8),
          Color.fromRGBO(100, 149, 237, 0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [
          Color.fromRGBO(100, 149, 237, 0.6),
          Color.fromRGBO(65, 105, 225, 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [
          Color.fromRGBO(65, 105, 225, 0.4),
          Color.fromRGBO(30, 144, 255, 0.2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    for (int i = 0; i < 4; i++) {
      final shader = gradients[i].createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
      final Paint paint =
      Paint()
        ..shader = shader
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweepAngle - pi / 2,
        sweepAngle,
        true,
        paint,
      );
    }

    // Thêm hiệu ứng ánh sáng ở giữa
    final glowPaint =
    Paint()
      ..color = Colors.white.withAlpha(50)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 50, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}