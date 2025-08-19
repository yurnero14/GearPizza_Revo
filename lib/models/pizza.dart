import 'package:json_annotation/json_annotation.dart';
import 'allergen.dart';

part 'pizza.g.dart';

@JsonSerializable()
class Pizza {
  final int id;
  final String name;
  final String description;
  final double price;
  final int restaurant;
  final String? image;
  final List<Allergen> allergens;

  Pizza(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.restaurant,
      this.image,
      required this.allergens});

  factory Pizza.fromJson(Map<String, dynamic> json) => _$PizzaFromJson(json);

  Map<String, dynamic> toJson() => _$PizzaToJson(this);

  //helper method to check if pizza contains any excluded allergens
  bool containsAllergens(List<Allergen> excludedAllergens) {
    return allergens.any((allergen) => excludedAllergens.contains(allergen));
  }

  // method to get allergen names as comma-separated string
  String get allergenNames {
    if (allergens.isEmpty) return 'No known allergens';
    return allergens.map((a) => a.name).join(', ');
  }

  //get formatted price
  String get formattedPrice {
    return '€${price.toStringAsFixed(2)}';
  }

  String? getImageUrl(String baseUrl) {
    if (image == null) return null;
    return '$baseUrl/files/$image';
  }
}
