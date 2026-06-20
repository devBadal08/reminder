class ReminderModel {
  String id;
  String title;
  DateTime? reminderDateTime;

  Map<String, String>? customFields;
  List<List<String>>? tableData;

  String? attachmentPath; // NEW

  ReminderModel({
    required this.id,
    required this.title,
    this.reminderDateTime,
    this.customFields,
    this.tableData,
    this.attachmentPath, // NEW
  });
}
