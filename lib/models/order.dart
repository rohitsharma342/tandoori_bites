import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final String deliveryAddress;
  final String paymentMethod;
  final String? specialInstructions;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.estimatedDelivery,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.specialInstructions,
  });

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? estimatedDelivery,
    String? deliveryAddress,
    String? paymentMethod,
    String? specialInstructions,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Pending';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Your Food';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}