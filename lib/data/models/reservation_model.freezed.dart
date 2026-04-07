// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Reservation _$ReservationFromJson(Map<String, dynamic> json) {
  return _Reservation.fromJson(json);
}

/// @nodoc
mixin _$Reservation {
  String get id => throw _privateConstructorUsedError;
  String get amenityId => throw _privateConstructorUsedError;
  String get amenityTitle => throw _privateConstructorUsedError;
  String get amenityImage => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get timeSlot => throw _privateConstructorUsedError;
  int get guestCount => throw _privateConstructorUsedError;
  ReservationStatus get status => throw _privateConstructorUsedError;
  String? get referenceCode => throw _privateConstructorUsedError;

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationCopyWith<Reservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationCopyWith<$Res> {
  factory $ReservationCopyWith(
    Reservation value,
    $Res Function(Reservation) then,
  ) = _$ReservationCopyWithImpl<$Res, Reservation>;
  @useResult
  $Res call({
    String id,
    String amenityId,
    String amenityTitle,
    String amenityImage,
    DateTime date,
    String timeSlot,
    int guestCount,
    ReservationStatus status,
    String? referenceCode,
  });
}

/// @nodoc
class _$ReservationCopyWithImpl<$Res, $Val extends Reservation>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amenityId = null,
    Object? amenityTitle = null,
    Object? amenityImage = null,
    Object? date = null,
    Object? timeSlot = null,
    Object? guestCount = null,
    Object? status = null,
    Object? referenceCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            amenityId: null == amenityId
                ? _value.amenityId
                : amenityId // ignore: cast_nullable_to_non_nullable
                      as String,
            amenityTitle: null == amenityTitle
                ? _value.amenityTitle
                : amenityTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            amenityImage: null == amenityImage
                ? _value.amenityImage
                : amenityImage // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timeSlot: null == timeSlot
                ? _value.timeSlot
                : timeSlot // ignore: cast_nullable_to_non_nullable
                      as String,
            guestCount: null == guestCount
                ? _value.guestCount
                : guestCount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ReservationStatus,
            referenceCode: freezed == referenceCode
                ? _value.referenceCode
                : referenceCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservationImplCopyWith<$Res>
    implements $ReservationCopyWith<$Res> {
  factory _$$ReservationImplCopyWith(
    _$ReservationImpl value,
    $Res Function(_$ReservationImpl) then,
  ) = __$$ReservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String amenityId,
    String amenityTitle,
    String amenityImage,
    DateTime date,
    String timeSlot,
    int guestCount,
    ReservationStatus status,
    String? referenceCode,
  });
}

/// @nodoc
class __$$ReservationImplCopyWithImpl<$Res>
    extends _$ReservationCopyWithImpl<$Res, _$ReservationImpl>
    implements _$$ReservationImplCopyWith<$Res> {
  __$$ReservationImplCopyWithImpl(
    _$ReservationImpl _value,
    $Res Function(_$ReservationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amenityId = null,
    Object? amenityTitle = null,
    Object? amenityImage = null,
    Object? date = null,
    Object? timeSlot = null,
    Object? guestCount = null,
    Object? status = null,
    Object? referenceCode = freezed,
  }) {
    return _then(
      _$ReservationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        amenityId: null == amenityId
            ? _value.amenityId
            : amenityId // ignore: cast_nullable_to_non_nullable
                  as String,
        amenityTitle: null == amenityTitle
            ? _value.amenityTitle
            : amenityTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        amenityImage: null == amenityImage
            ? _value.amenityImage
            : amenityImage // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timeSlot: null == timeSlot
            ? _value.timeSlot
            : timeSlot // ignore: cast_nullable_to_non_nullable
                  as String,
        guestCount: null == guestCount
            ? _value.guestCount
            : guestCount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReservationStatus,
        referenceCode: freezed == referenceCode
            ? _value.referenceCode
            : referenceCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationImpl implements _Reservation {
  const _$ReservationImpl({
    required this.id,
    required this.amenityId,
    required this.amenityTitle,
    required this.amenityImage,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.status,
    this.referenceCode,
  });

  factory _$ReservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationImplFromJson(json);

  @override
  final String id;
  @override
  final String amenityId;
  @override
  final String amenityTitle;
  @override
  final String amenityImage;
  @override
  final DateTime date;
  @override
  final String timeSlot;
  @override
  final int guestCount;
  @override
  final ReservationStatus status;
  @override
  final String? referenceCode;

  @override
  String toString() {
    return 'Reservation(id: $id, amenityId: $amenityId, amenityTitle: $amenityTitle, amenityImage: $amenityImage, date: $date, timeSlot: $timeSlot, guestCount: $guestCount, status: $status, referenceCode: $referenceCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amenityId, amenityId) ||
                other.amenityId == amenityId) &&
            (identical(other.amenityTitle, amenityTitle) ||
                other.amenityTitle == amenityTitle) &&
            (identical(other.amenityImage, amenityImage) ||
                other.amenityImage == amenityImage) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timeSlot, timeSlot) ||
                other.timeSlot == timeSlot) &&
            (identical(other.guestCount, guestCount) ||
                other.guestCount == guestCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.referenceCode, referenceCode) ||
                other.referenceCode == referenceCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    amenityId,
    amenityTitle,
    amenityImage,
    date,
    timeSlot,
    guestCount,
    status,
    referenceCode,
  );

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationImplCopyWith<_$ReservationImpl> get copyWith =>
      __$$ReservationImplCopyWithImpl<_$ReservationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationImplToJson(this);
  }
}

abstract class _Reservation implements Reservation {
  const factory _Reservation({
    required final String id,
    required final String amenityId,
    required final String amenityTitle,
    required final String amenityImage,
    required final DateTime date,
    required final String timeSlot,
    required final int guestCount,
    required final ReservationStatus status,
    final String? referenceCode,
  }) = _$ReservationImpl;

  factory _Reservation.fromJson(Map<String, dynamic> json) =
      _$ReservationImpl.fromJson;

  @override
  String get id;
  @override
  String get amenityId;
  @override
  String get amenityTitle;
  @override
  String get amenityImage;
  @override
  DateTime get date;
  @override
  String get timeSlot;
  @override
  int get guestCount;
  @override
  ReservationStatus get status;
  @override
  String? get referenceCode;

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationImplCopyWith<_$ReservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSlotData _$TimeSlotDataFromJson(Map<String, dynamic> json) {
  return _TimeSlotData.fromJson(json);
}

/// @nodoc
mixin _$TimeSlotData {
  String get label => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;

  /// Serializes this TimeSlotData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotDataCopyWith<TimeSlotData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotDataCopyWith<$Res> {
  factory $TimeSlotDataCopyWith(
    TimeSlotData value,
    $Res Function(TimeSlotData) then,
  ) = _$TimeSlotDataCopyWithImpl<$Res, TimeSlotData>;
  @useResult
  $Res call({String label, bool available});
}

/// @nodoc
class _$TimeSlotDataCopyWithImpl<$Res, $Val extends TimeSlotData>
    implements $TimeSlotDataCopyWith<$Res> {
  _$TimeSlotDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? available = null}) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeSlotDataImplCopyWith<$Res>
    implements $TimeSlotDataCopyWith<$Res> {
  factory _$$TimeSlotDataImplCopyWith(
    _$TimeSlotDataImpl value,
    $Res Function(_$TimeSlotDataImpl) then,
  ) = __$$TimeSlotDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, bool available});
}

/// @nodoc
class __$$TimeSlotDataImplCopyWithImpl<$Res>
    extends _$TimeSlotDataCopyWithImpl<$Res, _$TimeSlotDataImpl>
    implements _$$TimeSlotDataImplCopyWith<$Res> {
  __$$TimeSlotDataImplCopyWithImpl(
    _$TimeSlotDataImpl _value,
    $Res Function(_$TimeSlotDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeSlotData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? available = null}) {
    return _then(
      _$TimeSlotDataImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotDataImpl implements _TimeSlotData {
  const _$TimeSlotDataImpl({required this.label, required this.available});

  factory _$TimeSlotDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotDataImplFromJson(json);

  @override
  final String label;
  @override
  final bool available;

  @override
  String toString() {
    return 'TimeSlotData(label: $label, available: $available)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotDataImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, available);

  /// Create a copy of TimeSlotData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotDataImplCopyWith<_$TimeSlotDataImpl> get copyWith =>
      __$$TimeSlotDataImplCopyWithImpl<_$TimeSlotDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotDataImplToJson(this);
  }
}

abstract class _TimeSlotData implements TimeSlotData {
  const factory _TimeSlotData({
    required final String label,
    required final bool available,
  }) = _$TimeSlotDataImpl;

  factory _TimeSlotData.fromJson(Map<String, dynamic> json) =
      _$TimeSlotDataImpl.fromJson;

  @override
  String get label;
  @override
  bool get available;

  /// Create a copy of TimeSlotData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotDataImplCopyWith<_$TimeSlotDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
