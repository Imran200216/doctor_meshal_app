import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

class FCMService {
  static String? globalFcmToken;

  /// Initialize Firebase Cloud Messaging
  static Future<void> initialize() async {
    final messaging = FirebaseMessaging.instance;

    // Permissions (iOS)
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      announcement: true,
    );

    if (Platform.isIOS) {
      await _waitForAPNSToken(messaging);
    }

    // Get FCM Token
    globalFcmToken = await messaging.getToken();
    AppLoggerHelper.logInfo("🔥 FCM Token: $globalFcmToken");

    // Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      globalFcmToken = token;
      AppLoggerHelper.logInfo("♻️ FCM Token refreshed: $token");
    });
  }

  /// Wait for APNS token for iOS
  static Future<void> _waitForAPNSToken(FirebaseMessaging messaging) async {
    String? apnsToken;
    int retries = 0;

    while (apnsToken == null && retries < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      apnsToken = await messaging.getAPNSToken();
      retries++;
    }

    AppLoggerHelper.logInfo("🍎 APNS Token: $apnsToken");
  }
}
