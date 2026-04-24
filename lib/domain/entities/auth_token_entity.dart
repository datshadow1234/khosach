import 'package:equatable/equatable.dart';

class AuthTokenEntity extends Equatable {
  final String token;
  final String userId;
  final DateTime expiryDate;
  final String role;

  const AuthTokenEntity({
    required this.token,
    required this.userId,
    required this.expiryDate,
    this.role = "user",
  });

  bool get isValid {
    return token.isNotEmpty && expiryDate.isAfter(DateTime.now());
  }

  @override
  List<Object?> get props => [token, userId, expiryDate, role];
}
