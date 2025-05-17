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
    String? selectedLevel = appState.level.toString().split('.').last; // Extract level name (e.g., "a1")

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: PageHeader("Level"),
        actions: [ProfileMenu()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Level: ${appState.level.toString().split('.').last}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "EXP: ${appState.exp.toString()}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                              DropdownMenuItem(value: "a1", child: Text("a1")),
                              DropdownMenuItem(value: "a2", child: Text("a2")),
                              DropdownMenuItem(value: "b1", child: Text("b1")),
                              DropdownMenuItem(value: "b2", child: Text("b2")),
                              DropdownMenuItem(value: "c1", child: Text("c1")),
                              DropdownMenuItem(value: "c2", child: Text("c2")),
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
                        appState.setLevel(selectedLevel!); // Use the new setLevel method
                        await appState.saveLevelData();
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
    );
  }
}