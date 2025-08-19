import '../models/allergen.dart';

class AllergenService {
  /// Get all available allergens - Updated with Directus data
  Future<List<Allergen>> getAllergens() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Using the exact allergens from Directus screenshots
    return [
      Allergen(
          id: 1,
          name: 'Milk',
          code: 'MILK',
          description: 'Contains milk, cheese, or other dairy products'),
      Allergen(
          id: 2,
          name: 'Wheat',
          code: 'WHEAT',
          description:
              'Contains wheat, barley, rye, or other gluten-containing grains'),
      Allergen(
          id: 3,
          name: 'Egg',
          code: 'EGG',
          description: 'Contains eggs or egg-based ingredients'),
      Allergen(
          id: 4,
          name: 'Tomato',
          code: 'TOMATO',
          description: 'Contains tomatoes or tomato-based products'),
      Allergen(
          id: 5,
          name: 'Yeast',
          code: 'YEAST',
          description: 'Contains yeast or yeast-based products'),
      Allergen(
          id: 6,
          name: 'Soy',
          code: 'SOY',
          description: 'Contains soy beans or soy-based products'),
      Allergen(
          id: 7,
          name: 'Fish',
          code: 'FISH',
          description: 'Contains fish or fish-based products'),
      Allergen(
          id: 8,
          name: 'Peanuts',
          code: 'PEANUTS',
          description: 'Contains peanuts or peanut-based products'),
    ];
  }

  /// Get allergen by ID
  Future<Allergen?> getAllergen(int id) async {
    final allergens = await getAllergens();
    try {
      return allergens.firstWhere((allergen) => allergen.id == id);
    } catch (e) {
      return null; // Allergen not found
    }
  }
}
