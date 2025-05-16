class NotificationConfig {
  final int hour;
  final int minute;
  final String title;
  final String body;
  final bool isEnabled;

  NotificationConfig({
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    this.isEnabled = true, // Mặc định là bật
  });

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'minute': minute,
    'title': title,
    'body': body,
    'isEnabled': isEnabled,
  };

  factory NotificationConfig.fromJson(Map<String, dynamic> json) {
    return NotificationConfig(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isEnabled: json['isEnabled'] as bool? ?? true, // Mặc định true nếu không có
    );
  }
}