class CondominiumRole {
  final String condominiumId;
  final String condominiumName;
  final String role;

  CondominiumRole({
    required this.condominiumId,
    required this.condominiumName,
    required this.role,
  });

  factory CondominiumRole.fromJson(Map<String, dynamic> json) {
    return CondominiumRole(
      condominiumId: json['condominium_id'],
      condominiumName: json['condominium_name'],
      role: json['role'],
    );
  }
}

class UserProperty {
  final String propertyId;
  final String propertyNumber;
  final String? block;
  final String condominiumId;

  UserProperty({
    required this.propertyId,
    required this.propertyNumber,
    this.block,
    required this.condominiumId,
  });

  factory UserProperty.fromJson(Map<String, dynamic> json) {
    return UserProperty(
      propertyId: json['property_id'],
      propertyNumber: json['property_number'],
      block: json['block'],
      condominiumId: json['condominium_id'],
    );
  }

  String get displayName {
    if (block != null && block!.isNotEmpty) {
      return '$block - $propertyNumber';
    }
    return propertyNumber;
  }
}

class LoginResponse {
  final String userId;
  final String fullName;
  final String email;
  final String? phone;
  final List<CondominiumRole> condominiums;
  final List<UserProperty> properties;
  final String accessToken;
  final String? message;

  LoginResponse({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.condominiums,
    this.properties = const [],
    required this.accessToken,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['user_id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      condominiums: (json['condominiums'] as List)
          .map((c) => CondominiumRole.fromJson(c))
          .toList(),
      properties: (json['properties'] as List?)
              ?.map((p) => UserProperty.fromJson(p))
              .toList() ??
          [],
      accessToken: json['access_token'],
      message: json['message'],
    );
  }

  String? get role {
    if (condominiums.isEmpty) return null;
    return condominiums.first.role;
  }

  bool get isAdmin =>
      condominiums.any((c) => c.role == 'admin' || c.role == 'super_admin');

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'condominiums': condominiums
            .map((c) => {
                  'condominium_id': c.condominiumId,
                  'condominium_name': c.condominiumName,
                  'role': c.role,
                })
            .toList(),
        'properties': properties
            .map((p) => {
                  'property_id': p.propertyId,
                  'property_number': p.propertyNumber,
                  'block': p.block,
                  'condominium_id': p.condominiumId,
                })
            .toList(),
        'access_token': accessToken,
        'message': message,
      };
}
