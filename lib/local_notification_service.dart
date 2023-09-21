import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  Future<void> setup() async {
    const iosInitializationSetting = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(onDidReceiveLocalNotification: null));
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    tz.initializeTimeZones();
    showLocalNotification();
  }

  void showLocalNotification() async {
    const androidNotificationDetail = AndroidNotificationDetails(
        '0', // channel Id
        'general' // channel Name
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    var androidWeeklyId = 0;
    var iosWeeklyId = 1;
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      androidWeeklyId,
      '오늘의 쿠키가 구워졌어요',
      '오늘의 운세를 확인해보세요!',
      _nextInstanceOfTime(10, 00),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    Duration offsetTime = DateTime.now().timeZoneOffset;
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).subtract(offsetTime);
    return scheduledDate;
  }
}
