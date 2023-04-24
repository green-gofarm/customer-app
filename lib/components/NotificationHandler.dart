import 'dart:convert';

import 'package:customer_app/main.dart';
import 'package:customer_app/screens/BookingDetailScreen.dart';
import 'package:customer_app/utils/enum/notification_type.dart';
import 'package:customer_app/utils/enum/route_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tuple/tuple.dart';

class NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static int? getOrderIdFromRemoteMessage(RemoteMessage message) {
    String extrasString = message.data["Extras"];
    Map<String, dynamic> extras = jsonDecode(extrasString);

    if (extras["orderId"] != null) {
      return extras["orderId"];
    }
    return null;
  }

  static NotificationType getTypeFromRemoteMessage(RemoteMessage message) {
    String extrasString = message.data["Extras"];
    Map<String, dynamic> extras = jsonDecode(extrasString);

    return NotificationTypeExtension.fromValue(extras["type"]);
  }

  void showToastWithAction(
      String message, int? orderId, NotificationType type) {
    showOverlayNotification((context) {
      Tuple2<IconData, Color> iconAndColor =
          NotificationTypeExtension.getIconAndColor(type);

      return SafeArea(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          color: iconAndColor.item2.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(4),
              leading: Icon(
                iconAndColor.item1,
                color: Colors.white,
              ),
              title: Text(
                message,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  OverlaySupportEntry.of(context)?.dismiss();
                },
              ),
              onTap: () {
                OverlaySupportEntry.of(context)?.dismiss();
                if (orderId != null) {
                  navigateWithOrderId(orderId);
                }
              },
            ),
          ),
        ),
      );
    }, duration: Duration(seconds: 10), position: NotificationPosition.top);
  }

  static void navigateWithOrderId(int? orderId) {
    if (orderId != null) {
      navigatorKey.currentState?.pushReplacementNamed(
          RoutePaths.BOOKING_DETAIL.value,
          arguments: BookingDetailArguments(bookingId: orderId));
    }
  }

  Future<void> setupFirebaseMessaging() async {
    // Request notification permissions for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get the token for this device
    String? token = await _firebaseMessaging.getToken();
    if (authStore.isAuthenticated() && token != null) {
      authStore.updateNotificationToken(token);
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle message when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      int? orderId = getOrderIdFromRemoteMessage(message);
      NotificationType type = getTypeFromRemoteMessage(message);
      showToastWithAction(
          message.notification?.body ?? 'Có thông báo mới', orderId, type);
    });

    // Handle message when the app is in the foreground and the user clicks on it
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigateWithOrderId(getOrderIdFromRemoteMessage(message));
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    navigateWithOrderId(getOrderIdFromRemoteMessage(message));
  }
}
