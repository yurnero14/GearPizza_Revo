import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../models/restaurant.dart';
import 'pizza_list_screen.dart';
import 'cart_screen.dart';
import '../screens/login_screen.dart';
import '../screens/customer_order_tracking_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  void initState() {
    super.initState();
    //load all the restaurants when screen starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GearPizza'),
          backgroundColor: const Color.fromARGB(255, 200, 45, 45),
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            // ADD THIS: Track Order button
            IconButton(
              icon: const Icon(Icons.track_changes),
              onPressed: () => _showTrackOrderDialog(context),
              tooltip: 'Track Order',
            ),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () => _navigateToLogin(context),
              tooltip: 'Owner Login',
            ),
            //cart button with badge
            Consumer<CartProvider>(builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => _goToCart(context),
                  ),
                  if (cart.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 140, 25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${cart.totalQuantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 252, 248, 240),
        body: Consumer<RestaurantProvider>(
          builder: (context, provider, child) {
            //loading spinner
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 200, 45, 45)),
              );
            }

            //show error if things go wrong
            if (provider.error != null) {
              return _buildErrorState(context, provider);
            }

            if (!provider.hasRestaurants) {
              return _buildEmptyState(context);
            }

            return _buildRestaurantList(context, provider.restaurants);
          },
        ));
  }

  Widget _buildErrorState(BuildContext context, RestaurantProvider provider) {
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
                'Bummer! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () => provider.refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 200, 45, 45),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Try Again')),
            ],
          )),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No restaurants available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later for scrumptious pizza options!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }

  Widget _buildRestaurantList(
      BuildContext context, List<Restaurant> restaurants) {
    return RefreshIndicator(
      color: const Color.fromARGB(255, 211, 47, 47),
      onRefresh: () => context.read<RestaurantProvider>().refresh(),
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];
            return _buildRestaurantCard(context, restaurant);
          }),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
          onTap: () => _selectRestaurant(context, restaurant),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  //Restaurant icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 200, 45, 45)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Color.fromARGB(255, 200, 45, 45),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),

                  //details when expanded
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                restaurant.address,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (restaurant.phone != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.phone!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ],
                        if (restaurant.description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            restaurant.description!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  //arrow
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ))),
    );
  }

  void _selectRestaurant(BuildContext context, Restaurant restaurant) {
    //saving selected restarurant in provider
    context.read<RestaurantProvider>().selectRestaurant(restaurant);

    //navigate to pizza lisst screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PizzaListScreen(restaurant: restaurant),
      ),
    );
  }

  void _goToCart(BuildContext context) {
    // Navigate to cart screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _showTrackOrderDialog(BuildContext context) {
    final orderIdController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Your Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(
                labelText: 'Order ID',
                hintText: 'e.g. 1, 2, 3...',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'your@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Demo: Try Order IDs 1-6 with any email',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final orderId = int.tryParse(orderIdController.text);
              final email = emailController.text.trim();

              if (orderId != null && email.isNotEmpty) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerOrderTrackingScreen(
                      orderId: orderId,
                      customerEmail: email,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter valid Order ID and Email'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Track Order'),
          ),
        ],
      ),
    );
  }
}
