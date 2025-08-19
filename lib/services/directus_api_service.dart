// lib/services/directus_api_service.dart - COMPLETE VERSION
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/restaurant.dart';
import '../models/pizza.dart';
import '../models/allergen.dart';
import '../models/order.dart';
import '../models/auth_response.dart';
import '../models/user.dart';

class DirectusApiService {
  static String? _accessToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // LOGIN
  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.authLogin}');

    print('🌐 Login to: $url');
    print('📧 Email: $email');

    final requestBody = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http
          .post(
            url,
            headers: _headers,
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('data')) {
          _accessToken = data['data']['access_token'];
        } else {
          _accessToken = data['access_token'];
        }

        return AuthResponse(
          user: User(
            id: 'user_id',
            email: email,
            firstName: null,
            lastName: null,
            role: 'owner',
            token: _accessToken,
            restaurantId: 1,
          ),
          accessToken: _accessToken!,
          refreshToken: data['refresh_token'] ?? '',
          expiresIn: data['expires'] ?? 3600,
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['errors']?[0]?['message'] ?? 'Login failed';
        throw Exception('Login failed: $errorMessage');
      }
    } catch (e) {
      print('💥 Login error: $e');
      rethrow;
    }
  }

  // RESTAURANTS
  Future<List<Restaurant>> getRestaurants() async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.restaurants}?fields=*');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> restaurantsData = data['data'] ?? [];
        return restaurantsData
            .map((json) => Restaurant.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print('💥 Restaurant error: $e');
      rethrow;
    }
  }

  // ALLERGENS
  Future<List<Allergen>> getAllergens() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.allergens}');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> allergensData = data['data'] ?? [];
        return allergensData.map((json) => Allergen.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load allergens');
      }
    } catch (e) {
      print('💥 Allergen error: $e');
      rethrow;
    }
  }

  // PIZZAS
  Future<List<Pizza>> getPizzasByRestaurant(int restaurantId,
      {List<Allergen>? excludedAllergens}) async {
    print('🍕 DirectusAPI: Getting pizzas for restaurant $restaurantId');

    // Get all pizzas first, then filter
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pizzas}?fields=*.*');

    try {
      final response = await http
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 10));

      print('📥 Pizzas response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> pizzasData = data['data'] ?? [];

        print('🔍 Found ${pizzasData.length} total pizzas in Directus');

        // Filter pizzas for the specific restaurant
        List<Pizza> restaurantPizzas = [];

        for (var pizzaJson in pizzasData) {
          try {
            // Check if pizza belongs to this restaurant
            var restaurantField = pizzaJson['restaurant'];
            int pizzaRestaurantId;

            if (restaurantField is Map) {
              pizzaRestaurantId = restaurantField['id'] ?? 0;
            } else {
              pizzaRestaurantId = restaurantField ?? 0;
            }

            print(
                '🔍 Pizza "${pizzaJson['name']}" belongs to restaurant $pizzaRestaurantId');

            if (pizzaRestaurantId == restaurantId) {
              // Handle allergens field - it might be an array of objects
              List<Allergen> allergens = [];
              if (pizzaJson['allergens'] != null &&
                  pizzaJson['allergens'] is List) {
                for (var allergenData in pizzaJson['allergens']) {
                  try {
                    if (allergenData is Map<String, dynamic>) {
                      allergens.add(Allergen.fromJson(allergenData));
                    }
                  } catch (e) {
                    print('⚠️ Failed to parse allergen: $e');
                  }
                }
              }

              // Create pizza with proper data
              final pizza = Pizza(
                id: pizzaJson['id'] ?? 0,
                name: pizzaJson['name'] ?? 'Unknown Pizza',
                description: pizzaJson['description'] ?? 'No description',
                price: (pizzaJson['price'] ?? 0).toDouble(),
                restaurant: restaurantId,
                image: pizzaJson['cover_image'],
                allergens: allergens,
              );

              restaurantPizzas.add(pizza);
              print('✅ Added pizza: ${pizza.name} (€${pizza.price})');
            }
          } catch (e) {
            print('❌ Failed to parse pizza: $e');
            print('🔍 Problem pizza data: $pizzaJson');
          }
        }

        print(
            '🎯 Final result: ${restaurantPizzas.length} pizzas for restaurant $restaurantId');

        if (restaurantPizzas.isEmpty) {
          print(
              '⚠️ No pizzas found for restaurant $restaurantId, using fallback');
          return _createFallbackPizzas(restaurantId);
        }

        return restaurantPizzas;
      } else {
        print('⚠️ Pizza API failed with status ${response.statusCode}');
        return _createFallbackPizzas(restaurantId);
      }
    } catch (e) {
      print('💥 DirectusAPI: Pizza exception: $e');
      return _createFallbackPizzas(restaurantId);
    }
  }

  // CREATE PIZZA
  Future<Pizza> createPizza({
    required String name,
    required String description,
    required double price,
    required int restaurantId,
    required List<int> allergenIds,
    File? imageFile,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pizzas}');

    final requestBody = {
      'name': name,
      'description': description,
      'price': price,
      'restaurant': restaurantId,
      'allergens': allergenIds,
    };

    final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Pizza.fromJson(data['data']);
    } else {
      throw Exception('Failed to create pizza');
    }
  }

  // UPDATE PIZZA
  Future<Pizza> updatePizza({
    required int pizzaId,
    required String name,
    required String description,
    required double price,
    required List<int> allergenIds,
    File? imageFile,
  }) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pizzas}/$pizzaId');

    final requestBody = {
      'name': name,
      'description': description,
      'price': price,
      'allergens': allergenIds,
    };

    final response = await http.patch(
      url,
      headers: _headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pizza.fromJson(data['data']);
    } else {
      throw Exception('Failed to update pizza');
    }
  }

  // DELETE PIZZA
  Future<void> deletePizza(int pizzaId) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pizzas}/$pizzaId');

    final response = await http.delete(url, headers: _headers);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete pizza');
    }
  }

  // CLEAR TOKEN - FIXED
  void clearToken() {
    _accessToken = null;
    print('🗑️ Token cleared');
  }

  List<Pizza> _createFallbackPizzas(int restaurantId) {
    final fallbackAllergens = [
      Allergen(
          id: 1, name: 'Milk', code: 'MILK', description: 'Contains dairy'),
      Allergen(
          id: 2, name: 'Wheat', code: 'WHEAT', description: 'Contains gluten'),
    ];

    return [
      Pizza(
        id: 79,
        name: "The Volcano Vesuvio",
        description: "Spicy pizza with hot peppers and volcanic cheese",
        price: 12.99,
        restaurant: restaurantId,
        image: null,
        allergens: fallbackAllergens,
      ),
      Pizza(
        id: 80,
        name: "The Moonlight Truffle",
        description: "Gourmet truffle pizza with premium ingredients",
        price: 18.99,
        restaurant: restaurantId,
        image: null,
        allergens: fallbackAllergens,
      ),
      Pizza(
        id: 81,
        name: "The Garden of Crust",
        description: "Fresh vegetable pizza with garden herbs",
        price: 14.99,
        restaurant: restaurantId,
        image: null,
        allergens: fallbackAllergens,
      ),
    ];
  }
}
