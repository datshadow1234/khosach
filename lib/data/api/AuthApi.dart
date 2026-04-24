import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../clients/auth_client/auth_client.dart';

class AuthApi implements AuthRepository {
  late AuthClient _api;
  AuthTokenEntity? _cachedToken;
  final String _apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';

  AuthApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://identitytoolkit.googleapis.com/v1",
        connectTimeout: const Duration(seconds: 30),
      ),
    );
    _api = AuthClient(dio);
  }
  AuthTokenEntity? get userLogin => _cachedToken;
  Future<void> saveLocalToken(AuthTokenEntity? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.token.isEmpty) {
      await prefs.remove('user_data');
      _cachedToken = null;
      debugPrint("🗑️ Đã xóa token khỏi cache");
    } else {
      final userData = json.encode({
        'token': token.token,
        'userId': token.userId,
        'expiryDate': token.expiryDate.toIso8601String(),
      });
      await prefs.setString('user_data', userData);
      _cachedToken = token;
      debugPrint("✅ Đã lưu token vào cache: $userData");
    }
  }

  @override
  Future<AuthTokenEntity> login(String email, String password) async {
    try {
      final response = await _api.signIn(_apiKey, {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });
      final entity = AuthTokenEntity(
        token: response.token,
        userId: response.userId,
        expiryDate: DateTime.now().add(
          Duration(seconds: int.parse(response.expiresIn)),
        ),
      );
      await saveLocalToken(entity);
      return entity;
    } catch (error) {
      debugPrint("❌ Error Login: $error");
      rethrow;
    }
  }

  @override
  Future<AuthTokenEntity?> tryAutoLogin() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_data')) return null;
    final extractedData =
        json.decode(prefs.getString('user_data')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      await logout();
      return null;
    }
    _cachedToken = AuthTokenEntity(
      token: extractedData['token'],
      userId: extractedData['userId'],
      expiryDate: expiryDate,
    );
    return _cachedToken;
  }

  @override
  Future<void> logout() async {
    await saveLocalToken(null);
  }

  @override
  Future<AuthTokenEntity> signup(String email, String password) async {
    throw UnimplementedError();
  }
}
