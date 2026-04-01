import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_token_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(AuthTokenModel authToken);
  Future<AuthTokenModel?> getAuthToken();
  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _authTokenKey = 'authToken';
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveAuthToken(AuthTokenModel authToken) async {
    await sharedPreferences.setString(
      _authTokenKey,
      json.encode(authToken.toJson()),
    );
  }

  @override
  Future<AuthTokenModel?> getAuthToken() async {
    final jsonString = sharedPreferences.getString(_authTokenKey);
    if (jsonString != null) {
      return AuthTokenModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearAuthToken() async {
    await sharedPreferences.remove(_authTokenKey);
  }
}
