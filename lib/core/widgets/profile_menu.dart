import 'package:app_ta/features/dashboard/presentation/widgets/about_dialog.dart';
import 'package:app_ta/features/dashboard/presentation/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    void showSettingsDialog() {
      showDialog(context: context, builder: (ctx) => const SettingsDialog());
    }

    void showAboutDialog() {
      showDialog(context: context, builder: (ctx) => AboutDialogView());
    }

    void quitApp() {
      SystemNavigator.pop();
    }

    void showProfileMenu() {
      showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
        items: [
          PopupMenuItem(
            value: 'settings',
            height: 48, // Chiều cao cố định cho tất cả các mục
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24, // Giảm kích thước icon về 24 để đồng nhất
                ),
                const SizedBox(width: 12), // Tăng khoảng cách giữa icon và text
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16, // Đảm bảo font size đồng nhất
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'about',
            height: 48, // Chiều cao cố định
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24, // Kích thước đồng nhất
                ),
                const SizedBox(width: 12),
                Text(
                  'About',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'quit',
            height: 48, // Chiều cao cố định
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: const Color.fromRGBO(255, 66, 66, 1),
                  size: 24, // Kích thước đồng nhất
                ),
                const SizedBox(width: 12),
                Text(
                  'Quit',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
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
          showSettingsDialog();
        } else if (value == 'about') {
          showAboutDialog();
        } else if (value == 'quit') {
          quitApp();
        }
      });
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showProfileMenu();
          },
          child: CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage('assets/icon/icon.png'),
          ),
        ),
      ],
    );
  }
}
