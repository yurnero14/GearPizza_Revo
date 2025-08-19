import '../models/order.dart';
import '../models/pizza.dart';
import '../models/allergen.dart';

class OrderService {
  // Mock orders for demonstration
  static List<Order> _mockOrders = [];

  // Initialize with some sample orders
  static void _initializeMockOrders() {
    if (_mockOrders.isNotEmpty) return;

    _mockOrders = [
      Order(
        id: 1,
        status: 'pending',
        restaurantId: 5, // CHANGED: Now matches your restaurant ID
        customerName: 'Marco Rossi',
        customerEmail: 'marco.rossi@email.com',
        customerPhone: '+39 123 456 7890',
        deliveryAddress: 'Via Roma 123, Milano, Italy',
        notes: 'Ring the doorbell twice',
        pizzas: [
          OrderPizza(
            pizzaId: 79, // The Volcano Vesuvio
            quantity: 2,
            unitPrice: 12.99,
            totalPrice: 25.98,
          ),
        ],
        subtotal: 25.98,
        deliveryFee: 2.50,
        total: 28.48,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Order(
        id: 2,
        status: 'preparing',
        restaurantId: 5,
        customerName: 'Sofia Bianchi',
        customerEmail: 'sofia.bianchi@email.com',
        deliveryAddress: 'Corso Buenos Aires 45, Milano, Italy',
        notes: 'Leave at the door',
        pizzas: [
          OrderPizza(
            pizzaId: 80, // The Moonlight Truffle
            quantity: 1,
            unitPrice: 18.99,
            totalPrice: 18.99,
          ),
          OrderPizza(
            pizzaId: 81, // The Garden of Crust
            quantity: 1,
            unitPrice: 14.99,
            totalPrice: 14.99,
          ),
        ],
        subtotal: 33.98,
        deliveryFee: 2.50,
        total: 36.48,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      Order(
        id: 3,
        status: 'shipped',
        restaurantId: 5,
        customerName: 'Giuseppe Verdi',
        customerEmail: 'giuseppe.verdi@email.com',
        customerPhone: '+39 987 654 3210',
        deliveryAddress: 'Via Brera 78, Milano, Italy',
        pizzas: [
          OrderPizza(
            pizzaId: 82, // The Pirate's Feast
            quantity: 2,
            unitPrice: 16.50,
            totalPrice: 33.00,
          ),
        ],
        subtotal: 33.00,
        deliveryFee: 2.50,
        total: 35.50,
        createdAt:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      ),
      Order(
        id: 4,
        status: 'delivered',
        restaurantId: 5,
        customerName: 'Francesca Moretti',
        customerEmail: 'francesca.moretti@email.com',
        deliveryAddress: 'Piazza Duomo 1, Milano, Italy',
        notes: 'Apartment 4B',
        pizzas: [
          OrderPizza(
            pizzaId: 83, // The Cheesus Crust
            quantity: 1,
            unitPrice: 15.75,
            totalPrice: 15.75,
          ),
        ],
        subtotal: 15.75,
        deliveryFee: 2.50,
        total: 18.25,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      // ADD MORE ORDERS FOR TESTING
      Order(
        id: 5,
        status: 'pending',
        restaurantId: 5,
        customerName: 'Alessandro Ferrari',
        customerEmail: 'alessandro.ferrari@email.com',
        customerPhone: '+39 345 678 9012',
        deliveryAddress: 'Via Montenapoleone 8, Milano, Italy',
        notes: 'Call when you arrive',
        pizzas: [
          OrderPizza(
            pizzaId: 79,
            quantity: 3,
            unitPrice: 12.99,
            totalPrice: 38.97,
          ),
          OrderPizza(
            pizzaId: 80,
            quantity: 1,
            unitPrice: 18.99,
            totalPrice: 18.99,
          ),
        ],
        subtotal: 57.96,
        deliveryFee: 2.50,
        total: 60.46,
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      Order(
        id: 6,
        status: 'preparing',
        restaurantId: 5,
        customerName: 'Giulia Romano',
        customerEmail: 'giulia.romano@email.com',
        deliveryAddress: 'Via Torino 15, Milano, Italy',
        pizzas: [
          OrderPizza(
            pizzaId: 81,
            quantity: 2,
            unitPrice: 14.99,
            totalPrice: 29.98,
          ),
        ],
        subtotal: 29.98,
        deliveryFee: 2.50,
        total: 32.48,
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
    ];
  }

  // Get all orders for a restaurant
  Future<List<Order>> getOrdersByRestaurant(int restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _initializeMockOrders();

    final orders = _mockOrders
        .where((order) => order.restaurantId == restaurantId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Most recent first

    return orders;
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(int restaurantId, String status) async {
    final orders = await getOrdersByRestaurant(restaurantId);
    return orders.where((order) => order.status == status).toList();
  }

  // Update order status
  Future<Order> updateOrderStatus(int orderId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _initializeMockOrders();

    final orderIndex = _mockOrders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) {
      throw Exception('Order not found');
    }

    final order = _mockOrders[orderIndex];
    final updatedOrder = Order(
      id: order.id,
      status: newStatus,
      restaurantId: order.restaurantId,
      customerName: order.customerName,
      customerEmail: order.customerEmail,
      customerPhone: order.customerPhone,
      deliveryAddress: order.deliveryAddress,
      notes: order.notes,
      deliveryPhotoPath: order.deliveryPhotoPath,
      pizzas: order.pizzas,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      total: order.total,
      createdAt: order.createdAt,
      updatedAt: DateTime.now(),
      restaurant: order.restaurant,
    );

    _mockOrders[orderIndex] = updatedOrder;

    return updatedOrder;
  }

  // Get single order
  Future<Order?> getOrder(int orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _initializeMockOrders();

    try {
      return _mockOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Create new order (for when customers place orders)
  Future<Order> createOrder({
    required int restaurantId,
    required String customerName,
    required String customerEmail,
    String? customerPhone,
    required String deliveryAddress,
    String? notes,
    String? deliveryPhotoPath,
    required List<OrderPizza> pizzas,
    required double subtotal,
    required double deliveryFee,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _initializeMockOrders();

    final newOrder = Order(
      id: _mockOrders.length + 1,
      status: 'pending',
      restaurantId: restaurantId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      notes: notes,
      deliveryPhotoPath: deliveryPhotoPath,
      pizzas: pizzas,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: subtotal + deliveryFee,
      createdAt: DateTime.now(),
    );

    _mockOrders.add(newOrder);
    return newOrder;
  }

  // Get order statistics
  Future<OrderStats> getOrderStats(int restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final orders = await getOrdersByRestaurant(restaurantId);

    return OrderStats(
      totalOrders: orders.length,
      pendingOrders: orders.where((o) => o.isPending).length,
      preparingOrders: orders.where((o) => o.isPreparing).length,
      shippedOrders: orders.where((o) => o.isShipped).length,
      deliveredOrders: orders.where((o) => o.isDelivered).length,
      todayRevenue: orders
          .where((o) => _isToday(o.createdAt) && o.isDelivered)
          .fold(0.0, (sum, o) => sum + o.total),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// Order statistics model
class OrderStats {
  final int totalOrders;
  final int pendingOrders;
  final int preparingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final double todayRevenue;

  OrderStats({
    required this.totalOrders,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.todayRevenue,
  });

  int get activeOrders => pendingOrders + preparingOrders + shippedOrders;
  String get formattedTodayRevenue => '€${todayRevenue.toStringAsFixed(2)}';
}
