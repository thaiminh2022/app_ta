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
  bool _isNotificationEnabled = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _notificationService.loadConfig();
    if (config != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: config.hour, minute: config.minute);
        _isNotificationEnabled = config.isEnabled;
      });
    }
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
      if (_isNotificationEnabled) {
        await _saveNotification();
      }
      await _saveConfig();
    }
  }

  Future<void> _toggleNotification(bool value) async {
    setState(() {
      _isNotificationEnabled = value;
    });
    if (_isNotificationEnabled) {
      await _saveNotification();
    } else {
      await _notificationService.cancelNotification();
    }
    await _saveConfig();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isNotificationEnabled
                ? 'Notification scheduled at ${_selectedTime.format(context)}'
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
      isEnabled: _isNotificationEnabled,
    );
    await _notificationService.scheduleDailyNotification(config);
  }

  Future<void> _saveConfig() async {
    final config = NotificationConfig(
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      title: 'Word of the Day',
      body: 'Tap to see today\'s word!',
      isEnabled: _isNotificationEnabled,
    );
    await _notificationService.saveConfig(config);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable Notifications:',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              Switch(
                value: _isNotificationEnabled,
                onChanged: _toggleNotification,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Notification Time:',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 248, 255, 1),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timeText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _toggleNotification(!_isNotificationEnabled);
            },
            child: Text(_isNotificationEnabled ? 'Disable' : 'Enable'),
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