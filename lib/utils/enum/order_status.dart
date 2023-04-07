enum OrderStatus {
  NONE,
  PENDING_PAYMENT,
  PENDING_APPROVE,
  APPROVED,
  REJECTED,
  DISBURSE,
  FAILED,
  CUSTOMER_CANCEL
}

extension OrderStatusExtension on OrderStatus {
  int get value {
    switch (this) {
      case OrderStatus.NONE:
        return 0;
      case OrderStatus.PENDING_PAYMENT:
        return 1;
      case OrderStatus.PENDING_APPROVE:
        return 2;
      case OrderStatus.APPROVED:
        return 3;
      case OrderStatus.REJECTED:
        return 4;
      case OrderStatus.DISBURSE:
        return 5;
      case OrderStatus.FAILED:
        return 6;
      case OrderStatus.CUSTOMER_CANCEL:
        return 7;
      default:
        throw Exception('Invalid status');
    }
  }

  String get name {
    switch (this) {
      case OrderStatus.NONE:
        return 'NONE';
      case OrderStatus.PENDING_PAYMENT:
        return 'PENDING_PAYMENT';
      case OrderStatus.PENDING_APPROVE:
        return 'PENDING_APPROVE';
      case OrderStatus.APPROVED:
        return 'APPROVED';
      case OrderStatus.REJECTED:
        return 'REJECTED';
      case OrderStatus.DISBURSE:
        return 'DISBURSE';
      case OrderStatus.FAILED:
        return 'FAILED';
      case OrderStatus.CUSTOMER_CANCEL:
        return 'CUSTOMER_CANCEL';
      default:
        throw Exception('Invalid status');
    }
  }
}
