import '../models/user.dart';
import '../models/auth_response.dart';

class AuthService {
  // Mock login - no Directus calls
  Future<AuthResponse> login(String email, String password) async {
    print('AuthService: Mock login attempt for $email');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock credentials that will work
    if ((email == 'sarib@gearpizza.it' && password == 'i3|h;A03=B&\\') ||
        (email == 'owner@gearpizza.com' && password == 'pizza123')) {
      print('AuthService: Mock login successful');

      final mockUser = User(
        id: 'mock_user_123',
        email: email,
        firstName: 'Restaurant',
        lastName: 'Owner',
        role: 'owner',
        token: 'mock_token_123456789',
        restaurantId: 5, // The Sparrow Restaurant
      );

      return AuthResponse(
        user: mockUser,
        accessToken: 'mock_access_token_123456789',
        refreshToken: 'mock_refresh_token_987654321',
        expiresIn: 3600,
      );
    } else {
      print('AuthService: Mock login failed - invalid credentials');
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    print('AuthService: Mock logout');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<User?> getCurrentUser() async {
    // Mock - no persistent login for now
    return null;
  }

  Future<bool> isLoggedIn() async {
    return false;
  }
}
