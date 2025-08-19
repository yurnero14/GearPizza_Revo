import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pizza.dart';
import '../providers/cart_provider.dart';

class PizzaDetailModal extends StatelessWidget {
  final Pizza pizza;

  const PizzaDetailModal({
    super.key,
    required this.pizza,
  });

  static void show(BuildContext context, Pizza pizza) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PizzaDetailModal(pizza: pizza),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 252, 248, 240),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
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
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPizzaHeader(context),
                        const SizedBox(height: 24),
                        _buildDescription(context),
                        const SizedBox(height: 24),
                        _buildAllergenInfo(context),
                        const SizedBox(height: 32),
                        _buildAddToCartSection(context),
                      ])))
        ]));
  }

  Widget _buildPizzaHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
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
                          color: const Color.fromARGB(255, 200, 45, 45)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_pizza,
                          color: Color.fromARGB(255, 200, 45, 45),
                          size: 50,
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
                      size: 50,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              pizza.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 65, 65, 65),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              pizza.formattedPrice,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromARGB(255, 200, 45, 45),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Description',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        pizza.description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
      ),
    ]);
  }

  Widget _buildAllergenInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergen Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (pizza.allergens.isEmpty)
          _buildNoAllergensCard(context)
        else
          _buildAllergensCard(context),
      ],
    );
  }

  Widget _buildNoAllergensCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No known allergens',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergensCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Contains allergens:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pizza.allergens.map((allergen) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      allergen.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (allergen.description != null) ...[
                      const SizedBox(width: 4),
                      Tooltip(
                        message: allergen.description!,
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartSection(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final quantity = cart.getQuantity(pizza.id);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              if (quantity > 0)
                _buildQuantityControls(context, cart, quantity)
              else
                _buildAddToCartButton(context, cart),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityControls(
      BuildContext context, CartProvider cart, int quantity) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => cart.decrementQuantity(pizza.id),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quantity.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => cart.incrementQuantity(pizza.id),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Total: €${(pizza.price * quantity).toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color.fromARGB(255, 200, 45, 45),
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, CartProvider cart) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add_shopping_cart),
        label: Text('Add to Cart - ${pizza.formattedPrice}'),
        onPressed: () {
          cart.addPizza(pizza);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pizza.name} added to cart!'),
              backgroundColor: const Color.fromARGB(255, 200, 45, 45),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
