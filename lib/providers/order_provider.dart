import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => List.unmodifiable(_orders);
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Order> get recentOrders {
    final sortedOrders = List<Order>.from(_orders);
    sortedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedOrders.take(5).toList();
  }

  Future<Order?> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String paymentMethod,
    String? specialInstructions,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    try {
      final order = Order(
        id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
        items: items,
        totalAmount: totalAmount,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        estimatedDelivery: DateTime.now().add(const Duration(minutes: 45)),
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        specialInstructions: specialInstructions,
      );

      _orders.add(order);
      _currentOrder = order;
      _isLoading = false;
      notifyListeners();

      _simulateOrderProgress(order.id);

      return order;
    } catch (e) {
      _error = 'Failed to place order. Please try again.';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void _simulateOrderProgress(String orderId) async {
    final statuses = [
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    for (var status in statuses) {
      await Future.delayed(const Duration(seconds: 10));
      updateOrderStatus(orderId, status);
    }
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: status);
      if (_currentOrder?.id == orderId) {
        _currentOrder = _orders[index];
      }
      notifyListeners();
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}