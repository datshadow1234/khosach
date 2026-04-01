import '../../domain/entities/auth_token_entity.dart';

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.token,
    required super.userId,
    required super.expiryDate,
    super.role = "user",
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      token: json['idToken'] ?? json['authToken'] ?? '',
      userId: json['localId'] ?? json['userId'] ?? '',
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : DateTime.now().add(
        Duration(seconds: int.tryParse(json['expiresIn']?.toString() ?? '3600') ?? 3600),
      ),
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authToken': token,
      'userId': userId,
      'expiryDate': expiryDate.toIso8601String(),
      'role': role,
    };
  }

  AuthTokenModel copyWith({String? role}) {
    return AuthTokenModel(
      token: token,
      userId: userId,
      expiryDate: expiryDate,
      role: role ?? this.role,
    );
  }
}