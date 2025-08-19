import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/pizza.dart';
import '../constants/api_constants.dart';

class CartProvider with ChangeNotifier {
  //private list of cart items
  final List<CartItem> _items = [];

  //getters
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  //add pizza to cart or inc quantity
  void addPizza(Pizza pizza, {int quantity = 1}) {
    final existingIndex =
        _items.indexWhere((item) => item.pizza.id == pizza.id);
    if (existingIndex >= 0) {
      // increase quantity
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(pizza: pizza, quantity: quantity));
    }
    notifyListeners();
  }

  void removePizza(int pizzaId) {
    _items.removeWhere((item) => item.pizza.id == pizzaId);
    notifyListeners();
  }

  void updateQuantity(int pizzaId, int quantity) {
    if (quantity <= 0) {
      removePizza(pizzaId);
      return;
    }
    final index = _items.indexWhere((item) => item.pizza.id == pizzaId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(int pizzaId) {
    final index = _items.indexWhere((item) => item.pizza.id == pizzaId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int pizzaId) {
    final index = _items.indexWhere((item) => item.pizza.id == pizzaId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index); // Remove if quantity becomes 0
      }
      notifyListeners();
    }
  }

  //quantity of a specific pizza
  int getQuantity(int pizzaId) {
    final item = _items.firstWhere(
      (item) => item.pizza.id == pizzaId,
      orElse: () => CartItem(
        pizza: Pizza(
            id: -1,
            name: '',
            description: '',
            price: 0,
            restaurant: 0,
            allergens: []),
        quantity: 0,
      ),
    );
    return item.pizza.id == -1 ? 0 : item.quantity;
  }

  //check if pizza in cart
  bool containsPizza(int pizzaId) {
    return _items.any((item) => item.pizza.id == pizzaId);
  }

  //clear entire cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  String get cartSummary {
    if (isEmpty) return 'Cart is empty';
    return '$itemCount items (${totalQuantity} pizzas) - €${totalPrice.toStringAsFixed(2)}';
  }

  String get formattedTotalPrice {
    return '€${totalPrice.toStringAsFixed(2)}';
  }

  // Calculate cart total with detailed breakdown
  Map<String, dynamic> get cartBreakdown {
    return {
      'subtotal': totalPrice,
      'delivery_fee': ApiConstants.deliveryFee,
      'total': totalPrice + ApiConstants.deliveryFee,
      'items_count': itemCount,
      'pizzas_count': totalQuantity,
    };
  }

  double get totalWithDelivery {
    return totalPrice + ApiConstants.deliveryFee;
  }

  /// Get formatted total with delivery
  String get formattedTotalWithDelivery {
    return '€${totalWithDelivery.toStringAsFixed(2)}';
  }

  CartItem? getCartItem(int pizzaId) {
    try {
      return _items.firstWhere((item) => item.pizza.id == pizzaId);
    } catch (e) {
      return null;
    }
  }
}
