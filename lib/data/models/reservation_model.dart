import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

enum ReservationStatus { confirmed, pending, completed, cancelled }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String amenityId,
    required String amenityTitle,
    required String amenityImage,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    required ReservationStatus status,
    String? referenceCode,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}

@freezed
class TimeSlotData with _$TimeSlotData {
  const factory TimeSlotData({
    required String label,
    required bool available,
  }) = _TimeSlotData;

  factory TimeSlotData.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotDataFromJson(json);
}
