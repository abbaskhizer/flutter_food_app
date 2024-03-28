import 'dart:convert';

//import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, announcement: true, carPlay: true, criticalAlert: true, provisional: true, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
     // print('User granted Permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //  print('User granted provisional Premission');
    } else {
   //   print('user declined ');
    }
  }

  initInfo() {
    var andriodInitializ = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSetting = InitializationSettings(android: andriodInitializ);
    flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (details) {
        try {} catch (e) {throw Exception(e.toString());}
        return;
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // print('.......onMessage........');
      // print('onMessage:${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation =
          BigTextStyleInformation(message.notification!.body.toString(), htmlFormatBigText: true, contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true);
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('foodie', 'fooodie', importance: Importance.max, styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: false);
      NotificationDetails platformChannelSpecific = NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecific, payload: message.data['body']);
    });
  }

  void getToken() async {
    // ignore: unused_local_variable
    String? mtoken = '';
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token;
     // print('My Token is :$mtoken');
      savedToken(token!);
      
    });
  }

  void savedToken(String token) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var userId = (sharedPreferences.getString('uuId'))!;

    await FirebaseFirestore.instance.collection('UserTokens').doc(userId).set({
      'token': token,
    });
  }

  void triggerNotification(
      {required String token,
      required String body,
      // required InstallmentNotificationModel notimodel,

      required String title}) async {
    try {
      await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'content-type': 'application/json',
            'Authorization': 'key=AAAAHX7-yeU:APA91bFvIjOlQ-gx-eYkgDOynul4Df9fzae1hSqqDZE6rBpMMiqLzf9EDHsI93EXZtoyeOCoX3RG9E3ZNxET4AS6H3ixOLdUhoCYQO2rommZHz9tvSNuCZ0Nu_208IYPNSiie1IR-Apg'
          },
          body: jsonEncode(
            <String, dynamic>{
              "priority": "high",
              "data": <String, dynamic>{
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "status": "done",
                "body": body,
                "title": title,
              },
              "notification": <String, dynamic>{"title": title, "body": body, "android_chennel_id": "foodie"},
              "to": token,
            },
          ));
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }
}
