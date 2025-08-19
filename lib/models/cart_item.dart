import 'pizza.dart';

class CartItem {
  final Pizza pizza;
  int quantity;

  CartItem({
    required this.pizza,
    this.quantity = 1,
  });

  double get totalPrice => pizza.price * quantity;

  String get formattedTotalPrice => '€${totalPrice.toStringAsFixed(2)}';

  //conversion to json for local storage later

  Map<String, dynamic> toJson() => {
        'pizza': pizza.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        pizza: Pizza.fromJson(json['pizza']),
        quantity: json['quantity'] ?? 1,
      );

  //overriding equality to compare cart items by pizza ID
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          pizza.id == other.pizza.id;

  @override
  int get hashCode => pizza.id.hashCode;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      pizza: pizza,
      quantity: quantity ?? this.quantity,
    );
  }
}
