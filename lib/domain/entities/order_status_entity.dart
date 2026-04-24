enum OrderStatus { placed, preparing, delivering, completed }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Đã đặt';
      case OrderStatus.preparing:
        return 'Đang chuẩn bị';
      case OrderStatus.delivering:
        return 'Đang giao';
      case OrderStatus.completed:
        return 'Thành công';
    }
  }

  String get value => toString().split('.').last;

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'placed':
        return OrderStatus.placed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'delivering':
        return OrderStatus.delivering;
      case 'completed':
        return OrderStatus.completed;
      default:
        return OrderStatus.placed;
    }
  }
}
