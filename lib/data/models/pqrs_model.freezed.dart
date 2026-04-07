// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pqrs_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Pqrs _$PqrsFromJson(Map<String, dynamic> json) {
  return _Pqrs.fromJson(json);
}

/// @nodoc
mixin _$Pqrs {
  String get id => throw _privateConstructorUsedError;
  PqrsType get type => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  PqrsStatus get status => throw _privateConstructorUsedError;
  PqrsPriority get priority => throw _privateConstructorUsedError;
  String get unitNumber => throw _privateConstructorUsedError;
  String get residentName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;

  /// Serializes this Pqrs to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pqrs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PqrsCopyWith<Pqrs> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PqrsCopyWith<$Res> {
  factory $PqrsCopyWith(Pqrs value, $Res Function(Pqrs) then) =
      _$PqrsCopyWithImpl<$Res, Pqrs>;
  @useResult
  $Res call({
    String id,
    PqrsType type,
    String subject,
    String description,
    PqrsStatus status,
    PqrsPriority priority,
    String unitNumber,
    String residentName,
    DateTime createdAt,
    DateTime? resolvedAt,
    String? assignedTo,
  });
}

/// @nodoc
class _$PqrsCopyWithImpl<$Res, $Val extends Pqrs>
    implements $PqrsCopyWith<$Res> {
  _$PqrsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pqrs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? subject = null,
    Object? description = null,
    Object? status = null,
    Object? priority = null,
    Object? unitNumber = null,
    Object? residentName = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? assignedTo = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PqrsType,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PqrsStatus,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as PqrsPriority,
            unitNumber: null == unitNumber
                ? _value.unitNumber
                : unitNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            residentName: null == residentName
                ? _value.residentName
                : residentName // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PqrsImplCopyWith<$Res> implements $PqrsCopyWith<$Res> {
  factory _$$PqrsImplCopyWith(
    _$PqrsImpl value,
    $Res Function(_$PqrsImpl) then,
  ) = __$$PqrsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    PqrsType type,
    String subject,
    String description,
    PqrsStatus status,
    PqrsPriority priority,
    String unitNumber,
    String residentName,
    DateTime createdAt,
    DateTime? resolvedAt,
    String? assignedTo,
  });
}

/// @nodoc
class __$$PqrsImplCopyWithImpl<$Res>
    extends _$PqrsCopyWithImpl<$Res, _$PqrsImpl>
    implements _$$PqrsImplCopyWith<$Res> {
  __$$PqrsImplCopyWithImpl(_$PqrsImpl _value, $Res Function(_$PqrsImpl) _then)
    : super(_value, _then);

  /// Create a copy of Pqrs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? subject = null,
    Object? description = null,
    Object? status = null,
    Object? priority = null,
    Object? unitNumber = null,
    Object? residentName = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
    Object? assignedTo = freezed,
  }) {
    return _then(
      _$PqrsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PqrsType,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PqrsStatus,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as PqrsPriority,
        unitNumber: null == unitNumber
            ? _value.unitNumber
            : unitNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        residentName: null == residentName
            ? _value.residentName
            : residentName // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PqrsImpl implements _Pqrs {
  const _$PqrsImpl({
    required this.id,
    required this.type,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.unitNumber,
    required this.residentName,
    required this.createdAt,
    this.resolvedAt,
    this.assignedTo,
  });

  factory _$PqrsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PqrsImplFromJson(json);

  @override
  final String id;
  @override
  final PqrsType type;
  @override
  final String subject;
  @override
  final String description;
  @override
  final PqrsStatus status;
  @override
  final PqrsPriority priority;
  @override
  final String unitNumber;
  @override
  final String residentName;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? assignedTo;

  @override
  String toString() {
    return 'Pqrs(id: $id, type: $type, subject: $subject, description: $description, status: $status, priority: $priority, unitNumber: $unitNumber, residentName: $residentName, createdAt: $createdAt, resolvedAt: $resolvedAt, assignedTo: $assignedTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PqrsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.unitNumber, unitNumber) ||
                other.unitNumber == unitNumber) &&
            (identical(other.residentName, residentName) ||
                other.residentName == residentName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    subject,
    description,
    status,
    priority,
    unitNumber,
    residentName,
    createdAt,
    resolvedAt,
    assignedTo,
  );

  /// Create a copy of Pqrs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PqrsImplCopyWith<_$PqrsImpl> get copyWith =>
      __$$PqrsImplCopyWithImpl<_$PqrsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PqrsImplToJson(this);
  }
}

abstract class _Pqrs implements Pqrs {
  const factory _Pqrs({
    required final String id,
    required final PqrsType type,
    required final String subject,
    required final String description,
    required final PqrsStatus status,
    required final PqrsPriority priority,
    required final String unitNumber,
    required final String residentName,
    required final DateTime createdAt,
    final DateTime? resolvedAt,
    final String? assignedTo,
  }) = _$PqrsImpl;

  factory _Pqrs.fromJson(Map<String, dynamic> json) = _$PqrsImpl.fromJson;

  @override
  String get id;
  @override
  PqrsType get type;
  @override
  String get subject;
  @override
  String get description;
  @override
  PqrsStatus get status;
  @override
  PqrsPriority get priority;
  @override
  String get unitNumber;
  @override
  String get residentName;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;
  @override
  String? get assignedTo;

  /// Create a copy of Pqrs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PqrsImplCopyWith<_$PqrsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
