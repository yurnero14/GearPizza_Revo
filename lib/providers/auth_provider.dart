import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/auth_response.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;
  bool get isOwner => _currentUser?.isOwner ?? false;
  bool get isCustomer => _currentUser?.isCustomer ?? false;
  int? get ownerRestaurantId => _currentUser?.restaurantId;

  // Initialize auth state
  Future<void> initializeAuth() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.getCurrentUser();
      _isLoggedIn = _currentUser != null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await _authService.login(email, password);
      _currentUser = authResponse.user;
      _isLoggedIn = true;

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to logout');
    } finally {
      _setLoading(false);
    }
  }

  // Check if user has access to restaurant management
  bool canManageRestaurant(int restaurantId) {
    if (!isOwner || _currentUser?.restaurantId == null) return false;
    return _currentUser!.restaurantId == restaurantId;
  }

  // Private helpers
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
