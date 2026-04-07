// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      unitNumber: json['unitNumber'] as String,
      residentName: json['residentName'] as String,
      residentInitials: json['residentInitials'] as String,
      concept: json['concept'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: $enumDecode(_$InvoiceStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unitNumber': instance.unitNumber,
      'residentName': instance.residentName,
      'residentInitials': instance.residentInitials,
      'concept': instance.concept,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$InvoiceStatusEnumMap[instance.status]!,
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.pending: 'pending',
  InvoiceStatus.overdue: 'overdue',
};

_$BillingSummaryImpl _$$BillingSummaryImplFromJson(Map<String, dynamic> json) =>
    _$BillingSummaryImpl(
      totalBilled: (json['totalBilled'] as num).toDouble(),
      totalCollected: (json['totalCollected'] as num).toDouble(),
      totalPending: (json['totalPending'] as num).toDouble(),
      collectionRate: (json['collectionRate'] as num).toDouble(),
      period: json['period'] as String,
    );

Map<String, dynamic> _$$BillingSummaryImplToJson(
  _$BillingSummaryImpl instance,
) => <String, dynamic>{
  'totalBilled': instance.totalBilled,
  'totalCollected': instance.totalCollected,
  'totalPending': instance.totalPending,
  'collectionRate': instance.collectionRate,
  'period': instance.period,
};
