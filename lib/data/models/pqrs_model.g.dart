// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pqrs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PqrsImpl _$$PqrsImplFromJson(Map<String, dynamic> json) => _$PqrsImpl(
  id: json['id'] as String,
  type: $enumDecode(_$PqrsTypeEnumMap, json['type']),
  subject: json['subject'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$PqrsStatusEnumMap, json['status']),
  priority: $enumDecode(_$PqrsPriorityEnumMap, json['priority']),
  unitNumber: json['unitNumber'] as String,
  residentName: json['residentName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
  assignedTo: json['assignedTo'] as String?,
);

Map<String, dynamic> _$$PqrsImplToJson(_$PqrsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PqrsTypeEnumMap[instance.type]!,
      'subject': instance.subject,
      'description': instance.description,
      'status': _$PqrsStatusEnumMap[instance.status]!,
      'priority': _$PqrsPriorityEnumMap[instance.priority]!,
      'unitNumber': instance.unitNumber,
      'residentName': instance.residentName,
      'createdAt': instance.createdAt.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'assignedTo': instance.assignedTo,
    };

const _$PqrsTypeEnumMap = {
  PqrsType.petition: 'petition',
  PqrsType.complaint: 'complaint',
  PqrsType.claim: 'claim',
  PqrsType.suggestion: 'suggestion',
};

const _$PqrsStatusEnumMap = {
  PqrsStatus.open: 'open',
  PqrsStatus.inProgress: 'inProgress',
  PqrsStatus.resolved: 'resolved',
  PqrsStatus.closed: 'closed',
};

const _$PqrsPriorityEnumMap = {
  PqrsPriority.low: 'low',
  PqrsPriority.medium: 'medium',
  PqrsPriority.high: 'high',
};
