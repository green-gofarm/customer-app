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
}
