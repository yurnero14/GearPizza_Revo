import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';

class RestaurantProvider with ChangeNotifier {
  //private variables

  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _restaurants = [];
  Restaurant? _selectedRestaurant;
  bool _isLoading = false;
  String? _error;

  //public getter
  List<Restaurant> get restaurants => _restaurants;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasRestaurants => _restaurants.isNotEmpty;

  //loading all restaurants from service
  Future<void> loadRestaurants() async {
    _setLoading(true);
    _clearError();

    try {
      //calling service to get restaurant data
      _restaurants = await _restaurantService.getRestaurants();

      // tell all listening widgets to rebuild
      notifyListeners();
    } catch (e) {
      //save the error if something goes wrong
      _setError(e.toString());
    } finally {
      //always stop loading whether success or failure (error)
      _setLoading(false);
    }
  }

  // select the restaurant when tapped on by the user
  void selectRestaurant(Restaurant restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }

  // clear selected restaurant
  void clearSelection() {
    _selectedRestaurant = null;
    notifyListeners();
  }

  // refresh restaurants
  Future<void> refresh() async {
    await loadRestaurants();
  }

  //private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
