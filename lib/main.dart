import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/restaurant_list_screen.dart';
import 'providers/restaurant_provider.dart';
import 'providers/pizza_provider.dart';
import 'providers/allergen_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'widgets/directus_test_widget.dart'; // Fixed: removed '../'

void main() {
  runApp(const GearPizzaApp());
}

class GearPizzaApp extends StatelessWidget {
  const GearPizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => PizzaProvider()),
        ChangeNotifierProvider(create: (_) => AllergenProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'GearPizza',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: const Color.fromARGB(255, 200, 45, 45),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red,
            backgroundColor: const Color.fromARGB(255, 252, 248, 240),
          ).copyWith(
            secondary: const Color.fromARGB(255, 255, 140, 25),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 252, 248, 240),

          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 200, 45, 45),
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
          ),

          //card theme
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            color: Colors.white,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 200, 45, 45),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 65, 65, 65),
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 65, 65, 65),
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 65, 65, 65),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 95, 95, 95),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 115, 115, 115),
            ),
          ),
        ),
        home: const RestaurantListScreen(),
        //home: const DirectusTestWidget(), // Available for testing
      ),
    );
  }
}
