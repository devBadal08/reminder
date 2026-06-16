class ReminderModel {
  String id;
  String title;
  DateTime? reminderDateTime;

  Map<String, String>? customFields;
  List<List<String>>? tableData;

  ReminderModel({
    required this.id,
    required this.title,
    this.reminderDateTime,
    this.customFields,
    this.tableData,
  });
}
