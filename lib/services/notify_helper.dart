// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:taskmate/model/personal_task.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tzz;
// class NotifyHelper {
//  late tz.Location _local;
//  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//  Future<void> initializeNotification() async {
//     await _configureLocalTimeZone();
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings("play_store_512");

//     var initializationSettingsIOS = IOSInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {});

//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {},
//     );
//  }

//  NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('channelId', 'channelName',
//             importance: Importance.max),
//         iOS: IOSNotificationDetails());
//  }

//  Future<void> showNotification(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     await flutterLocalNotificationsPlugin.show(
//         id, title, body, await notificationDetails());
//  }

//  Future<void> scheduleNotification(int hour, int minute, PTasksDB task) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'schedule title',
//       'created few seconds ago',
//       _convertTime(hour, minute),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'your channel id',
//           'your channel name',
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//  }

//  tz.TZDateTime _convertTime(int hour, int minutes) {
//     final tz.TZDateTime now = tz.TZDateTime.now(_local);
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(_local, now.year, now.month, now.day, hour, minutes);
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(days: 1));
//     }
//     return scheduleDate;
//  }

//  Future<void> _configureLocalTimeZone() async {
//     tzz.initializeTimeZones();
//     final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
//     _local = tz.getLocation(timeZone);
//     tz.setLocalLocation(_local);
//  }
// }