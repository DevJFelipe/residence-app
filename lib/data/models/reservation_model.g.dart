// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) =>
    _$ReservationImpl(
      id: json['id'] as String,
      amenityId: json['amenityId'] as String,
      amenityTitle: json['amenityTitle'] as String,
      amenityImage: json['amenityImage'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: json['timeSlot'] as String,
      guestCount: (json['guestCount'] as num).toInt(),
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
      referenceCode: json['referenceCode'] as String?,
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amenityId': instance.amenityId,
      'amenityTitle': instance.amenityTitle,
      'amenityImage': instance.amenityImage,
      'date': instance.date.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'guestCount': instance.guestCount,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'referenceCode': instance.referenceCode,
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.pending: 'pending',
  ReservationStatus.completed: 'completed',
  ReservationStatus.cancelled: 'cancelled',
};

_$TimeSlotDataImpl _$$TimeSlotDataImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotDataImpl(
      label: json['label'] as String,
      available: json['available'] as bool,
    );

Map<String, dynamic> _$$TimeSlotDataImplToJson(_$TimeSlotDataImpl instance) =>
    <String, dynamic>{'label': instance.label, 'available': instance.available};
