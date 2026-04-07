import 'package:freezed_annotation/freezed_annotation.dart';

part 'visitor_model.freezed.dart';
part 'visitor_model.g.dart';

enum VisitorType { personal, familiar, delivery, service }

enum VisitorStatus { active, exited }

@freezed
class Visitor with _$Visitor {
  const factory Visitor({
    required String id,
    required String name,
    required String destinationUnit,
    required DateTime entryTime,
    DateTime? exitTime,
    required VisitorType type,
    required VisitorStatus status,
    String? documentId,
    String? vehiclePlate,
    String? location,
  }) = _Visitor;

  factory Visitor.fromJson(Map<String, dynamic> json) =>
      _$VisitorFromJson(json);
}

@freezed
class OccupancyData with _$OccupancyData {
  const factory OccupancyData({
    required int current,
    required int capacity,
  }) = _OccupancyData;

  factory OccupancyData.fromJson(Map<String, dynamic> json) =>
      _$OccupancyDataFromJson(json);
}
