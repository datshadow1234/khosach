import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/auth_token_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(AuthTokenEntity entity);
  Future<AuthTokenEntity?> getAuthToken();
  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _authTokenKey = 'authToken';
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveAuthToken(AuthTokenEntity entity) async {
    final Map<String, dynamic> jsonMap = {
      'token': entity.token,
      'userId': entity.userId,
      'expiryDate': entity.expiryDate.toIso8601String(),
      'role': entity.role,
    };
    await sharedPreferences.setString(_authTokenKey, json.encode(jsonMap));
  }

  @override
  Future<AuthTokenEntity?> getAuthToken() async {
    final jsonString = sharedPreferences.getString(_authTokenKey);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return AuthTokenEntity(
        token: jsonMap['token'] ?? '',
        userId: jsonMap['userId'] ?? '',
        expiryDate: DateTime.parse(jsonMap['expiryDate']),
        role: jsonMap['role'] ?? 'user',
      );
    }
    return null;
  }

  @override
  Future<void> clearAuthToken() async {
    await sharedPreferences.remove(_authTokenKey);
  }
}