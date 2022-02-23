import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:stagemuse/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:stagemuse/main.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/view/export_view.dart';

// Object
final NotificationMessagingServices notificationMessagingServices =
    NotificationMessagingServices();

class NotificationMessagingServices {
  // Singleton
  static final _instance = NotificationMessagingServices._constructor();
  NotificationMessagingServices._constructor();

  factory NotificationMessagingServices() {
    return _instance;
  }

  // Process
  // Setter
  final _authorization =
      "key=AAAAkJqfweY:APA91bE5oWGtmtq-abT7MJ148qnSr9L-g66HuPrVa83S7vjEia8X-uW_8sJwrvWyp9NUJviDRzxZR-a9UtkvuETUJJc8puW3OMhUFCXTBjx0Qprhw1YNcGvWIL0bEmYnk5-3UTg3omK6";

  // Getter
  void subsribeTopic(String topic) {
    firebaseMessaging.subscribeToTopic(topic);
  }

  void unSubsribeTopic(String topic) {
    firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> setupMessageHandling({
    required BuildContext context,
    required String yourId,
  }) async {
    await onMessage(context: context, yourId: yourId);
  }

  Future<void> onMessage({
    required BuildContext context,
    required String yourId,
  }) async {
    FirebaseMessaging.onMessage.listen(
      (message) {
        // Define Message
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;
        if (notification != null && android != null) {
          // When notif on click
          notifSetting(
            context: context,
            notifPlugin: flutterLocalNotificationsPlugin,
            message: notification.body!,
            yourId: yourId,
          );
          // Notif structure
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                playSound: true,
                icon: "@mipmap/ic_launcher",
                styleInformation: const BigTextStyleInformation(""),
              ),
            ),
          );
        }
      },
    );
  }

  void notifSetting({
    required FlutterLocalNotificationsPlugin notifPlugin,
    required String yourId,
    required String message,
    required BuildContext context,
  }) {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const IOSInitializationSettings();
    final bottomBloc = context.read<BottomNavigationBloc>();

    notifPlugin.initialize(
      InitializationSettings(android: android, iOS: ios),
      onSelectNotification: (_) async {
        if (message.contains("follow") ||
            message.contains("like") ||
            message.contains("live")) {
          // Notif Page
          bottomBloc.add(const SetBottomNavigation(2));
        } else {
          // Chat
          navigatorKey.currentState!.push(
            navigatorTo(
              context: context,
              screen: ChatListPage(yourId: yourId),
            ),
          );
        }
      },
    );
  }

  // Send message
  Future<bool> sendNotification({
    required String title,
    required String subject,
    required String topics,
  }) async {
    var postUrl = 'https://fcm.googleapis.com/fcm/send';

    String toParams = "/topics/$topics";

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": 'default',
        "screen": topics,
      },
      "to": toParams,
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': _authorization
    };

    final response = await http.post(Uri.tryParse(postUrl)!,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do
      debugPrint("Success send notif to $topics");
      return true;
    } else {
      // on failure do
      debugPrint("Failed send notif to $topics");
      return false;
    }
  }
}
