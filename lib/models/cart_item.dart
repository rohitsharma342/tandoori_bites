import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  final List<String> selectedCustomizations;
  final String? specialInstructions;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.selectedCustomizations = const [],
    this.specialInstructions,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    List<String>? selectedCustomizations,
    String? specialInstructions,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      selectedCustomizations: selectedCustomizations ?? this.selectedCustomizations,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}