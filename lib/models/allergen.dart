import 'package:json_annotation/json_annotation.dart';

part 'allergen.g.dart';

@JsonSerializable()
class Allergen {
  final int id;
  final String name;
  final String code;
  final String? description;

  Allergen({
    required this.id,
    required this.name,
    required this.code,
    this.description,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) =>
      _$AllergenFromJson(json);

  Map<String, dynamic> toJson() => _$AllergenToJson(this);

  //overriding equality to compare allergens
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Allergen && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
