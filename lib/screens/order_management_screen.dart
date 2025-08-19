// lib/screens/owner/order_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../widgets/order_card.dart';
import '../../models/order_status.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderService _orderService = OrderService();

  List<Order> _allOrders = [];
  List<Order> _pendingOrders = [];
  List<Order> _preparingOrders = [];
  List<Order> _shippedOrders = [];
  List<Order> _deliveredOrders = [];
  OrderStats? _stats;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      final restaurantId = auth.ownerRestaurantId ?? 1;

      final orders = await _orderService.getOrdersByRestaurant(restaurantId);
      final stats = await _orderService.getOrderStats(restaurantId);

      setState(() {
        _allOrders = orders;
        _pendingOrders = orders.where((o) => o.isPending).toList();
        _preparingOrders = orders.where((o) => o.isPreparing).toList();
        _shippedOrders = orders.where((o) => o.isShipped).toList();
        _deliveredOrders = orders.where((o) => o.isDelivered).toList();
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 248, 240),
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: const Color.fromARGB(255, 200, 45, 45),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
        bottom: _isLoading
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'All (${_allOrders.length})',
                    icon: const Icon(Icons.list_alt, size: 20),
                  ),
                  Tab(
                    text: 'Pending (${_pendingOrders.length})',
                    icon: const Icon(Icons.schedule, size: 20),
                  ),
                  Tab(
                    text: 'Preparing (${_preparingOrders.length})',
                    icon: const Icon(Icons.restaurant, size: 20),
                  ),
                  Tab(
                    text: 'Shipped (${_shippedOrders.length})',
                    icon: const Icon(Icons.local_shipping, size: 20),
                  ),
                  Tab(
                    text: 'Delivered (${_deliveredOrders.length})',
                    icon: const Icon(Icons.check_circle, size: 20),
                  ),
                ],
              ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 200, 45, 45),
              ),
            )
          : _error != null
              ? _buildErrorState()
              : Column(
                  children: [
                    if (_stats != null) _buildStatsHeader(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOrderList(_allOrders),
                          _buildOrderList(_pendingOrders),
                          _buildOrderList(_preparingOrders),
                          _buildOrderList(_shippedOrders),
                          _buildOrderList(_deliveredOrders),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatsHeader() {
    final stats = _stats!;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Active Orders',
              '${stats.activeOrders}',
              Icons.schedule,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Today Revenue',
              stats.formattedTodayRevenue,
              Icons.euro,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: const Color.fromARGB(255, 200, 45, 45),
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onStatusUpdate: _updateOrderStatus,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Orders will appear here when customers place them',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load orders',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadOrders,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateOrderStatus(Order order, String newStatus) async {
    try {
      await _orderService.updateOrderStatus(order.id, newStatus);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Order #${order.id} updated to ${OrderStatusExtension.fromString(newStatus).displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Reload orders to reflect changes
      await _loadOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
