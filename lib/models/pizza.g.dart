// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pizza.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pizza _$PizzaFromJson(Map<String, dynamic> json) => Pizza(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      restaurant: (json['restaurant'] as num).toInt(),
      image: json['image'] as String?,
      allergens: (json['allergens'] as List<dynamic>)
          .map((e) => Allergen.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PizzaToJson(Pizza instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'restaurant': instance.restaurant,
      'image': instance.image,
      'allergens': instance.allergens,
    };
