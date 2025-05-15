import 'package:app_ta/core/providers/app_state.dart';
import 'package:app_ta/features/word_of_the_day/models/notification_config.dart';
import 'package:app_ta/features/word_of_the_day/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 00, minute: 00); // Mặc định là 00:00
  final NotificationService _notificationService = NotificationService();
  bool _isNotificationEnabled = true; // Trạng thái bật/tắt thông báo

  @override
  void initState() {
    super.initState();
    _loadSavedTime();
    _checkNotificationStatus();
  }

  Future<void> _loadSavedTime() async {
    final config = await _notificationService.loadConfig();
    if (config != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: config.hour, minute: config.minute);
      });
    }
  }

  Future<void> _checkNotificationStatus() async {
    final config = await _notificationService.loadConfig();
    setState(() {
      _isNotificationEnabled = config != null;
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
      // Nếu thông báo đang bật, lưu lại thời gian mới và hiển thị thông báo
      if (_isNotificationEnabled) {
        await _saveNotification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification changed to ${_selectedTime.format(context)}'),
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleNotification() async {
    if (_isNotificationEnabled) {
      // Tắt thông báo
      await _notificationService.flutterLocalNotificationsPlugin.cancel(0);
      setState(() {
        _isNotificationEnabled = false;
      });
    } else {
      // Bật thông báo với thời gian hiện tại
      await _saveNotification();
      setState(() {
        _isNotificationEnabled = true;
      });
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNotificationEnabled
                ? 'Notification enabled at ${_selectedTime.format(context)}'
                : 'Notification disabled',
          ),
        ),
      );
    }
  }

  Future<void> _saveNotification() async {
    final config = NotificationConfig(
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      title: 'Word of the Day',
      body: 'Tap to see today\'s word!',
    );
    await _notificationService.scheduleDailyNotification(config);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final timeText = DateFormat.Hm().format(
      DateTime(0, 0, 0, _selectedTime.hour, _selectedTime.minute),
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).cardColor,
      title: Row(
        children: [
          Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Theme:"),
              Switch(
                thumbIcon: WidgetStatePropertyAll(
                  Icon(
                    appState.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                    size: 20,
                  ),
                ),
                value: !appState.isDarkTheme,
                onChanged: (value) async {
                  if (appState.isDarkTheme == value) {
                    await appState.toggleTheme();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Notification Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Notification:"),
              Switch(
                thumbIcon: WidgetStatePropertyAll(
                  Icon(
                    _isNotificationEnabled ? Icons.notifications : Icons.notifications_off,
                    size: 20,
                  ),
                ),
                value: _isNotificationEnabled,
                onChanged: (value) => _toggleNotification(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Time Box
          GestureDetector(
            onTap: _pickTime, // Chỉ mở time picker khi nhấn vào box
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 248, 255, 1),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timeText,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}