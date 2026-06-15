import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatelessWidget {
  final int alarmId;
  final String title;

  const AlarmScreen({super.key, required this.alarmId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.alarm, size: 120, color: Colors.white),

              const SizedBox(height: 20),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () async {
                  await Alarm.stop(alarmId);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("STOP ALARM"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
