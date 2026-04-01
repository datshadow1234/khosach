// import 'dart:convert';
// import 'dart:async';
//
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// import '../models/http_exception.dart';
// import 'auth_token_model.dart';
//
// class AuthService {
//   static const _authTokenKey = 'authToken';
//   late final String? _apiKey;
//
//   AuthService() {
//     _apiKey = dotenv.env['FIREBASE_API_KEY'];
//   }
//
//   String _buildAuthUrl(String method) {
//     return 'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=$_apiKey';
//   }
//
//   Future<AuthTokenModel> _authenticate(String email, String password, String method,
//       [String phone = '', String name = '', String address = '']) async {
//     try {
//       final url = Uri.parse(_buildAuthUrl(method));
//       final response = await http.post(
//         url,
//         body: json.encode(
//           {
//             'email': email,
//             'password': password,
//             'returnSecureToken': true,
//           },
//         ),
//       );
//       final responseJson = json.decode(response.body);
//       if (responseJson['error'] != null) {
//         throw HttpException.firebase(responseJson['error']['message']);
//       }
//
//       var authTokenModel = _fromJson(responseJson);
//
//       if (method == 'signUp') {
//         final token = authTokenModel.token;
//         final uid = authTokenModel.userId;
//         final usersUrl = Uri.parse(
//             'https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app/users/$uid.json?auth=$token');
//         await http.put(usersUrl,
//             body: json.encode({
//               'uid': uid,
//               'email': email,
//               'name': name,
//               'phone': phone,
//               'address': address,
//               'birthday': '',
//               'role': 'user'
//             }));
//       }
//
//       final role = await isAdmin(authTokenModel);
//       authTokenModel = authTokenModel.copyWith(role: role);
//
//       await _saveAuthToken(authTokenModel);
//
//       return authTokenModel;
//     } catch (error) {
//       print(error);
//       rethrow;
//     }
//   }
//
//   Future<AuthTokenModel> signup(String email, String password, String phone,
//       String name, String address) {
//     return _authenticate(email, password, 'signUp', phone, name, address);
//   }
//
//   Future<AuthTokenModel> login(String email, String password) {
//     return _authenticate(email, password, 'signInWithPassword');
//   }
//
//   Future<String> isAdmin(AuthTokenModel authToken) async {
//     final token = authToken.token;
//     final uid = authToken.userId;
//
//     // Check direct user path first
//     final directUrl = Uri.parse(
//         'https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app/users/$uid.json?auth=$token');
//
//     try {
//       final response = await http.get(directUrl);
//       if (response.statusCode == 200 && response.body != 'null') {
//         final userData = json.decode(response.body) as Map<String, dynamic>;
//         return userData['role'] ?? 'user';
//       }
//     } catch (e) {
//       print('Error fetching direct user data: $e');
//     }
//
//     // Fallback search
//     final usersUrl = Uri.parse(
//         'https://bookstore-project-f0504-default-rtdb.asia-southeast1.firebasedatabase.app/users.json?auth=$token&orderBy="uid"&equalTo="$uid"');
//
//     try {
//       final response = await http.get(usersUrl);
//       final userMap = json.decode(response.body) as Map<String, dynamic>;
//
//       if (response.statusCode == 200 && userMap.isNotEmpty) {
//         return userMap[userMap.keys.first]['role'] ?? 'user';
//       }
//     } catch (e) {
//       print('Error searching user: $e');
//     }
//
//     return 'user';
//   }
//
//   Future<void> _saveAuthToken(AuthTokenModel authToken) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_authTokenKey, json.encode(authToken.toJson()));
//   }
//
//   AuthTokenModel _fromJson(Map<String, dynamic> json) {
//     return AuthTokenModel(
//       token: json['idToken'] ?? '',
//       userId: json['localId'] ?? '',
//       expiryDate: DateTime.now().add(
//         Duration(
//           seconds: int.parse(
//             json['expiresIn'] ?? '3600',
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<AuthTokenModel?> loadSavedAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey(_authTokenKey)) {
//       return null;
//     }
//
//     final savedToken = prefs.getString(_authTokenKey);
//     if (savedToken == null) return null;
//
//     final authTokenModel = AuthTokenModel.fromJson(json.decode(savedToken));
//     if (!authTokenModel.isValid) {
//       return null;
//     }
//     return authTokenModel;
//   }
//
//   Future<void> clearSavedAuthToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_authTokenKey);
//   }
// }
