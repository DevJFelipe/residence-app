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

class LoginResponse {
  final String userId;
  final String fullName;
  final String email;
  final List<CondominiumRole> condominiums;
  final String accessToken;
  final String? message;

  LoginResponse({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.condominiums,
    required this.accessToken,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['user_id'],
      fullName: json['full_name'],
      email: json['email'],
      condominiums: (json['condominiums'] as List)
          .map((c) => CondominiumRole.fromJson(c))
          .toList(),
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
        'condominiums': condominiums
            .map((c) => {
                  'condominium_id': c.condominiumId,
                  'condominium_name': c.condominiumName,
                  'role': c.role,
                })
            .toList(),
        'access_token': accessToken,
        'message': message,
      };
}
