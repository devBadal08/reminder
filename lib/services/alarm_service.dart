import 'package:alarm/alarm.dart';

class AlarmService {
  static Future<void> scheduleAlarm({
    required int id,
    required String title,
    required DateTime dateTime,
  }) async {
    final settings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: 'assets/audio/alarm1.mp3',
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      notificationSettings: NotificationSettings(
        title: title,
        body: 'Your reminder is ringing',
      ),
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: Duration(seconds: 3),
      ),
    );

    final result = await Alarm.set(alarmSettings: settings);

    print("Alarm Result: $result");
    print("Alarm Time: $dateTime");
  }
}
