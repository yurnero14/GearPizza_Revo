import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import '../services/directus_api_service.dart';

class DirectusTestWidget extends StatefulWidget {
  const DirectusTestWidget({super.key});

  @override
  State<DirectusTestWidget> createState() => _DirectusTestWidgetState();
}

class _DirectusTestWidgetState extends State<DirectusTestWidget> {
  final DirectusApiService _directusApi = DirectusApiService();
  String _testResults = '';
  bool _isLoading = false;
  String? _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testExactAPIs,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('TEST ASSIGNMENT APIs'),
            ),
            const SizedBox(height: 20),
            if (_testResults.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _testResults,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _testExactAPIs() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Testing exact assignment APIs...\n\n';
    });

    try {
      // Step 1: Login first
      _addResult('🔐 STEP 1: Login');
      final authResponse = await _directusApi.login(
          ApiConstants.ownerEmail, ApiConstants.ownerPassword);
      _token = authResponse.accessToken;
      _addResult('✅ Login successful\n');

      // Step 2: Test Restaurants API
      _addResult('🏪 STEP 2: Testing Restaurants API');
      await _testRestaurantsAPI();

      // Step 3: Test Allergens API
      _addResult('\n🥜 STEP 3: Testing Allergens API');
      await _testAllergensAPI();

      // Step 4: Test Pizzas API
      _addResult('\n🍕 STEP 4: Testing Pizzas API');
      await _testPizzasAPI();
    } catch (e) {
      _addResult('❌ ERROR: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testRestaurantsAPI() async {
    final url = Uri.parse(
        'https://gearpizza.revod.services/items/restaurants?fields=*');

    _addResult('📞 Calling: $url');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    });

    _addResult('📥 Status: ${response.statusCode}');
    _addResult('📥 Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final restaurants = data['data'] ?? [];
      _addResult('✅ Found ${restaurants.length} restaurants');
      for (var restaurant in restaurants) {
        _addResult('   - ID: ${restaurant['id']}, Name: ${restaurant['name']}');
      }
    }
  }

  Future<void> _testAllergensAPI() async {
    final url =
        Uri.parse('https://gearpizza.revod.services/items/allergens?fields=*');

    _addResult('📞 Calling: $url');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    });

    _addResult('📥 Status: ${response.statusCode}');
    _addResult('📥 Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final allergens = data['data'] ?? [];
      _addResult('✅ Found ${allergens.length} allergens');
      for (var allergen in allergens) {
        _addResult('   - ID: ${allergen['id']}, Name: ${allergen['name']}');
      }
    }
  }

  Future<void> _testPizzasAPI() async {
    // Test all pizzas first
    _addResult('🔍 Testing ALL pizzas (no filter)');
    final allPizzasUrl =
        Uri.parse('https://gearpizza.revod.services/items/pizzas?fields=*.*');

    final allResponse = await http.get(allPizzasUrl, headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    });

    _addResult('📥 All pizzas status: ${allResponse.statusCode}');
    _addResult('📥 Response: ${allResponse.body}');

    if (allResponse.statusCode == 200) {
      final allData = json.decode(allResponse.body);
      final allPizzas = allData['data'] ?? [];
      _addResult('✅ Total pizzas in system: ${allPizzas.length}');

      for (var pizza in allPizzas) {
        _addResult(
            '   - ID: ${pizza['id']}, Name: ${pizza['name']}, Price: €${pizza['price']}, Restaurant: ${pizza['restaurant']}');
      }
    }
  }

  void _addResult(String message) {
    setState(() {
      _testResults += '$message\n';
    });
  }
}
