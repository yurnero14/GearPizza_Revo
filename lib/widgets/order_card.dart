// lib/widgets/order_card.dart - FIXED VERSION with Pizza Names
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_status.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(Order, String) onStatusUpdate;

  const OrderCard({
    super.key,
    required this.order,
    required this.onStatusUpdate,
  });

  // PIZZA name mapping helper
  String _getPizzaName(int pizzaId) {
    switch (pizzaId) {
      case 79:
        return "The Volcano Vesuvio";
      case 80:
        return "The Moonlight Truffle";
      case 81:
        return "The Garden of Crust";
      case 82:
        return "The Pirate's Feast";
      case 83:
        return "The Cheesus Crust";
      default:
        return "Pizza #$pizzaId";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showOrderDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(context),
              const SizedBox(height: 12),
              _buildCustomerInfo(context),
              const SizedBox(height: 12),
              _buildPizzasList(context),
              const SizedBox(height: 12),
              _buildOrderFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _getStatusColor().withValues(alpha: 0.3)),
          ),
          child: Text(
            '#${order.id}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(),
                ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            order.statusDisplayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        Text(
          order.timeAgo,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                order.customerName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                order.deliveryAddress,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (order.customerPhone != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                order.customerPhone!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPizzasList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${order.totalPizzaCount} pizzas)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          // FIXED: Now shows actual pizza names
          ...order.pizzas.map((orderPizza) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text('${orderPizza.quantity}x'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getPizzaName(
                          orderPizza.pizzaId), // FIXED: Use pizza name
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    orderPizza.formattedTotalPrice,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderFooter(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ${order.formattedTotal}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 200, 45, 45),
                  ),
            ),
            if (order.notes != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.note, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Has notes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
        const Spacer(),
        if (order.canAdvanceStatus)
          _buildAdvanceButton(context)
        else if (order.canCancelOrder)
          _buildCancelButton(context),
      ],
    );
  }

  Widget _buildAdvanceButton(BuildContext context) {
    final nextStatus = order.nextStatus;
    if (nextStatus == null) return const SizedBox.shrink();

    return ElevatedButton.icon(
      onPressed: () => _confirmStatusUpdate(context, nextStatus.value),
      icon: _getStatusIcon(nextStatus),
      label: Text(_getAdvanceButtonText(nextStatus)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getStatusColor(nextStatus),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _confirmStatusUpdate(context, 'cancelled'),
      icon: const Icon(Icons.cancel, size: 16),
      label: const Text('Cancel'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Color _getStatusColor([OrderStatus? status]) {
    final statusToCheck = status ?? order.orderStatus;
    switch (statusToCheck) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  Icon _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.preparing:
        return const Icon(Icons.restaurant, size: 16);
      case OrderStatus.shipped:
        return const Icon(Icons.local_shipping, size: 16);
      case OrderStatus.delivered:
        return const Icon(Icons.check_circle, size: 16);
      default:
        return const Icon(Icons.arrow_forward, size: 16);
    }
  }

  String _getAdvanceButtonText(OrderStatus nextStatus) {
    switch (nextStatus) {
      case OrderStatus.preparing:
        return 'Start Prep';
      case OrderStatus.shipped:
        return 'Ship Order';
      case OrderStatus.delivered:
        return 'Mark Delivered';
      default:
        return 'Next Status';
    }
  }

  void _confirmStatusUpdate(BuildContext context, String newStatus) {
    final statusEnum = OrderStatusExtension.fromString(newStatus);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Order #${order.id}'),
        content: Text(
          newStatus == 'cancelled'
              ? 'Are you sure you want to cancel this order?'
              : 'Update order status to "${statusEnum.displayName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onStatusUpdate(order, newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'cancelled' ? Colors.red : null,
            ),
            child: Text(newStatus == 'cancelled' ? 'Cancel Order' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderDetailsModal(order: order),
    );
  }
}

//simple order deits
class _OrderDetailsModal extends StatelessWidget {
  final Order order;

  const _OrderDetailsModal({required this.order});

  // with pizza mapping
  String _getPizzaName(int pizzaId) {
    switch (pizzaId) {
      case 79:
        return "The Volcano Vesuvio";
      case 80:
        return "The Moonlight Truffle";
      case 81:
        return "The Garden of Crust";
      case 82:
        return "The Pirate's Feast";
      case 83:
        return "The Cheesus Crust";
      default:
        return "Pizza #$pizzaId";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 252, 248, 240),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.id} Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text('Name: ${order.customerName}'),
                          Text('Email: ${order.customerEmail}'),
                          if (order.customerPhone != null)
                            Text('Phone: ${order.customerPhone}'),
                          const SizedBox(height: 12),
                          Text('Address: ${order.deliveryAddress}'),
                          if (order.notes != null)
                            Text('Notes: ${order.notes}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          // FIXED: Show pizza names in modal too
                          ...order.pizzas.map((p) => Text(
                              '${p.quantity}x ${_getPizzaName(p.pizzaId)} - ${p.formattedTotalPrice}')),
                          const SizedBox(height: 12),
                          Text('Subtotal: ${order.formattedSubtotal}'),
                          Text('Delivery Fee: ${order.formattedDeliveryFee}'),
                          Text(
                            'Total: ${order.formattedTotal}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
