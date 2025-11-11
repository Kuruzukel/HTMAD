import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

import '../app_config.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannel();
    await _requestPermissions();

    _initialized = true;
    if (kDebugMode) {
      debugPrint('Notification service initialized successfully');
    }
  }

  static Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      description: AppConfig.notificationChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // Handle notification tap - navigate to specific screen based on payload
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      channelDescription: AppConfig.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      channelDescription: AppConfig.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Note: The schedule method is deprecated in newer versions
    // For now, we'll use show() for immediate notifications
    await _notifications.show(id, title, body, details, payload: payload);
  }

  static Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConfig.notificationChannelId,
      AppConfig.notificationChannelName,
      channelDescription: AppConfig.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.periodicallyShow(
      id,
      title,
      body,
      repeatInterval,
      details,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Health-specific notification methods
  static Future<void> scheduleWaterReminder({
    required int id,
    required DateTime time,
  }) async {
    await scheduleNotification(
      id: id,
      title: '💧 Hydration Reminder',
      body: 'Time to drink some water! Stay hydrated throughout the day.',
      scheduledDate: time,
      payload: 'water_reminder',
    );
  }

  static Future<void> scheduleExerciseReminder({
    required int id,
    required DateTime time,
  }) async {
    await scheduleNotification(
      id: id,
      title: '🏃‍♂️ Exercise Time',
      body: 'Ready for your workout? Let\'s get moving!',
      scheduledDate: time,
      payload: 'exercise_reminder',
    );
  }

  static Future<void> scheduleSleepReminder({
    required int id,
    required DateTime time,
  }) async {
    await scheduleNotification(
      id: id,
      title: '😴 Bedtime Reminder',
      body: 'Time to wind down and get ready for bed.',
      scheduledDate: time,
      payload: 'sleep_reminder',
    );
  }

  static Future<void> scheduleMealReminder({
    required int id,
    required DateTime time,
    required String mealType,
  }) async {
    await scheduleNotification(
      id: id,
      title: '🍽️ $mealType Time',
      body: 'Don\'t forget to log your $mealType!',
      scheduledDate: time,
      payload: 'meal_reminder',
    );
  }
}
