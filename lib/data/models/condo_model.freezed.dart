// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Condo _$CondoFromJson(Map<String, dynamic> json) {
  return _Condo.fromJson(json);
}

/// @nodoc
mixin _$Condo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get towers => throw _privateConstructorUsedError;
  int get units => throw _privateConstructorUsedError;
  int get stratum => throw _privateConstructorUsedError;
  double get area => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get officeHours => throw _privateConstructorUsedError;

  /// Serializes this Condo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Condo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CondoCopyWith<Condo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CondoCopyWith<$Res> {
  factory $CondoCopyWith(Condo value, $Res Function(Condo) then) =
      _$CondoCopyWithImpl<$Res, Condo>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String city,
    String imageUrl,
    int towers,
    int units,
    int stratum,
    double area,
    String? phone,
    String? email,
    String? officeHours,
  });
}

/// @nodoc
class _$CondoCopyWithImpl<$Res, $Val extends Condo>
    implements $CondoCopyWith<$Res> {
  _$CondoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Condo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? city = null,
    Object? imageUrl = null,
    Object? towers = null,
    Object? units = null,
    Object? stratum = null,
    Object? area = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? officeHours = freezed,
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
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            towers: null == towers
                ? _value.towers
                : towers // ignore: cast_nullable_to_non_nullable
                      as int,
            units: null == units
                ? _value.units
                : units // ignore: cast_nullable_to_non_nullable
                      as int,
            stratum: null == stratum
                ? _value.stratum
                : stratum // ignore: cast_nullable_to_non_nullable
                      as int,
            area: null == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as double,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            officeHours: freezed == officeHours
                ? _value.officeHours
                : officeHours // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CondoImplCopyWith<$Res> implements $CondoCopyWith<$Res> {
  factory _$$CondoImplCopyWith(
    _$CondoImpl value,
    $Res Function(_$CondoImpl) then,
  ) = __$$CondoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String city,
    String imageUrl,
    int towers,
    int units,
    int stratum,
    double area,
    String? phone,
    String? email,
    String? officeHours,
  });
}

/// @nodoc
class __$$CondoImplCopyWithImpl<$Res>
    extends _$CondoCopyWithImpl<$Res, _$CondoImpl>
    implements _$$CondoImplCopyWith<$Res> {
  __$$CondoImplCopyWithImpl(
    _$CondoImpl _value,
    $Res Function(_$CondoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Condo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? city = null,
    Object? imageUrl = null,
    Object? towers = null,
    Object? units = null,
    Object? stratum = null,
    Object? area = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? officeHours = freezed,
  }) {
    return _then(
      _$CondoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        towers: null == towers
            ? _value.towers
            : towers // ignore: cast_nullable_to_non_nullable
                  as int,
        units: null == units
            ? _value.units
            : units // ignore: cast_nullable_to_non_nullable
                  as int,
        stratum: null == stratum
            ? _value.stratum
            : stratum // ignore: cast_nullable_to_non_nullable
                  as int,
        area: null == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as double,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        officeHours: freezed == officeHours
            ? _value.officeHours
            : officeHours // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CondoImpl implements _Condo {
  const _$CondoImpl({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.imageUrl,
    required this.towers,
    required this.units,
    required this.stratum,
    required this.area,
    this.phone,
    this.email,
    this.officeHours,
  });

  factory _$CondoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CondoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final String city;
  @override
  final String imageUrl;
  @override
  final int towers;
  @override
  final int units;
  @override
  final int stratum;
  @override
  final double area;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? officeHours;

  @override
  String toString() {
    return 'Condo(id: $id, name: $name, address: $address, city: $city, imageUrl: $imageUrl, towers: $towers, units: $units, stratum: $stratum, area: $area, phone: $phone, email: $email, officeHours: $officeHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CondoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.towers, towers) || other.towers == towers) &&
            (identical(other.units, units) || other.units == units) &&
            (identical(other.stratum, stratum) || other.stratum == stratum) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.officeHours, officeHours) ||
                other.officeHours == officeHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    city,
    imageUrl,
    towers,
    units,
    stratum,
    area,
    phone,
    email,
    officeHours,
  );

  /// Create a copy of Condo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CondoImplCopyWith<_$CondoImpl> get copyWith =>
      __$$CondoImplCopyWithImpl<_$CondoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CondoImplToJson(this);
  }
}

abstract class _Condo implements Condo {
  const factory _Condo({
    required final String id,
    required final String name,
    required final String address,
    required final String city,
    required final String imageUrl,
    required final int towers,
    required final int units,
    required final int stratum,
    required final double area,
    final String? phone,
    final String? email,
    final String? officeHours,
  }) = _$CondoImpl;

  factory _Condo.fromJson(Map<String, dynamic> json) = _$CondoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  String get city;
  @override
  String get imageUrl;
  @override
  int get towers;
  @override
  int get units;
  @override
  int get stratum;
  @override
  double get area;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get officeHours;

  /// Create a copy of Condo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CondoImplCopyWith<_$CondoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CondoNews _$CondoNewsFromJson(Map<String, dynamic> json) {
  return _CondoNews.fromJson(json);
}

/// @nodoc
mixin _$CondoNews {
  String get id => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get timeAgo => throw _privateConstructorUsedError;

  /// Serializes this CondoNews to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CondoNews
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CondoNewsCopyWith<CondoNews> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CondoNewsCopyWith<$Res> {
  factory $CondoNewsCopyWith(CondoNews value, $Res Function(CondoNews) then) =
      _$CondoNewsCopyWithImpl<$Res, CondoNews>;
  @useResult
  $Res call({
    String id,
    String tag,
    String title,
    String description,
    String timeAgo,
  });
}

/// @nodoc
class _$CondoNewsCopyWithImpl<$Res, $Val extends CondoNews>
    implements $CondoNewsCopyWith<$Res> {
  _$CondoNewsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CondoNews
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tag = null,
    Object? title = null,
    Object? description = null,
    Object? timeAgo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            tag: null == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            timeAgo: null == timeAgo
                ? _value.timeAgo
                : timeAgo // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CondoNewsImplCopyWith<$Res>
    implements $CondoNewsCopyWith<$Res> {
  factory _$$CondoNewsImplCopyWith(
    _$CondoNewsImpl value,
    $Res Function(_$CondoNewsImpl) then,
  ) = __$$CondoNewsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tag,
    String title,
    String description,
    String timeAgo,
  });
}

/// @nodoc
class __$$CondoNewsImplCopyWithImpl<$Res>
    extends _$CondoNewsCopyWithImpl<$Res, _$CondoNewsImpl>
    implements _$$CondoNewsImplCopyWith<$Res> {
  __$$CondoNewsImplCopyWithImpl(
    _$CondoNewsImpl _value,
    $Res Function(_$CondoNewsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CondoNews
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tag = null,
    Object? title = null,
    Object? description = null,
    Object? timeAgo = null,
  }) {
    return _then(
      _$CondoNewsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tag: null == tag
            ? _value.tag
            : tag // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        timeAgo: null == timeAgo
            ? _value.timeAgo
            : timeAgo // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CondoNewsImpl implements _CondoNews {
  const _$CondoNewsImpl({
    required this.id,
    required this.tag,
    required this.title,
    required this.description,
    required this.timeAgo,
  });

  factory _$CondoNewsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CondoNewsImplFromJson(json);

  @override
  final String id;
  @override
  final String tag;
  @override
  final String title;
  @override
  final String description;
  @override
  final String timeAgo;

  @override
  String toString() {
    return 'CondoNews(id: $id, tag: $tag, title: $title, description: $description, timeAgo: $timeAgo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CondoNewsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timeAgo, timeAgo) || other.timeAgo == timeAgo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tag, title, description, timeAgo);

  /// Create a copy of CondoNews
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CondoNewsImplCopyWith<_$CondoNewsImpl> get copyWith =>
      __$$CondoNewsImplCopyWithImpl<_$CondoNewsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CondoNewsImplToJson(this);
  }
}

abstract class _CondoNews implements CondoNews {
  const factory _CondoNews({
    required final String id,
    required final String tag,
    required final String title,
    required final String description,
    required final String timeAgo,
  }) = _$CondoNewsImpl;

  factory _CondoNews.fromJson(Map<String, dynamic> json) =
      _$CondoNewsImpl.fromJson;

  @override
  String get id;
  @override
  String get tag;
  @override
  String get title;
  @override
  String get description;
  @override
  String get timeAgo;

  /// Create a copy of CondoNews
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CondoNewsImplCopyWith<_$CondoNewsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
