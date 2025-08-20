import 'dart:io';
import '../models/pizza.dart';
import '../models/allergen.dart';

class PizzaService {
  /// Get pizzas by restaurant (mock data)
  Future<List<Pizza>> getPizzasByRestaurant(
    int restaurantId, {
    List<Allergen>? excludedAllergens,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    print(
        'PizzaService: Returning exact Directus mock data for restaurant $restaurantId');

    // Create allergens exactly as they appear in Directus
    final milkAllergen = Allergen(
        id: 1, name: 'Milk', code: 'MILK', description: 'Contains dairy');
    final wheatAllergen = Allergen(
        id: 2, name: 'Wheat', code: 'WHEAT', description: 'Contains gluten');
    final eggAllergen =
        Allergen(id: 3, name: 'Egg', code: 'EGG', description: 'Contains eggs');
    final tomatoAllergen = Allergen(
        id: 4,
        name: 'Tomato',
        code: 'TOMATO',
        description: 'Contains tomatoes');

    // ALL 5 PIZZAS exactly as they appear in Directus 
    List<Pizza> allPizzas = [
      Pizza(
        id: 79,
        name: "The Volcano Vesuvio",
        description:
            "An eruption of flavor! Smoky pepperoni, spicy Calabrian chili, molten mozzarella, and lava-like tomato sauce on a charred Neapolitan crust. Caution: dangerously delicious.",
        price: 12.99,
        restaurant: 5, // The Sparrow Restaurant ID
        image: "assets/images/pizzas/volacano_vesuvio.jpg",
        allergens: [milkAllergen, wheatAllergen, tomatoAllergen],
      ),
      Pizza(
        id: 80,
        name: "The Moonlight Truffle",
        description:
            "An elegant nighttime indulgence — creamy ricotta, earthy mushrooms, shaved black truffle, and a drizzle of white truffle oil on a soft, moonlit white sauce base.",
        price: 18.99,
        restaurant: 5,
        image: "assets/images/pizzas/Tartufo-proprieta-Versilfood.jpg",
        allergens: [milkAllergen, eggAllergen],
      ),
      Pizza(
        id: 81,
        name: "The Garden of Crust",
        description:
            "A lush edible landscape with roasted zucchini, cherry tomatoes, caramelized onions, baby spinach, feta crumbles, and a kiss of basil pesto. No meat, just magic.",
        price: 14.99,
        restaurant: 5,
        image: "assets/images/pizzas/beautiful-botanical-garden.jpg",
        allergens: [], // No allergens for this one
      ),
      Pizza(
        id: 82,
        name: "The Pirate's Feast",
        description:
            "Yo-ho-ho and a whole lot of toppings! Anchovies, black olives, spicy salami, garlic confit, and sun-dried tomatoes on a rum-scented tomato base (no actual rum, just vibes).",
        price: 16.50,
        restaurant: 5,
        image: "assets/images/pizzas/jack-sparrow.jpg",
        allergens: [], // No allergens for this one
      ),
      Pizza(
        id: 83,
        name: "The Cheesus Crust",
        description:
            "Worship at the altar of cheese. Mozzarella, aged provolone, gorgonzola, Parmigiano-Reggiano, and goat cheese melted into one divine, golden, gooey miracle.",
        price: 15.75,
        restaurant: 5,
        image: null,
        allergens: [], // No allergens for this one
      ),
    ];

    // Filter by restaurant (only return pizzas for the requested restaurant)
    List<Pizza> restaurantPizzas =
        allPizzas.where((pizza) => pizza.restaurant == restaurantId).toList();

    // Apply allergen filtering if provided
    if (excludedAllergens != null && excludedAllergens.isNotEmpty) {
      restaurantPizzas = restaurantPizzas.where((pizza) {
        return !pizza.containsAllergens(excludedAllergens);
      }).toList();
    }

    print(
        'PizzaService: Returning ${restaurantPizzas.length} pizzas for restaurant $restaurantId');
    for (var pizza in restaurantPizzas) {
      print('   - ${pizza.name} (€${pizza.price})');
    }

    return restaurantPizzas;
  }

  /// Get all allergens - PURE MOCK DATA
  Future<List<Allergen>> getAllergens() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      Allergen(
          id: 1, name: 'Milk', code: 'MILK', description: 'Contains dairy'),
      Allergen(
          id: 2, name: 'Wheat', code: 'WHEAT', description: 'Contains gluten'),
      Allergen(id: 3, name: 'Egg', code: 'EGG', description: 'Contains eggs'),
      Allergen(
          id: 4,
          name: 'Tomato',
          code: 'TOMATO',
          description: 'Contains tomatoes'),
      Allergen(
          id: 5, name: 'Yeast', code: 'YEAST', description: 'Contains yeast'),
      Allergen(id: 6, name: 'Soy', code: 'SOY', description: 'Contains soy'),
      Allergen(id: 7, name: 'Fish', code: 'FISH', description: 'Contains fish'),
      Allergen(
          id: 8,
          name: 'Peanuts',
          code: 'PEANUTS',
          description: 'Contains peanuts'),
    ];
  }

  /// Get single pizza by ID
  Future<Pizza?> getPizza(int pizzaId) async {
    final allPizzas = await getPizzasByRestaurant(5); // Get from restaurant 5
    try {
      return allPizzas.firstWhere((pizza) => pizza.id == pizzaId);
    } catch (e) {
      return null;
    }
  }

  // CRUD operations - Mock implementations for owner features
  Future<Pizza> createPizza({
    required String name,
    required String description,
    required double price,
    required int restaurantId,
    required List<Allergen> allergens,
    File? imageFile,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Create new pizza with mock ID
    final newPizza = Pizza(
      id: DateTime.now().millisecondsSinceEpoch, // Mock ID
      name: name,
      description: description,
      price: price,
      restaurant: restaurantId,
      image: null, // Mock - no image handling
      allergens: allergens,
    );

    print('PizzaService: Mock created pizza "${name}"');
    return newPizza;
  }

  Future<Pizza> updatePizza({
    required int pizzaId,
    required String name,
    required String description,
    required double price,
    required List<Allergen> allergens,
    File? imageFile,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock update - return updated pizza
    final updatedPizza = Pizza(
      id: pizzaId,
      name: name,
      description: description,
      price: price,
      restaurant: 5, // Mock restaurant ID
      image: null,
      allergens: allergens,
    );

    print('PizzaService: Mock updated pizza "${name}"');
    return updatedPizza;
  }

  Future<void> deletePizza(int pizzaId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('PizzaService: Mock deleted pizza $pizzaId');
  }
}
