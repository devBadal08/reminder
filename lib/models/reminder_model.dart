class ReminderModel {
  String id;
  String title;
  DateTime? reminderDateTime;
  Map<String, String> customFields;

  ReminderModel({
    required this.id,
    required this.title,
    this.reminderDateTime,
    required this.customFields,
  });
}
