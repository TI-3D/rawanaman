import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rawanaman/main.dart';
import 'package:rawanaman/pages/myplants_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();

    await _setupMessageHandlers();
    final token = await _messaging.getToken();
    print('FCM token: $token');

    if (token != null) {
      await _saveTokenToFirestore(token);
    }

    await subscribeToTopic('plant');
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    const channel = AndroidNotificationChannel(
      'high_importace_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const InitializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/rawanaman_logo');

    final initializationSettings =
        InitializationSettings(android: InitializationSettingsAndroid);
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == 'plant') {
          navigatorKey.currentState
              ?.push(MaterialPageRoute(builder: (context) => MyPlantsPage()));
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
          'High_Importance_channel',
          'High Importace Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/rawananam_logo',
        )),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'plant') {
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (context) => MyPlantsPage()));
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print("Subscribed to $topic");
  }
}
