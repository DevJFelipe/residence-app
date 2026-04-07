// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      title: json['title'] as String,
      timeAgo: json['timeAgo'] as String,
    );

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'title': instance.title,
      'timeAgo': instance.timeAgo,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.payment: 'payment',
  ActivityType.visitor: 'visitor',
  ActivityType.pqrs: 'pqrs',
  ActivityType.reservation: 'reservation',
  ActivityType.announcement: 'announcement',
};
