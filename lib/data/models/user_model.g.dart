// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  phone: json['phone'] as String?,
  unitId: json['unitId'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'phone': instance.phone,
      'unitId': instance.unitId,
      'avatarUrl': instance.avatarUrl,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.resident: 'resident',
  UserRole.visitor: 'visitor',
};

_$UnauthenticatedImpl _$$UnauthenticatedImplFromJson(
  Map<String, dynamic> json,
) => _$UnauthenticatedImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$UnauthenticatedImplToJson(
  _$UnauthenticatedImpl instance,
) => <String, dynamic>{'runtimeType': instance.$type};

_$AuthenticatedImpl _$$AuthenticatedImplFromJson(Map<String, dynamic> json) =>
    _$AuthenticatedImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AuthenticatedImplToJson(_$AuthenticatedImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'runtimeType': instance.$type,
    };
