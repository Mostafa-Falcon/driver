import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:driver/app/services/auth_service.dart';
import 'package:driver/core/constants/app_assets.dart';
import 'package:driver/core/constants/app_constants.dart';
import 'package:driver/core/utils/app_logger.dart';
import 'package:driver/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class NotificationAlarmService extends GetxService {
  static NotificationAlarmService get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _alarmPlayer = AudioPlayer();

  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  bool _isAlarmPlaying = false;

  static const AndroidNotificationChannel _newOrderChannel =
      AndroidNotificationChannel(
    'new_order_alarm',
    'طلبات جديدة',
    description: 'تنبيهات الطلبات الجديدة للسائق',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('new_order_alarm'),
    enableVibration: true,
  );

  @override
  void onInit() {
    super.onInit();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _initializeLocalNotifications().timeout(
        const Duration(seconds: 8),
      );
      await _initializeFcm().timeout(const Duration(seconds: 12));
    } catch (e) {
      AppLogger.error(
        'NotificationAlarmService initialization failed',
        error: e,
      );
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (_) => stopAlarm(),
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_newOrderChannel);
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> _initializeFcm() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: false,
    );

    final token = await _messaging.getToken();
    if (token != null && Get.isRegistered<AuthService>()) {
      unawaited(AuthService.to.updateFcmToken(token));
    }

    _messaging.onTokenRefresh.listen((token) {
      if (Get.isRegistered<AuthService>()) {
        unawaited(AuthService.to.updateFcmToken(token));
      }
    });

    _foregroundSub = FirebaseMessaging.onMessage.listen((message) {
      if (_isNewOrderMessage(message)) {
        unawaited(playNewOrderAlarm());
      }
      unawaited(_showLocalNotification(message));
    });

    _openedSub = FirebaseMessaging.onMessageOpenedApp.listen((_) {
      stopAlarm();
    });
  }

  Future<void> syncCurrentToken() async {
    try {
      final token = await _messaging.getToken().timeout(
            const Duration(seconds: 8),
          );
      if (token != null && Get.isRegistered<AuthService>()) {
        await AuthService.to.updateFcmToken(token);
      }
    } catch (e) {
      AppLogger.error('syncCurrentToken failed', error: e);
    }
  }

  Future<void> playNewOrderAlarm() async {
    if (_isAlarmPlaying) return;

    try {
      _isAlarmPlaying = true;
      await _alarmPlayer.setReleaseMode(ReleaseMode.loop);
      await _alarmPlayer.play(
        AssetSource(AppAssets.notificationBellAudioPlayer),
        volume: 1,
      );
    } catch (e) {
      _isAlarmPlaying = false;
      AppLogger.error('playNewOrderAlarm failed', error: e);
    }
  }

  Future<void> stopAlarm() async {
    if (!_isAlarmPlaying) return;

    _isAlarmPlaying = false;
    await _alarmPlayer.stop();
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? 'طلب جديد';
    final body = notification?.body ?? 'يوجد طلب جديد متاح لك';

    const androidDetails = AndroidNotificationDetails(
      'new_order_alarm',
      'طلبات جديدة',
      channelDescription: 'تنبيهات الطلبات الجديدة للسائق',
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('new_order_alarm'),
      enableVibration: true,
      fullScreenIntent: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails:
          const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: message.data['orderId']?.toString(),
    );
  }

  bool _isNewOrderMessage(RemoteMessage message) {
    final type = message.data['type'] ?? message.data['notificationType'];
    return type == AppConstants.notifNewOrder ||
        type == 'new_order' ||
        message.data.containsKey('orderId');
  }

  @override
  void onClose() {
    unawaited(_foregroundSub?.cancel());
    unawaited(_openedSub?.cancel());
    unawaited(_alarmPlayer.dispose());
    super.onClose();
  }
}
