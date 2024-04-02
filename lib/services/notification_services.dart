import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:simple_calendar/models/event.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyHelper{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initializeNotification() async {

    _configureLocalTimezone();

    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var iosInitialize = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }

  Future displayNotification({required String title, required String body}) async {

    AndroidNotificationDetails androidPlatformChanelSpecifics =
    const AndroidNotificationDetails(
        "channelId",
        "channelName",
        "channelDescription",

      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChanelSpecifics, iOS: const IOSNotificationDetails());

    await flutterLocalNotificationsPlugin.show(0, title, body, not, payload: 'Default_Sound');

  }

  Future scheduledNotification(int hour, int minutes, Event event) async {

    AndroidNotificationDetails androidPlatformChanelSpecifics =
    const AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription",

      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChanelSpecifics, iOS: const IOSNotificationDetails());

    await flutterLocalNotificationsPlugin.zonedSchedule(
      event.id!.toInt(),
      event.title,
      event.note,
      _convertTime(hour, minutes),
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      not,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'Default_Sound',
      matchDateTimeComponents: DateTimeComponents.time
    );

  }

  tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    
    return scheduleDate;

  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

}