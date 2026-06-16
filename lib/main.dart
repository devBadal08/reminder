import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder/screens/alarm_screen.dart';
import 'package:reminder/screens/name_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  final dir = await getApplicationDocumentsDirectory();
  print("APP PATH: ${dir.path}");
  // Open Box
  await Hive.openBox('reminders');

  await NotificationService.init();
  await Alarm.init();
  runApp(const ReminderApp());
}

class ReminderApp extends StatefulWidget {
  const ReminderApp({super.key});

  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  @override
  void initState() {
    super.initState();

    Alarm.ringStream.stream.listen((alarmSettings) {
      final box = Hive.box('reminders');

      Map? reminderData;

      for (int i = 0; i < box.length; i++) {
        final item = box.getAt(i);

        if (item["alarmId"] == alarmSettings.id) {
          reminderData = item;
          break;
        }
      }

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => AlarmScreen(
            alarmId: alarmSettings.id,
            title: reminderData?["title"] ?? "Reminder",
            tableData: reminderData?["tableData"],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Reminder',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const NameScreen(),
    );
  }
}
