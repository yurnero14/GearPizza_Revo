import 'package:flutter/foundation.dart';
import '../models/pizza.dart';
import '../models/allergen.dart';
import '../services/pizza_service.dart';

class PizzaProvider with ChangeNotifier {
  final PizzaService _pizzaService = PizzaService();

  List<Pizza> _pizzas = [];
  List<Pizza> _filteredPizzas = [];
  List<Allergen> _excludedAllergens = [];
  bool _isLoading = false;
  String? _error;
  int? _currentRestaurantId;

  //getters
  List<Pizza> get pizzas => _filteredPizzas;
  List<Pizza> get allPizzas => _pizzas;
  List<Allergen> get excludedAllergens => _excludedAllergens;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPizzas => _filteredPizzas.isNotEmpty;
  bool get hasAllergenFilter => _excludedAllergens.isNotEmpty;
  int? get currentRestaurantId => _currentRestaurantId;

  //load pizzas for a restaurant

  Future<void> loadPizzasByRestaurant(int restaurantId) async {
    _currentRestaurantId = restaurantId;
    _setLoading(true);
    _clearError();

    try {
      _pizzas = await _pizzaService.getPizzasByRestaurant(
        restaurantId,
        excludedAllergens:
            _excludedAllergens.isNotEmpty ? _excludedAllergens : null,
      );
      _applyAllergenFilter();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void toggleAllergenExclusion(Allergen allergen) {
    if (_excludedAllergens.contains(allergen)) {
      _excludedAllergens.remove(allergen);
    } else {
      _excludedAllergens.add(allergen);
    }

    if (_currentRestaurantId != null) {
      loadPizzasByRestaurant(_currentRestaurantId!);
    }
    notifyListeners();
  }

  void clearAllergenFilters() {
    _excludedAllergens.clear();

    // Reload pizzas without filters
    if (_currentRestaurantId != null) {
      loadPizzasByRestaurant(_currentRestaurantId!);
    }
    notifyListeners();
  }

  //apply allergen filtering to pizzas (local filtering)
  void _applyAllergenFilter() {
    if (_excludedAllergens.isEmpty) {
      _filteredPizzas = List.from(_pizzas);
    } else {
      _filteredPizzas = _pizzas.where((pizza) {
        return !pizza.containsAllergens(_excludedAllergens);
      }).toList();
    }
  }

  Pizza? getPizzaById(int id) {
    try {
      return _pizzas.firstWhere((pizza) => pizza.id == id);
    } catch (e) {
      return null;
    }
  }

  //refresh pizzas for current restaurant
  Future<void> refresh() async {
    if (_currentRestaurantId != null) {
      await loadPizzasByRestaurant(_currentRestaurantId!);
    }
  }
  //clear data when switiching restaurants

  void clear() {
    _pizzas.clear();
    _filteredPizzas.clear();
    _excludedAllergens.clear();
    _currentRestaurantId = null;
    _error = null;
    notifyListeners();
  }

  String get filterInfo {
    if (!hasAllergenFilter) return '';

    final filteredOut = _pizzas.length - _filteredPizzas.length;
    if (filteredOut == 0) {
      return 'No pizzas filtered';
    }
    return '$filteredOut pizza${filteredOut == 1 ? '' : 's'} hidden due to allergen filters';
  }

  //private helpers

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
