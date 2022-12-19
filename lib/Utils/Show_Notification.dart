import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

shownotification(title, description) {
  flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              playSound: true,
              icon: '@mipmap/ic_launcher')));
}
