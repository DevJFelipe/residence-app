// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStat _$DashboardStatFromJson(Map<String, dynamic> json) {
  return _DashboardStat.fromJson(json);
}

/// @nodoc
mixin _$DashboardStat {
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get changeText => throw _privateConstructorUsedError;
  bool get isPositive => throw _privateConstructorUsedError;
  String get iconAsset => throw _privateConstructorUsedError;
  double get iconWidth => throw _privateConstructorUsedError;
  double get iconHeight => throw _privateConstructorUsedError;

  /// Serializes this DashboardStat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatCopyWith<DashboardStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatCopyWith<$Res> {
  factory $DashboardStatCopyWith(
    DashboardStat value,
    $Res Function(DashboardStat) then,
  ) = _$DashboardStatCopyWithImpl<$Res, DashboardStat>;
  @useResult
  $Res call({
    String label,
    String value,
    String changeText,
    bool isPositive,
    String iconAsset,
    double iconWidth,
    double iconHeight,
  });
}

/// @nodoc
class _$DashboardStatCopyWithImpl<$Res, $Val extends DashboardStat>
    implements $DashboardStatCopyWith<$Res> {
  _$DashboardStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? changeText = null,
    Object? isPositive = null,
    Object? iconAsset = null,
    Object? iconWidth = null,
    Object? iconHeight = null,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            changeText: null == changeText
                ? _value.changeText
                : changeText // ignore: cast_nullable_to_non_nullable
                      as String,
            isPositive: null == isPositive
                ? _value.isPositive
                : isPositive // ignore: cast_nullable_to_non_nullable
                      as bool,
            iconAsset: null == iconAsset
                ? _value.iconAsset
                : iconAsset // ignore: cast_nullable_to_non_nullable
                      as String,
            iconWidth: null == iconWidth
                ? _value.iconWidth
                : iconWidth // ignore: cast_nullable_to_non_nullable
                      as double,
            iconHeight: null == iconHeight
                ? _value.iconHeight
                : iconHeight // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatImplCopyWith<$Res>
    implements $DashboardStatCopyWith<$Res> {
  factory _$$DashboardStatImplCopyWith(
    _$DashboardStatImpl value,
    $Res Function(_$DashboardStatImpl) then,
  ) = __$$DashboardStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    String value,
    String changeText,
    bool isPositive,
    String iconAsset,
    double iconWidth,
    double iconHeight,
  });
}

/// @nodoc
class __$$DashboardStatImplCopyWithImpl<$Res>
    extends _$DashboardStatCopyWithImpl<$Res, _$DashboardStatImpl>
    implements _$$DashboardStatImplCopyWith<$Res> {
  __$$DashboardStatImplCopyWithImpl(
    _$DashboardStatImpl _value,
    $Res Function(_$DashboardStatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? changeText = null,
    Object? isPositive = null,
    Object? iconAsset = null,
    Object? iconWidth = null,
    Object? iconHeight = null,
  }) {
    return _then(
      _$DashboardStatImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        changeText: null == changeText
            ? _value.changeText
            : changeText // ignore: cast_nullable_to_non_nullable
                  as String,
        isPositive: null == isPositive
            ? _value.isPositive
            : isPositive // ignore: cast_nullable_to_non_nullable
                  as bool,
        iconAsset: null == iconAsset
            ? _value.iconAsset
            : iconAsset // ignore: cast_nullable_to_non_nullable
                  as String,
        iconWidth: null == iconWidth
            ? _value.iconWidth
            : iconWidth // ignore: cast_nullable_to_non_nullable
                  as double,
        iconHeight: null == iconHeight
            ? _value.iconHeight
            : iconHeight // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatImpl implements _DashboardStat {
  const _$DashboardStatImpl({
    required this.label,
    required this.value,
    required this.changeText,
    required this.isPositive,
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
  });

  factory _$DashboardStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatImplFromJson(json);

  @override
  final String label;
  @override
  final String value;
  @override
  final String changeText;
  @override
  final bool isPositive;
  @override
  final String iconAsset;
  @override
  final double iconWidth;
  @override
  final double iconHeight;

  @override
  String toString() {
    return 'DashboardStat(label: $label, value: $value, changeText: $changeText, isPositive: $isPositive, iconAsset: $iconAsset, iconWidth: $iconWidth, iconHeight: $iconHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.changeText, changeText) ||
                other.changeText == changeText) &&
            (identical(other.isPositive, isPositive) ||
                other.isPositive == isPositive) &&
            (identical(other.iconAsset, iconAsset) ||
                other.iconAsset == iconAsset) &&
            (identical(other.iconWidth, iconWidth) ||
                other.iconWidth == iconWidth) &&
            (identical(other.iconHeight, iconHeight) ||
                other.iconHeight == iconHeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    label,
    value,
    changeText,
    isPositive,
    iconAsset,
    iconWidth,
    iconHeight,
  );

  /// Create a copy of DashboardStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatImplCopyWith<_$DashboardStatImpl> get copyWith =>
      __$$DashboardStatImplCopyWithImpl<_$DashboardStatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatImplToJson(this);
  }
}

abstract class _DashboardStat implements DashboardStat {
  const factory _DashboardStat({
    required final String label,
    required final String value,
    required final String changeText,
    required final bool isPositive,
    required final String iconAsset,
    required final double iconWidth,
    required final double iconHeight,
  }) = _$DashboardStatImpl;

  factory _DashboardStat.fromJson(Map<String, dynamic> json) =
      _$DashboardStatImpl.fromJson;

  @override
  String get label;
  @override
  String get value;
  @override
  String get changeText;
  @override
  bool get isPositive;
  @override
  String get iconAsset;
  @override
  double get iconWidth;
  @override
  double get iconHeight;

  /// Create a copy of DashboardStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatImplCopyWith<_$DashboardStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CollectionData _$CollectionDataFromJson(Map<String, dynamic> json) {
  return _CollectionData.fromJson(json);
}

/// @nodoc
mixin _$CollectionData {
  String get month => throw _privateConstructorUsedError;
  double get collected => throw _privateConstructorUsedError;
  double get projected => throw _privateConstructorUsedError;

  /// Serializes this CollectionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CollectionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectionDataCopyWith<CollectionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionDataCopyWith<$Res> {
  factory $CollectionDataCopyWith(
    CollectionData value,
    $Res Function(CollectionData) then,
  ) = _$CollectionDataCopyWithImpl<$Res, CollectionData>;
  @useResult
  $Res call({String month, double collected, double projected});
}

/// @nodoc
class _$CollectionDataCopyWithImpl<$Res, $Val extends CollectionData>
    implements $CollectionDataCopyWith<$Res> {
  _$CollectionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollectionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? collected = null,
    Object? projected = null,
  }) {
    return _then(
      _value.copyWith(
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as String,
            collected: null == collected
                ? _value.collected
                : collected // ignore: cast_nullable_to_non_nullable
                      as double,
            projected: null == projected
                ? _value.projected
                : projected // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CollectionDataImplCopyWith<$Res>
    implements $CollectionDataCopyWith<$Res> {
  factory _$$CollectionDataImplCopyWith(
    _$CollectionDataImpl value,
    $Res Function(_$CollectionDataImpl) then,
  ) = __$$CollectionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String month, double collected, double projected});
}

/// @nodoc
class __$$CollectionDataImplCopyWithImpl<$Res>
    extends _$CollectionDataCopyWithImpl<$Res, _$CollectionDataImpl>
    implements _$$CollectionDataImplCopyWith<$Res> {
  __$$CollectionDataImplCopyWithImpl(
    _$CollectionDataImpl _value,
    $Res Function(_$CollectionDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CollectionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? collected = null,
    Object? projected = null,
  }) {
    return _then(
      _$CollectionDataImpl(
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as String,
        collected: null == collected
            ? _value.collected
            : collected // ignore: cast_nullable_to_non_nullable
                  as double,
        projected: null == projected
            ? _value.projected
            : projected // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionDataImpl implements _CollectionData {
  const _$CollectionDataImpl({
    required this.month,
    required this.collected,
    required this.projected,
  });

  factory _$CollectionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionDataImplFromJson(json);

  @override
  final String month;
  @override
  final double collected;
  @override
  final double projected;

  @override
  String toString() {
    return 'CollectionData(month: $month, collected: $collected, projected: $projected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionDataImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.collected, collected) ||
                other.collected == collected) &&
            (identical(other.projected, projected) ||
                other.projected == projected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, month, collected, projected);

  /// Create a copy of CollectionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionDataImplCopyWith<_$CollectionDataImpl> get copyWith =>
      __$$CollectionDataImplCopyWithImpl<_$CollectionDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionDataImplToJson(this);
  }
}

abstract class _CollectionData implements CollectionData {
  const factory _CollectionData({
    required final String month,
    required final double collected,
    required final double projected,
  }) = _$CollectionDataImpl;

  factory _CollectionData.fromJson(Map<String, dynamic> json) =
      _$CollectionDataImpl.fromJson;

  @override
  String get month;
  @override
  double get collected;
  @override
  double get projected;

  /// Create a copy of CollectionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectionDataImplCopyWith<_$CollectionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
