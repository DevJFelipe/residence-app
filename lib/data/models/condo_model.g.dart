// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CondoImpl _$$CondoImplFromJson(Map<String, dynamic> json) => _$CondoImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  imageUrl: json['imageUrl'] as String,
  towers: (json['towers'] as num).toInt(),
  units: (json['units'] as num).toInt(),
  stratum: (json['stratum'] as num).toInt(),
  area: (json['area'] as num).toDouble(),
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  officeHours: json['officeHours'] as String?,
);

Map<String, dynamic> _$$CondoImplToJson(_$CondoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'imageUrl': instance.imageUrl,
      'towers': instance.towers,
      'units': instance.units,
      'stratum': instance.stratum,
      'area': instance.area,
      'phone': instance.phone,
      'email': instance.email,
      'officeHours': instance.officeHours,
    };

_$CondoNewsImpl _$$CondoNewsImplFromJson(Map<String, dynamic> json) =>
    _$CondoNewsImpl(
      id: json['id'] as String,
      tag: json['tag'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timeAgo: json['timeAgo'] as String,
    );

Map<String, dynamic> _$$CondoNewsImplToJson(_$CondoNewsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'title': instance.title,
      'description': instance.description,
      'timeAgo': instance.timeAgo,
    };
