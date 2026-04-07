// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatImpl _$$DashboardStatImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatImpl(
      label: json['label'] as String,
      value: json['value'] as String,
      changeText: json['changeText'] as String,
      isPositive: json['isPositive'] as bool,
      iconAsset: json['iconAsset'] as String,
      iconWidth: (json['iconWidth'] as num).toDouble(),
      iconHeight: (json['iconHeight'] as num).toDouble(),
    );

Map<String, dynamic> _$$DashboardStatImplToJson(_$DashboardStatImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'changeText': instance.changeText,
      'isPositive': instance.isPositive,
      'iconAsset': instance.iconAsset,
      'iconWidth': instance.iconWidth,
      'iconHeight': instance.iconHeight,
    };

_$CollectionDataImpl _$$CollectionDataImplFromJson(Map<String, dynamic> json) =>
    _$CollectionDataImpl(
      month: json['month'] as String,
      collected: (json['collected'] as num).toDouble(),
      projected: (json['projected'] as num).toDouble(),
    );

Map<String, dynamic> _$$CollectionDataImplToJson(
  _$CollectionDataImpl instance,
) => <String, dynamic>{
  'month': instance.month,
  'collected': instance.collected,
  'projected': instance.projected,
};
