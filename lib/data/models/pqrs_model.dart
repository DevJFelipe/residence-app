import 'package:freezed_annotation/freezed_annotation.dart';

part 'pqrs_model.freezed.dart';
part 'pqrs_model.g.dart';

enum PqrsType { petition, complaint, claim, suggestion }

enum PqrsStatus { open, inProgress, resolved, closed }

enum PqrsPriority { low, medium, high }

@freezed
class Pqrs with _$Pqrs {
  const factory Pqrs({
    required String id,
    required PqrsType type,
    required String subject,
    required String description,
    required PqrsStatus status,
    required PqrsPriority priority,
    required String unitNumber,
    required String residentName,
    required DateTime createdAt,
    DateTime? resolvedAt,
    String? assignedTo,
  }) = _Pqrs;

  factory Pqrs.fromJson(Map<String, dynamic> json) => _$PqrsFromJson(json);
}
