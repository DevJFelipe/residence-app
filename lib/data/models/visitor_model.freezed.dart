// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visitor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Visitor _$VisitorFromJson(Map<String, dynamic> json) {
  return _Visitor.fromJson(json);
}

/// @nodoc
mixin _$Visitor {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get destinationUnit => throw _privateConstructorUsedError;
  DateTime get entryTime => throw _privateConstructorUsedError;
  DateTime? get exitTime => throw _privateConstructorUsedError;
  VisitorType get type => throw _privateConstructorUsedError;
  VisitorStatus get status => throw _privateConstructorUsedError;
  String? get documentId => throw _privateConstructorUsedError;
  String? get vehiclePlate => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this Visitor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Visitor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitorCopyWith<Visitor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitorCopyWith<$Res> {
  factory $VisitorCopyWith(Visitor value, $Res Function(Visitor) then) =
      _$VisitorCopyWithImpl<$Res, Visitor>;
  @useResult
  $Res call({
    String id,
    String name,
    String destinationUnit,
    DateTime entryTime,
    DateTime? exitTime,
    VisitorType type,
    VisitorStatus status,
    String? documentId,
    String? vehiclePlate,
    String? location,
  });
}

/// @nodoc
class _$VisitorCopyWithImpl<$Res, $Val extends Visitor>
    implements $VisitorCopyWith<$Res> {
  _$VisitorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Visitor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destinationUnit = null,
    Object? entryTime = null,
    Object? exitTime = freezed,
    Object? type = null,
    Object? status = null,
    Object? documentId = freezed,
    Object? vehiclePlate = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            destinationUnit: null == destinationUnit
                ? _value.destinationUnit
                : destinationUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            entryTime: null == entryTime
                ? _value.entryTime
                : entryTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            exitTime: freezed == exitTime
                ? _value.exitTime
                : exitTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as VisitorType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as VisitorStatus,
            documentId: freezed == documentId
                ? _value.documentId
                : documentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehiclePlate: freezed == vehiclePlate
                ? _value.vehiclePlate
                : vehiclePlate // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VisitorImplCopyWith<$Res> implements $VisitorCopyWith<$Res> {
  factory _$$VisitorImplCopyWith(
    _$VisitorImpl value,
    $Res Function(_$VisitorImpl) then,
  ) = __$$VisitorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String destinationUnit,
    DateTime entryTime,
    DateTime? exitTime,
    VisitorType type,
    VisitorStatus status,
    String? documentId,
    String? vehiclePlate,
    String? location,
  });
}

/// @nodoc
class __$$VisitorImplCopyWithImpl<$Res>
    extends _$VisitorCopyWithImpl<$Res, _$VisitorImpl>
    implements _$$VisitorImplCopyWith<$Res> {
  __$$VisitorImplCopyWithImpl(
    _$VisitorImpl _value,
    $Res Function(_$VisitorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Visitor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? destinationUnit = null,
    Object? entryTime = null,
    Object? exitTime = freezed,
    Object? type = null,
    Object? status = null,
    Object? documentId = freezed,
    Object? vehiclePlate = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _$VisitorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        destinationUnit: null == destinationUnit
            ? _value.destinationUnit
            : destinationUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        entryTime: null == entryTime
            ? _value.entryTime
            : entryTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        exitTime: freezed == exitTime
            ? _value.exitTime
            : exitTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as VisitorType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as VisitorStatus,
        documentId: freezed == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehiclePlate: freezed == vehiclePlate
            ? _value.vehiclePlate
            : vehiclePlate // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitorImpl implements _Visitor {
  const _$VisitorImpl({
    required this.id,
    required this.name,
    required this.destinationUnit,
    required this.entryTime,
    this.exitTime,
    required this.type,
    required this.status,
    this.documentId,
    this.vehiclePlate,
    this.location,
  });

  factory _$VisitorImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String destinationUnit;
  @override
  final DateTime entryTime;
  @override
  final DateTime? exitTime;
  @override
  final VisitorType type;
  @override
  final VisitorStatus status;
  @override
  final String? documentId;
  @override
  final String? vehiclePlate;
  @override
  final String? location;

  @override
  String toString() {
    return 'Visitor(id: $id, name: $name, destinationUnit: $destinationUnit, entryTime: $entryTime, exitTime: $exitTime, type: $type, status: $status, documentId: $documentId, vehiclePlate: $vehiclePlate, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.destinationUnit, destinationUnit) ||
                other.destinationUnit == destinationUnit) &&
            (identical(other.entryTime, entryTime) ||
                other.entryTime == entryTime) &&
            (identical(other.exitTime, exitTime) ||
                other.exitTime == exitTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    destinationUnit,
    entryTime,
    exitTime,
    type,
    status,
    documentId,
    vehiclePlate,
    location,
  );

  /// Create a copy of Visitor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitorImplCopyWith<_$VisitorImpl> get copyWith =>
      __$$VisitorImplCopyWithImpl<_$VisitorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitorImplToJson(this);
  }
}

abstract class _Visitor implements Visitor {
  const factory _Visitor({
    required final String id,
    required final String name,
    required final String destinationUnit,
    required final DateTime entryTime,
    final DateTime? exitTime,
    required final VisitorType type,
    required final VisitorStatus status,
    final String? documentId,
    final String? vehiclePlate,
    final String? location,
  }) = _$VisitorImpl;

  factory _Visitor.fromJson(Map<String, dynamic> json) = _$VisitorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get destinationUnit;
  @override
  DateTime get entryTime;
  @override
  DateTime? get exitTime;
  @override
  VisitorType get type;
  @override
  VisitorStatus get status;
  @override
  String? get documentId;
  @override
  String? get vehiclePlate;
  @override
  String? get location;

  /// Create a copy of Visitor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitorImplCopyWith<_$VisitorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OccupancyData _$OccupancyDataFromJson(Map<String, dynamic> json) {
  return _OccupancyData.fromJson(json);
}

/// @nodoc
mixin _$OccupancyData {
  int get current => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;

  /// Serializes this OccupancyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OccupancyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccupancyDataCopyWith<OccupancyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccupancyDataCopyWith<$Res> {
  factory $OccupancyDataCopyWith(
    OccupancyData value,
    $Res Function(OccupancyData) then,
  ) = _$OccupancyDataCopyWithImpl<$Res, OccupancyData>;
  @useResult
  $Res call({int current, int capacity});
}

/// @nodoc
class _$OccupancyDataCopyWithImpl<$Res, $Val extends OccupancyData>
    implements $OccupancyDataCopyWith<$Res> {
  _$OccupancyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OccupancyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? capacity = null}) {
    return _then(
      _value.copyWith(
            current: null == current
                ? _value.current
                : current // ignore: cast_nullable_to_non_nullable
                      as int,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OccupancyDataImplCopyWith<$Res>
    implements $OccupancyDataCopyWith<$Res> {
  factory _$$OccupancyDataImplCopyWith(
    _$OccupancyDataImpl value,
    $Res Function(_$OccupancyDataImpl) then,
  ) = __$$OccupancyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int current, int capacity});
}

/// @nodoc
class __$$OccupancyDataImplCopyWithImpl<$Res>
    extends _$OccupancyDataCopyWithImpl<$Res, _$OccupancyDataImpl>
    implements _$$OccupancyDataImplCopyWith<$Res> {
  __$$OccupancyDataImplCopyWithImpl(
    _$OccupancyDataImpl _value,
    $Res Function(_$OccupancyDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OccupancyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? current = null, Object? capacity = null}) {
    return _then(
      _$OccupancyDataImpl(
        current: null == current
            ? _value.current
            : current // ignore: cast_nullable_to_non_nullable
                  as int,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OccupancyDataImpl implements _OccupancyData {
  const _$OccupancyDataImpl({required this.current, required this.capacity});

  factory _$OccupancyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OccupancyDataImplFromJson(json);

  @override
  final int current;
  @override
  final int capacity;

  @override
  String toString() {
    return 'OccupancyData(current: $current, capacity: $capacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccupancyDataImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, current, capacity);

  /// Create a copy of OccupancyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccupancyDataImplCopyWith<_$OccupancyDataImpl> get copyWith =>
      __$$OccupancyDataImplCopyWithImpl<_$OccupancyDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OccupancyDataImplToJson(this);
  }
}

abstract class _OccupancyData implements OccupancyData {
  const factory _OccupancyData({
    required final int current,
    required final int capacity,
  }) = _$OccupancyDataImpl;

  factory _OccupancyData.fromJson(Map<String, dynamic> json) =
      _$OccupancyDataImpl.fromJson;

  @override
  int get current;
  @override
  int get capacity;

  /// Create a copy of OccupancyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccupancyDataImplCopyWith<_$OccupancyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
