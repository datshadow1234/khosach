import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/auth_token_model.dart';
import '../models/http_exception.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> authenticate(String email, String password, String method,
      [String phone = '', String name = '', String address = '']);
  Future<String> isAdmin(String token, String uid);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String? _apiKey = dotenv.env['FIREBASE_API_KEY'];

  AuthRemoteDataSourceImpl({required this.client});

  String _buildAuthUrl(String method) {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=$_apiKey';
  }

  @override
  Future<AuthTokenModel> authenticate(String email, String password, String method,
      [String phone = '', String name = '', String address = '']) async {
    final url = Uri.parse(_buildAuthUrl(method));
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseJson = json.decode(response.body);
    if (responseJson['error'] != null) {
      // Firebase errors are inside 'error' object
      final errorMessage = responseJson['error']['message'];
      throw HttpException.firebase(errorMessage);
    }

    final authToken = AuthTokenModel.fromJson(responseJson);

    if (method == 'signUp') {
      final token = authToken.token;
      final uid = authToken.userId;
      // Use PUT to create user at specific UID for easier lookup
      final usersUrl = Uri.parse(
          'https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app/users/$uid.json?auth=$token');
      
      await client.put(
        usersUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uid': uid,
          'email': email,
          'name': name,
          'phone': phone,
          'address': address,
          'birthday': '',
          'role': 'user'
        }),
      );
    }
    return authToken;
  }

  @override
  Future<String> isAdmin(String token, String uid) async {
    final directUrl = Uri.parse(
        'https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app/users/$uid.json?auth=$token');

    try {
      final response = await client.get(directUrl);
      if (response.statusCode == 200 && response.body != 'null') {
        final userData = json.decode(response.body) as Map<String, dynamic>;
        return userData['role'] ?? 'user';
      }
    } catch (e) {
      print('Error checking admin role: $e');
    }

    // Fallback to query
    final queryUrl = Uri.parse(
        'https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app/users.json?auth=$token&orderBy="uid"&equalTo="$uid"');

    try {
      final response = await client.get(queryUrl);
      final user = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && user.isNotEmpty) {
        return user[user.keys.first]['role'] ?? 'user';
      }
    } catch (_) {}

    return 'user';
  }
}
