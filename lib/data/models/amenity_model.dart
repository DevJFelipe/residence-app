import 'package:freezed_annotation/freezed_annotation.dart';

part 'amenity_model.freezed.dart';
part 'amenity_model.g.dart';

enum AmenityStatus { available, maintenance }

@freezed
class Amenity with _$Amenity {
  const factory Amenity({
    required String id,
    required String title,
    required String image,
    required int capacity,
    required String description,
    required AmenityStatus status,
    String? openHours,
    String? rules,
  }) = _Amenity;

  factory Amenity.fromJson(Map<String, dynamic> json) =>
      _$AmenityFromJson(json);
}
