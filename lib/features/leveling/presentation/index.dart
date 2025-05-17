import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/core/widgets/page_header.dart';
import 'package:app_ta/core/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelingView extends StatelessWidget {
  const LevelingView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    String? selectedLevel = appState.level.toString().split('.').last.toUpperCase();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: PageHeader("Level"),
        actions: [ProfileMenu()],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Level Card with Gradient Border
                  Container(
                    padding: const EdgeInsets.all(4), // Padding to create border thickness
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
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Level: ${appState.level.toString().split('.').last.toUpperCase()}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Level Selection Card with Gradient Border
                  Container(
                    padding: const EdgeInsets.all(4), // Padding to create border thickness
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
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Select Level:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: selectedLevel,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: "A1", child: Text("A1")),
                                  DropdownMenuItem(value: "A2", child: Text("A2")),
                                  DropdownMenuItem(value: "B1", child: Text("B1")),
                                  DropdownMenuItem(value: "B2", child: Text("B2")),
                                  DropdownMenuItem(value: "C1", child: Text("C1")),
                                  DropdownMenuItem(value: "C2", child: Text("C2")),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLevel = newValue;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          if (selectedLevel != null) {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            appState.setLevel(selectedLevel!.toLowerCase());
                            await appState.saveLevelData();
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text("Applied successfully!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Text("Apply"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}