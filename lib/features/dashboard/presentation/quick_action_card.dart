import 'package:app_ta/features/dashboard/presentation/widgets/menu_action_button.dart';
import 'package:app_ta/features/dictionary/presentation/index.dart';
import 'package:app_ta/features/games/hangman/presentation/index.dart';
import 'package:app_ta/features/games/wordle/presentation/index.dart';
import 'package:app_ta/features/word_of_the_day/presentation/index.dart';
import 'package:flutter/material.dart';

class QuickActionCard extends StatefulWidget {
  const QuickActionCard({super.key});

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  // List of available apps with their details
  final List<Map<String, dynamic>> availableApps = [
    {'label': 'Dictionary', 'icon': Icons.book, 'route': DictionarySearch()},
    {'label': 'Hangman', 'icon': Icons.gamepad, 'route': const Hangman()},
    {'label': 'Daily Word', 'icon': Icons.lightbulb_outline, 'route': WordOfTheDayScreen()},
    {'label': 'Wordle', 'icon': Icons.grid_on, 'route': const WordleView()},
  ];

  // List of currently selected apps (default to all 4 initially)
  List<Map<String, dynamic>> selectedApps = [];

  @override
  void initState() {
    super.initState();
    // Initialize with all apps selected by default
    selectedApps = List.from(availableApps);
  }

  // Show modal to customize apps
  void _showCustomizeModal(BuildContext context) {
    List<Map<String, dynamic>> tempSelectedApps = List.from(selectedApps);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Customize Quick Actions'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availableApps.map((app) {
                    return CheckboxListTile(
                      title: Text(app['label']),
                      value: tempSelectedApps.any((selected) => selected['label'] == app['label']),
                      onChanged: (bool? value) {
                        setModalState(() {
                          if (value == true) {
                            if (tempSelectedApps.length < 4) {
                              tempSelectedApps.add(app);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('You can only select up to 4 apps!')),
                              );
                            }
                          } else {
                            tempSelectedApps.removeWhere((selected) => selected['label'] == app['label']);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedApps = tempSelectedApps;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Container(
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
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, size: 24),
                    onPressed: () => _showCustomizeModal(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: selectedApps.map((app) {
                      return MenuActionButton(
                        icon: app['icon'],
                        label: app['label'],
                        route: app['route'],
                      );
                    }).toList(),
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