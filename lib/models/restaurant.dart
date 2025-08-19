import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String? description;
  final String status;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.description,
    required this.status,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // Handle potential null values safely
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown Restaurant',
      address: json['address'] as String? ?? 'No address provided',
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
