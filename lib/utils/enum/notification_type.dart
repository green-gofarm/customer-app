import 'package:customer_app/utils/RFColors.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

enum NotificationType {
  PAYMENT_SUCCESS_CUSTOMER,
  CANCEL_BOOKING_CUSTOMER,
  BOOKING_APPROVED_CUSTOMER,
  BOOKING_REJECTED_CUSTOMER,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.PAYMENT_SUCCESS_CUSTOMER:
        return 'notification.payment-success.customer';
      case NotificationType.CANCEL_BOOKING_CUSTOMER:
        return 'notification.cancel-booking.customer';
      case NotificationType.BOOKING_APPROVED_CUSTOMER:
        return 'notification.booking-approved.customer';
      case NotificationType.BOOKING_REJECTED_CUSTOMER:
        return 'notification.booking-rejected.customer';
      default:
        return '';
    }
  }

  static NotificationType fromValue(String value) {
    switch (value) {
      case 'notification.payment-success.customer':
        return NotificationType.PAYMENT_SUCCESS_CUSTOMER;
      case 'notification.cancel-booking.customer':
        return NotificationType.CANCEL_BOOKING_CUSTOMER;
      case 'notification.booking-approved.customer':
        return NotificationType.BOOKING_APPROVED_CUSTOMER;
      case 'notification.booking-rejected.customer':
        return NotificationType.BOOKING_REJECTED_CUSTOMER;
      default:
        return NotificationType.PAYMENT_SUCCESS_CUSTOMER;
    }
  }

  static Tuple2<IconData, Color> getIconAndColor(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.PAYMENT_SUCCESS_CUSTOMER:
        icon = Icons.payment;
        color = rf_primaryColor;
        break;
      case NotificationType.CANCEL_BOOKING_CUSTOMER:
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case NotificationType.BOOKING_APPROVED_CUSTOMER:
        icon = Icons.check_circle;
        color = rf_primaryColor;
        break;
      case NotificationType.BOOKING_REJECTED_CUSTOMER:
        icon = Icons.error;
        color = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return Tuple2(icon, color);
  }
}
