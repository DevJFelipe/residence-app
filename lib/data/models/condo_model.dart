import 'package:freezed_annotation/freezed_annotation.dart';

part 'condo_model.freezed.dart';
part 'condo_model.g.dart';

@freezed
class Condo with _$Condo {
  const factory Condo({
    required String id,
    required String name,
    required String address,
    required String city,
    required String imageUrl,
    required int towers,
    required int units,
    required int stratum,
    required double area,
    String? phone,
    String? email,
    String? officeHours,
  }) = _Condo;

  factory Condo.fromJson(Map<String, dynamic> json) => _$CondoFromJson(json);
}

@freezed
class CondoNews with _$CondoNews {
  const factory CondoNews({
    required String id,
    required String tag,
    required String title,
    required String description,
    required String timeAgo,
  }) = _CondoNews;

  factory CondoNews.fromJson(Map<String, dynamic> json) =>
      _$CondoNewsFromJson(json);
}
