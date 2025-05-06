import 'package:flutter/material.dart';
import 'package:app_ta/main.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _gradientStartColor;
  late Animation<Color?> _gradientEndColor;

  @override
  void initState() {
    super.initState();
    // Tiền tải hình ảnh home_screen.png
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/home_screen/home_screen.png'), context);
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Thời gian fade
      vsync: this,
    );

    // Hiệu ứng fade
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    // Hiệu ứng gradient nền
    _gradientStartColor = ColorTween(
      begin: Colors.transparent,
      end: Color.fromRGBO(173, 216, 230, 0.8), // LightBlue với opacity 0.8
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _gradientEndColor = ColorTween(
      begin: Colors.transparent,
      end: Color.fromRGBO(0, 0, 255, 0.6), // Blue với opacity 0.6
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const BottomNavbar(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutQuint,
                    ),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 1000),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _gradientStartColor.value ?? Colors.transparent,
                  _gradientEndColor.value ?? Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/home_screen/home_screen.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Error loading image',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}