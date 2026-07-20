import 'dart:convert';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:reminder/screens/alarm_screen.dart';
import 'package:reminder/screens/name_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder/screens/splash_screen.dart';
import 'package:reminder/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  print("APP PATH: ${dir.path}");

  await NotificationService.init();
  await Alarm.init();

  runApp(const ReminderApp());
}

class ReminderApp extends StatefulWidget {
  const ReminderApp({super.key});

  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

Future<Map?> getReminder(int id) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.get(
    Uri.parse('http://192.168.1.2:8000/api/reminders/alarm/$id'),
    headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  );

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

class _ReminderAppState extends State<ReminderApp> {
  @override
  void initState() {
    super.initState();

    Alarm.ringStream.stream.listen((alarmSettings) async {
      print("ALARM FIRED!");
      print(alarmSettings.id);
      final reminderData = await getReminder(alarmSettings.id);

      print(reminderData);
      print(reminderData?["attachment_path"].runtimeType);

      List<dynamic>? attachments;
      dynamic rawAttachment = reminderData?["attachment_path"];

      if (rawAttachment is String) {
        attachments = List<String>.from(jsonDecode(rawAttachment));
      } else if (rawAttachment is List) {
        attachments = rawAttachment;
      }

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => AlarmScreen(
            alarmId: alarmSettings.id,
            title: reminderData?["title"] ?? "Reminder",
            tableData: reminderData?["table_data"],
            attachmentPaths: attachments,
          ),
        ),
      );
    });
  }

  //  "this is the comment section"
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Reminder',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
