import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stat_model.freezed.dart';
part 'dashboard_stat_model.g.dart';

@freezed
class DashboardStat with _$DashboardStat {
  const factory DashboardStat({
    required String label,
    required String value,
    required String changeText,
    required bool isPositive,
    required String iconAsset,
    required double iconWidth,
    required double iconHeight,
  }) = _DashboardStat;

  factory DashboardStat.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatFromJson(json);
}

@freezed
class CollectionData with _$CollectionData {
  const factory CollectionData({
    required String month,
    required double collected,
    required double projected,
  }) = _CollectionData;

  factory CollectionData.fromJson(Map<String, dynamic> json) =>
      _$CollectionDataFromJson(json);
}
