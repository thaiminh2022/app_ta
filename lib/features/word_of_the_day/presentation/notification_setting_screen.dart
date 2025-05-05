import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_ta/features/word_of_the_day/services/notification_service.dart';
import 'package:app_ta/features/word_of_the_day/models/notification_config.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat.Hm().format(
      DateTime(0, 0, 0, _selectedTime.hour, _selectedTime.minute),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Time:',
              style: Theme.of(context).textTheme.titleMedium,
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save & Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
