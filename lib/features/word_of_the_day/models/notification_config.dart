class NotificationConfig {
  final int hour;
  final int minute;
  final String title;
  final String body;

  NotificationConfig({
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'title': title,
        'body': body,
      };

  factory NotificationConfig.fromJson(Map<String, dynamic> json) {
    return NotificationConfig(
      hour: json['hour'],
      minute: json['minute'],
      title: json['title'],
      body: json['body'],
    );
  }
}
