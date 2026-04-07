import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

enum ActivityType { payment, visitor, pqrs, reservation, announcement }

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required ActivityType type,
    required String title,
    required String timeAgo,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
