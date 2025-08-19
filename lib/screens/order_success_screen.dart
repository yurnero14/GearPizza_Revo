import 'package:flutter/material.dart';
import 'restaurant_list_screen.dart';
import 'customer_order_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final int? orderId; // Add order ID parameter
  final String? customerEmail; // Add customer email parameter

  const OrderSuccessScreen({
    super.key,
    this.orderId,
    this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 248, 240),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Order Placed Successfully!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your delicious pizza is being prepared!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (orderId != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Order #$orderId',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 200, 45, 45),
                      ),
                ),
              ],
              const SizedBox(height: 32),

              // Track Order Button (Primary Action)
              if (orderId != null && customerEmail != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _trackOrder(context),
                    icon: const Icon(Icons.track_changes),
                    label: const Text('Track Your Order'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color.fromARGB(255, 200, 45, 45),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Order More Pizza Button (Secondary Action)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _orderMorePizza(context),
                  icon: const Icon(Icons.local_pizza),
                  label: const Text('Order More Pizza'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 200, 45, 45),
                    ),
                    foregroundColor: const Color.fromARGB(255, 200, 45, 45),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _trackOrder(BuildContext context) {
    if (orderId != null && customerEmail != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerOrderTrackingScreen(
            orderId: orderId!,
            customerEmail: customerEmail!,
          ),
        ),
      );
    }
  }

  void _orderMorePizza(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const RestaurantListScreen(),
      ),
      (route) => false,
    );
  }
}
