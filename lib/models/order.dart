import 'package:json_annotation/json_annotation.dart';
import 'restaurant.dart';
import 'order_status.dart';

part 'order.g.dart';

// Move OrderPizza to the TOP of the file, BEFORE Order class
@JsonSerializable()
class OrderPizza {
  final int pizzaId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  // Remove Pizza? pizza for now - causing import conflicts

  OrderPizza({
    required this.pizzaId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderPizza.fromJson(Map<String, dynamic> json) =>
      _$OrderPizzaFromJson(json);
  Map<String, dynamic> toJson() => _$OrderPizzaToJson(this);

  String get formattedUnitPrice => '€${unitPrice.toStringAsFixed(2)}';
  String get formattedTotalPrice => '€${totalPrice.toStringAsFixed(2)}';
}

@JsonSerializable()
class Order {
  final int id;
  final String status;
  final int restaurantId;
  final String customerName;
  final String customerEmail;
  final String? customerPhone;
  final String deliveryAddress;
  final String? notes;
  final String? deliveryPhotoPath;
  final List<OrderPizza> pizzas;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Restaurant? restaurant; // Optional relation

  Order({
    required this.id,
    required this.status,
    required this.restaurantId,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone,
    required this.deliveryAddress,
    this.notes,
    this.deliveryPhotoPath,
    required this.pizzas,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    this.updatedAt,
    this.restaurant,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  // Order status helpers
  OrderStatus get orderStatus => OrderStatusExtension.fromString(status);

  bool get isPending => status == 'pending';
  bool get isPreparing => status == 'preparing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';

  bool get canAdvanceStatus => orderStatus.canAdvanceStatus;
  bool get canCancelOrder => isPending || isPreparing;

  OrderStatus? get nextStatus => orderStatus.nextStatus;

  String get formattedSubtotal => '€${subtotal.toStringAsFixed(2)}';
  String get formattedDeliveryFee => '€${deliveryFee.toStringAsFixed(2)}';
  String get formattedTotal => '€${total.toStringAsFixed(2)}';

  String get statusDisplayName => orderStatus.displayName;
  String get statusDescription => orderStatus.description;

  // Time helpers
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  int get totalPizzaCount =>
      pizzas.fold(0, (sum, orderPizza) => sum + orderPizza.quantity);
}
