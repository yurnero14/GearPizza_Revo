import '../models/restaurant.dart';

class RestaurantService {
  /// Get all restaurants - PURE MOCK DATA (no Directus calls)
  Future<List<Restaurant>> getRestaurants() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    print('RestaurantService: Returning mock data (no Directus)');

    return [
      Restaurant(
        id: 5, // Exact ID from Directus
        name: "The Sparrow Restaurant",
        address: "Via Roma 123, Milano, Italy",
        phone: "+39 02 1234567",
        description: "Traditional Italian restaurant serving authentic cuisine",
        status: "active",
      ),
    ];
  }

  /// Get single restaurant by ID
  Future<Restaurant?> getRestaurant(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final restaurants = await getRestaurants();
    try {
      return restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }
}
