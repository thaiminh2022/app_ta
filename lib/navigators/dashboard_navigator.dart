import 'package:app_ta/features/dashboard/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:flutter/material.dart';

class DashboardNavigator extends StatefulWidget {
  const DashboardNavigator({super.key});

  @override
  State<DashboardNavigator> createState() => _DashboardNavigatorState();
}

class _DashboardNavigatorState extends State<DashboardNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) {
            if (settings.name == Hangman.routeName) {
              return Hangman();
            }
            return Dashboard();
          },
        );
      },
    );
  }
}
