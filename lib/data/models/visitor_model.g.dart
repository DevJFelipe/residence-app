// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitorImpl _$$VisitorImplFromJson(Map<String, dynamic> json) =>
    _$VisitorImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      destinationUnit: json['destinationUnit'] as String,
      entryTime: DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] == null
          ? null
          : DateTime.parse(json['exitTime'] as String),
      type: $enumDecode(_$VisitorTypeEnumMap, json['type']),
      status: $enumDecode(_$VisitorStatusEnumMap, json['status']),
      documentId: json['documentId'] as String?,
      vehiclePlate: json['vehiclePlate'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$VisitorImplToJson(_$VisitorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'destinationUnit': instance.destinationUnit,
      'entryTime': instance.entryTime.toIso8601String(),
      'exitTime': instance.exitTime?.toIso8601String(),
      'type': _$VisitorTypeEnumMap[instance.type]!,
      'status': _$VisitorStatusEnumMap[instance.status]!,
      'documentId': instance.documentId,
      'vehiclePlate': instance.vehiclePlate,
      'location': instance.location,
    };

const _$VisitorTypeEnumMap = {
  VisitorType.personal: 'personal',
  VisitorType.familiar: 'familiar',
  VisitorType.delivery: 'delivery',
  VisitorType.service: 'service',
};

const _$VisitorStatusEnumMap = {
  VisitorStatus.active: 'active',
  VisitorStatus.exited: 'exited',
};

_$OccupancyDataImpl _$$OccupancyDataImplFromJson(Map<String, dynamic> json) =>
    _$OccupancyDataImpl(
      current: (json['current'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
    );

Map<String, dynamic> _$$OccupancyDataImplToJson(_$OccupancyDataImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'capacity': instance.capacity,
    };
