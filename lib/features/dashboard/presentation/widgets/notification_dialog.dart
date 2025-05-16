import 'package:app_ta/features/word_of_the_day/models/notification_config.dart';
import 'package:app_ta/features/word_of_the_day/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({super.key});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSavedTime();
  }

  Future<void> _loadSavedTime() async {
    final config = await _notificationService.loadConfig();
    if (config != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: config.hour, minute: config.minute);
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _saveSettings() async {
    await _notificationService.flutterLocalNotificationsPlugin.cancel(0); // Hủy thông báo cũ
    final config = NotificationConfig(
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      title: 'Word of the Day',
      body: 'Tap to see today\'s word!',
    );
    await _notificationService.scheduleDailyNotification(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification scheduled at ${_selectedTime.format(context)}',
          ),
        ),
      );
      Navigator.pop(context); // Đóng dialog sau khi lưu
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat.Hm().format(
      DateTime(0, 0, 0, _selectedTime.hour, _selectedTime.minute),
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).cardColor,
      title: Row(
        children: [
          Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Notification Settings',
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
          Text(
            'Notification Time:',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            timeText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickTime,
            child: const Text('Pick Time'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('Save & Schedule'),
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