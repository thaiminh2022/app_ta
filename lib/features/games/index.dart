import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:flutter/material.dart';

class GameSpace extends StatelessWidget {
  const GameSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: PageHeader("GameSpace"), actions: [ProfileMenu()]),
      body: SafeArea(child: Placeholder()),
    );
  }
}
