// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  String get id => throw _privateConstructorUsedError;
  String get unitNumber => throw _privateConstructorUsedError;
  String get residentName => throw _privateConstructorUsedError;
  String get residentInitials => throw _privateConstructorUsedError;
  String get concept => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  InvoiceStatus get status => throw _privateConstructorUsedError;

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call({
    String id,
    String unitNumber,
    String residentName,
    String residentInitials,
    String concept,
    double amount,
    DateTime dueDate,
    InvoiceStatus status,
  });
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitNumber = null,
    Object? residentName = null,
    Object? residentInitials = null,
    Object? concept = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            unitNumber: null == unitNumber
                ? _value.unitNumber
                : unitNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            residentName: null == residentName
                ? _value.residentName
                : residentName // ignore: cast_nullable_to_non_nullable
                      as String,
            residentInitials: null == residentInitials
                ? _value.residentInitials
                : residentInitials // ignore: cast_nullable_to_non_nullable
                      as String,
            concept: null == concept
                ? _value.concept
                : concept // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as InvoiceStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
    _$InvoiceImpl value,
    $Res Function(_$InvoiceImpl) then,
  ) = __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String unitNumber,
    String residentName,
    String residentInitials,
    String concept,
    double amount,
    DateTime dueDate,
    InvoiceStatus status,
  });
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
    _$InvoiceImpl _value,
    $Res Function(_$InvoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitNumber = null,
    Object? residentName = null,
    Object? residentInitials = null,
    Object? concept = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? status = null,
  }) {
    return _then(
      _$InvoiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        unitNumber: null == unitNumber
            ? _value.unitNumber
            : unitNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        residentName: null == residentName
            ? _value.residentName
            : residentName // ignore: cast_nullable_to_non_nullable
                  as String,
        residentInitials: null == residentInitials
            ? _value.residentInitials
            : residentInitials // ignore: cast_nullable_to_non_nullable
                  as String,
        concept: null == concept
            ? _value.concept
            : concept // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as InvoiceStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl({
    required this.id,
    required this.unitNumber,
    required this.residentName,
    required this.residentInitials,
    required this.concept,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  final String id;
  @override
  final String unitNumber;
  @override
  final String residentName;
  @override
  final String residentInitials;
  @override
  final String concept;
  @override
  final double amount;
  @override
  final DateTime dueDate;
  @override
  final InvoiceStatus status;

  @override
  String toString() {
    return 'Invoice(id: $id, unitNumber: $unitNumber, residentName: $residentName, residentInitials: $residentInitials, concept: $concept, amount: $amount, dueDate: $dueDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.unitNumber, unitNumber) ||
                other.unitNumber == unitNumber) &&
            (identical(other.residentName, residentName) ||
                other.residentName == residentName) &&
            (identical(other.residentInitials, residentInitials) ||
                other.residentInitials == residentInitials) &&
            (identical(other.concept, concept) || other.concept == concept) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    unitNumber,
    residentName,
    residentInitials,
    concept,
    amount,
    dueDate,
    status,
  );

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(this);
  }
}

abstract class _Invoice implements Invoice {
  const factory _Invoice({
    required final String id,
    required final String unitNumber,
    required final String residentName,
    required final String residentInitials,
    required final String concept,
    required final double amount,
    required final DateTime dueDate,
    required final InvoiceStatus status,
  }) = _$InvoiceImpl;

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  String get id;
  @override
  String get unitNumber;
  @override
  String get residentName;
  @override
  String get residentInitials;
  @override
  String get concept;
  @override
  double get amount;
  @override
  DateTime get dueDate;
  @override
  InvoiceStatus get status;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillingSummary _$BillingSummaryFromJson(Map<String, dynamic> json) {
  return _BillingSummary.fromJson(json);
}

/// @nodoc
mixin _$BillingSummary {
  double get totalBilled => throw _privateConstructorUsedError;
  double get totalCollected => throw _privateConstructorUsedError;
  double get totalPending => throw _privateConstructorUsedError;
  double get collectionRate => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;

  /// Serializes this BillingSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingSummaryCopyWith<BillingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingSummaryCopyWith<$Res> {
  factory $BillingSummaryCopyWith(
    BillingSummary value,
    $Res Function(BillingSummary) then,
  ) = _$BillingSummaryCopyWithImpl<$Res, BillingSummary>;
  @useResult
  $Res call({
    double totalBilled,
    double totalCollected,
    double totalPending,
    double collectionRate,
    String period,
  });
}

/// @nodoc
class _$BillingSummaryCopyWithImpl<$Res, $Val extends BillingSummary>
    implements $BillingSummaryCopyWith<$Res> {
  _$BillingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBilled = null,
    Object? totalCollected = null,
    Object? totalPending = null,
    Object? collectionRate = null,
    Object? period = null,
  }) {
    return _then(
      _value.copyWith(
            totalBilled: null == totalBilled
                ? _value.totalBilled
                : totalBilled // ignore: cast_nullable_to_non_nullable
                      as double,
            totalCollected: null == totalCollected
                ? _value.totalCollected
                : totalCollected // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPending: null == totalPending
                ? _value.totalPending
                : totalPending // ignore: cast_nullable_to_non_nullable
                      as double,
            collectionRate: null == collectionRate
                ? _value.collectionRate
                : collectionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingSummaryImplCopyWith<$Res>
    implements $BillingSummaryCopyWith<$Res> {
  factory _$$BillingSummaryImplCopyWith(
    _$BillingSummaryImpl value,
    $Res Function(_$BillingSummaryImpl) then,
  ) = __$$BillingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalBilled,
    double totalCollected,
    double totalPending,
    double collectionRate,
    String period,
  });
}

/// @nodoc
class __$$BillingSummaryImplCopyWithImpl<$Res>
    extends _$BillingSummaryCopyWithImpl<$Res, _$BillingSummaryImpl>
    implements _$$BillingSummaryImplCopyWith<$Res> {
  __$$BillingSummaryImplCopyWithImpl(
    _$BillingSummaryImpl _value,
    $Res Function(_$BillingSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBilled = null,
    Object? totalCollected = null,
    Object? totalPending = null,
    Object? collectionRate = null,
    Object? period = null,
  }) {
    return _then(
      _$BillingSummaryImpl(
        totalBilled: null == totalBilled
            ? _value.totalBilled
            : totalBilled // ignore: cast_nullable_to_non_nullable
                  as double,
        totalCollected: null == totalCollected
            ? _value.totalCollected
            : totalCollected // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPending: null == totalPending
            ? _value.totalPending
            : totalPending // ignore: cast_nullable_to_non_nullable
                  as double,
        collectionRate: null == collectionRate
            ? _value.collectionRate
            : collectionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingSummaryImpl implements _BillingSummary {
  const _$BillingSummaryImpl({
    required this.totalBilled,
    required this.totalCollected,
    required this.totalPending,
    required this.collectionRate,
    required this.period,
  });

  factory _$BillingSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingSummaryImplFromJson(json);

  @override
  final double totalBilled;
  @override
  final double totalCollected;
  @override
  final double totalPending;
  @override
  final double collectionRate;
  @override
  final String period;

  @override
  String toString() {
    return 'BillingSummary(totalBilled: $totalBilled, totalCollected: $totalCollected, totalPending: $totalPending, collectionRate: $collectionRate, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingSummaryImpl &&
            (identical(other.totalBilled, totalBilled) ||
                other.totalBilled == totalBilled) &&
            (identical(other.totalCollected, totalCollected) ||
                other.totalCollected == totalCollected) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalBilled,
    totalCollected,
    totalPending,
    collectionRate,
    period,
  );

  /// Create a copy of BillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingSummaryImplCopyWith<_$BillingSummaryImpl> get copyWith =>
      __$$BillingSummaryImplCopyWithImpl<_$BillingSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingSummaryImplToJson(this);
  }
}

abstract class _BillingSummary implements BillingSummary {
  const factory _BillingSummary({
    required final double totalBilled,
    required final double totalCollected,
    required final double totalPending,
    required final double collectionRate,
    required final String period,
  }) = _$BillingSummaryImpl;

  factory _BillingSummary.fromJson(Map<String, dynamic> json) =
      _$BillingSummaryImpl.fromJson;

  @override
  double get totalBilled;
  @override
  double get totalCollected;
  @override
  double get totalPending;
  @override
  double get collectionRate;
  @override
  String get period;

  /// Create a copy of BillingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingSummaryImplCopyWith<_$BillingSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
