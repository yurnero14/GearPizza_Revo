import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pizza_provider.dart';
import '../providers/allergen_provider.dart';
import '../providers/cart_provider.dart';
import '../models/restaurant.dart';
import '../models/pizza.dart';
import '../models/allergen.dart';
import 'cart_screen.dart';
import '../widgets/pizza_detail.dart';

class PizzaListScreen extends StatefulWidget {
  final Restaurant restaurant;

  const PizzaListScreen({super.key, required this.restaurant});

  @override
  State<PizzaListScreen> createState() => _PizzaListScreenState();
}

class _PizzaListScreenState extends State<PizzaListScreen> {
  @override
  void initState() {
    super.initState();
    //load all the restaurants when screen starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PizzaProvider>()
          .loadPizzasByRestaurant(widget.restaurant.id);
      context.read<AllergenProvider>().loadAllergens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurant.name),
          backgroundColor: const Color.fromARGB(255, 200, 45, 45),
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
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
        body: Column(
          children: [
            _buildAllergenFilter(),
            Expanded(child:
                Consumer<PizzaProvider>(builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 200, 45, 45),
                  ),
                );
              }
              if (provider.error != null) {
                return _buildErrorState(context, provider);
              }

              if (!provider.hasPizzas) {
                return _buildEmptyState(context, provider);
              }

              return _buildPizzaList(context, provider.pizzas);
            }))
          ],
        ));
  }

  Widget _buildAllergenFilter() {
    return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list,
                    size: 20, color: Color.fromARGB(255, 200, 45, 45)),
                const SizedBox(width: 8),
                Text(
                  'Filter by allergens to exclude: ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 65, 65, 65),
                      ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Consumer2<AllergenProvider, PizzaProvider>(
              builder: (context, allergenProvider, pizzaProvider, child) {
                if (allergenProvider.isLoading) {
                  return const Text('Loading allergens...');
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allergenProvider.allergens.map((allergen) {
                    final isExcluded =
                        pizzaProvider.excludedAllergens.contains(allergen);
                    return FilterChip(
                      label: Text(allergen.name),
                      selected: isExcluded,
                      onSelected: (selected) {
                        pizzaProvider.toggleAllergenExclusion(allergen);
                      },
                      selectedColor: Colors.red.withValues(alpha: 0.2),
                      checkmarkColor: const Color.fromARGB(255, 200, 45, 45),
                      backgroundColor: Colors.grey[100],
                    );
                  }).toList(),
                );
              },
            ),

            //show filter info
            Consumer<PizzaProvider>(
              builder: (context, provider, child) {
                if (provider.hasAllergenFilter) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Text(
                          provider.filterInfo,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => provider.clearAllergenFilters(),
                          child: const Text('Clear filters'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ));
  }

  Widget _buildErrorState(BuildContext context, PizzaProvider provider) {
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
                  child: const Text('Try Again')),
            ],
          )),
    );
  }

  Widget _buildEmptyState(BuildContext context, PizzaProvider provider) {
    final hasFilter = provider.hasAllergenFilter;
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_pizza,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Pizzas match your filters',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilter
                ? 'Try removing some allergen filters'
                : 'This restaurant has no pizzas yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          if (hasFilter) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.clearAllergenFilters(),
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    ));
  }

  Widget _buildPizzaList(BuildContext context, List<Pizza> pizzas) {
    return RefreshIndicator(
      color: const Color.fromARGB(255, 211, 47, 47),
      onRefresh: () => context.read<PizzaProvider>().refresh(),
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pizzas.length,
          itemBuilder: (context, index) {
            final pizza = pizzas[index];
            return _buildPizzaCard(context, pizza);
          }),
    );
  }

  Widget _buildPizzaCard(BuildContext context, Pizza pizza) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
          onTap: () => _showPizzaDetail(context, pizza),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // UPDATED: Pizza image instead of icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: pizza.image != null
                          ? Image.asset(
                              pizza.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to icon if image fails to load
                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 200, 45, 45)
                                            .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.local_pizza,
                                    color: Color.fromARGB(255, 200, 45, 45),
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 200, 45, 45)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.local_pizza,
                                color: Color.fromARGB(255, 200, 45, 45),
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Rest of your existing code stays the same...
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pizza.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pizza.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              pizza.formattedPrice,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        const Color.fromARGB(255, 200, 45, 45),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),

                            //cart controls
                            Consumer<CartProvider>(
                              builder: (context, cart, child) {
                                final quantity = cart.getQuantity(pizza.id);
                                if (quantity > 0) {
                                  return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () =>
                                              cart.decrementQuantity(pizza.id),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                              minWidth: 32, minHeight: 32),
                                        ),
                                        Text(quantity.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () =>
                                              cart.incrementQuantity(pizza.id),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                              minWidth: 32, minHeight: 32),
                                        ),
                                      ]);
                                }
                                return IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  onPressed: () => cart.addPizza(pizza),
                                );
                              },
                            ),
                          ],
                        ),

                        //allergen tags
                        if (pizza.allergens.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children: pizza.allergens.map((allergen) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  allergen.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  void _showPizzaDetail(BuildContext context, Pizza pizza) {
    PizzaDetailModal.show(context, pizza);
  }

  void _goToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }
}
