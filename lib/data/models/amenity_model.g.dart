// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AmenityImpl _$$AmenityImplFromJson(Map<String, dynamic> json) =>
    _$AmenityImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      capacity: (json['capacity'] as num).toInt(),
      description: json['description'] as String,
      status: $enumDecode(_$AmenityStatusEnumMap, json['status']),
      openHours: json['openHours'] as String?,
      rules: json['rules'] as String?,
    );

Map<String, dynamic> _$$AmenityImplToJson(_$AmenityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'capacity': instance.capacity,
      'description': instance.description,
      'status': _$AmenityStatusEnumMap[instance.status]!,
      'openHours': instance.openHours,
      'rules': instance.rules,
    };

const _$AmenityStatusEnumMap = {
  AmenityStatus.available: 'available',
  AmenityStatus.maintenance: 'maintenance',
};
