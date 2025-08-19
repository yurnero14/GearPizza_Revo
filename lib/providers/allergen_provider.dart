import 'package:flutter/foundation.dart';
import '../models/allergen.dart';
import '../services/allergen_service.dart';

class AllergenProvider with ChangeNotifier {
  final AllergenService _allergenService = AllergenService();

  List<Allergen> _allergens = [];
  bool _isLoading = false;
  String? _error;

  //getters
  List<Allergen> get allergens => _allergens;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasAllergens => _allergens.isNotEmpty;

  //Load all allergens (caching the result)

  Future<void> loadAllergens() async {
    if (_allergens.isNotEmpty) return;

    _setLoading(true);
    _clearError();

    try {
      _allergens = await _allergenService.getAllergens();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //GET allergen by id
  Allergen? getAllergenById(int id) {
    try {
      return _allergens.firstWhere((allergen) => allergen.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Allergen> getAllergensByIds(List<int> ids) {
    return _allergens.where((allergen) => ids.contains(allergen.id)).toList();
  }

  //force reload

  Future<void> refresh() async {
    _allergens.clear();
    await loadAllergens();
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
