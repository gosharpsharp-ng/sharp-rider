import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gorider/core/services/auth/auth_service.dart';

/// Background message handler - must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  late final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final GetStorage _storage = GetStorage();
  final AuthenticationService _authService = AuthenticationService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Android notification channel for high importance notifications
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize Firebase and push notification services
  Future<void> initialize() async {
    try {
      print('🔔 ========== FCM INITIALIZATION STARTED ==========');

      // Initialize Firebase
      await Firebase.initializeApp();
      print('✅ Firebase initialized');

      // Initialize FirebaseMessaging after Firebase is initialized
      _firebaseMessaging = FirebaseMessaging.instance;
      print('✅ FirebaseMessaging instance created');

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      await _getFcmToken();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      await _checkInitialMessage();

      print('🔔 ========== FCM INITIALIZATION COMPLETED ==========');
    } catch (e) {
      print('❌ Error initializing push notifications: $e');
      debugPrint('Error initializing push notifications: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification permission status: ${settings.authorizationStatus}');

    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Get FCM token
  Future<void> _getFcmToken() async {
    try {
      print('📱 Attempting to get FCM token...');
      _fcmToken = await _firebaseMessaging.getToken();

      if (_fcmToken != null) {
        print('✅ FCM Token obtained (partial): ${_fcmToken!.substring(0, 20)}...${_fcmToken!.substring(_fcmToken!.length - 20)}');
        print('🔑 FULL FCM TOKEN: $_fcmToken');
        print('========================================');
        await _sendTokenToServer(_fcmToken!);
      } else {
        print('❌ FCM Token is null!');
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      debugPrint('Error getting FCM token: $e');
    }
  }

  /// Handle token refresh
  void _onTokenRefresh(String token) {
    _fcmToken = token;
    debugPrint('FCM Token refreshed: $token');
    _sendTokenToServer(token);
  }

  /// Send FCM token to your backend server
  Future<void> _sendTokenToServer(String token) async {
    try {
      print('📤 ========== SENDING TOKEN TO SERVER ==========');

      // Only send if user is authenticated
      final authToken = _storage.read('token');
      if (authToken == null) {
        print('⚠️ User not authenticated, skipping device token registration');
        print('Auth token is null - user must login first');
        return;
      }

      print('✅ User authenticated, proceeding with token registration');
      print('📤 Sending FCM token to backend: ${token.substring(0, 20)}...');

      final response = await _authService.registerDeviceToken(token);

      print('📥 Response received from backend:');
      print('   Status: ${response.status}');
      print('   Message: ${response.message}');

      if (response.status == 'success') {
        print('✅ ========== DEVICE TOKEN REGISTERED SUCCESSFULLY! ==========');
      } else {
        print('❌ ========== FAILED TO REGISTER DEVICE TOKEN ==========');
        print('   Full response: ${response.toJson()}');
      }
    } catch (e, stackTrace) {
      print('❌ ========== ERROR SENDING TOKEN ==========');
      print('   Error: $e');
      print('   Stack trace: $stackTrace');
    }
  }

  /// Call this method after user login to register the device token
  Future<void> registerTokenIfAvailable() async {
    try {
      print('🔔 ========== REGISTER TOKEN CALLED ==========');

      // If token is not available, try to get it
      if (_fcmToken == null) {
        print('⚠️ FCM token not available, attempting to get it...');
        _fcmToken = await _firebaseMessaging.getToken();

        if (_fcmToken != null) {
          print('✅ FCM Token obtained: ${_fcmToken!.substring(0, 20)}...${_fcmToken!.length > 40 ? _fcmToken!.substring(_fcmToken!.length - 20) : ''}');
        } else {
          print('❌ Unable to obtain FCM token - token is null');
        }
      } else {
        print('✅ FCM token already available: ${_fcmToken!.substring(0, 20)}...');
      }

      if (_fcmToken != null) {
        print('📤 Registering FCM token with backend...');
        await _sendTokenToServer(_fcmToken!);
      } else {
        print('❌ ERROR: Unable to obtain FCM token');
      }

      print('🔔 ========== REGISTER TOKEN COMPLETED ==========');
    } catch (e) {
      print('❌ Error in registerTokenIfAvailable: $e');
      debugPrint('Error in registerTokenIfAvailable: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');

    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    // Show local notification when app is in foreground
    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Handle notification tap when app is in background
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    _navigateBasedOnData(message.data);
  }

  /// Handle notification response from local notifications
  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        _navigateBasedOnData(data);
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  /// Check if app was opened from a terminated state via notification
  Future<void> _checkInitialMessage() async {
    final RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App opened from terminated state via notification');
      _navigateBasedOnData(initialMessage.data);
    }
  }

  /// Navigate based on notification data
  void _navigateBasedOnData(Map<String, dynamic> data) {
    print('📱 Navigation triggered from notification');
    print('📦 Data: $data');

    try {
      final String? type = data['type']?.toString().toLowerCase();
      final String? screen = data['screen']?.toString();

      // Give app time to initialize if just opened
      Future.delayed(const Duration(milliseconds: 500), () {
        switch (type) {
          // New delivery/order notification
          case 'new_delivery':
          case 'new_order':
          case 'order':
            final String? trackingId = data['tracking_id'] ?? data['trackingId'];
            final String? deliveryId = data['delivery_id'] ?? data['deliveryId'];

            print('🚴 Navigating to delivery details: $trackingId');

            if (trackingId != null || deliveryId != null) {
              // Navigate to delivery details
              Get.toNamed('/delivery-details', arguments: {
                'trackingId': trackingId,
                'deliveryId': deliveryId,
              });
            } else {
              // Go to deliveries list
              Get.toNamed('/app-navigation', arguments: {'initialIndex': 1});
            }
            break;

          // Delivery update (status change, location, etc.)
          case 'delivery_update':
          case 'delivery_status':
            final String? trackingId = data['tracking_id'] ?? data['trackingId'];

            print('📦 Navigating to delivery tracking: $trackingId');

            if (trackingId != null) {
              Get.toNamed('/delivery-tracking', arguments: {
                'trackingId': trackingId,
              });
            }
            break;

          // Message/notification
          case 'message':
          case 'notification':
            print('💬 Navigating to notifications');
            Get.toNamed('/notifications');
            break;

          // Wallet/payment notification
          case 'payment':
          case 'wallet':
            print('💰 Navigating to wallet');
            Get.toNamed('/wallet');
            break;

          // Custom screen routing
          default:
            if (screen != null) {
              print('🎯 Navigating to custom screen: $screen');
              Get.toNamed('/$screen', arguments: data);
            } else {
              print('🏠 Navigating to home');
              Get.toNamed('/app-navigation');
            }
        }
      });
    } catch (e) {
      print('❌ Navigation error: $e');
      // Fallback to home
      Get.toNamed('/app-navigation');
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  /// Delete FCM token (useful for logout)
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    _fcmToken = null;
    debugPrint('FCM token deleted');
  }
}
