// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
//
// import '../../data/models/auth_services.dart';
// import '../../data/models/auth_token_model.dart';
//
//
// class AuthManager with ChangeNotifier {
//   AuthTokenModel? _authToken;
//   Timer? _authTimer;
//
//   final AuthService _authService = AuthService();
//
//   bool get isAuth {
//     return authToken != null && authToken!.isValid;
//   }
//
//   AuthTokenModel? get authToken {
//     return _authToken;
//   }
//
//   void _setAuthToken(AuthTokenModel token) {
//     _authToken = token;
//     _autoLogout();
//     notifyListeners();
//   }
//
//   Future<void> signup(String email, String password, String phone, String name, String address) async {
//     _setAuthToken(await _authService.signup(email, password, phone, name,address));
//   }
//
//   Future<void> login(String email, String password) async {
//     _setAuthToken(await _authService.login(email, password));
//   }
//
//   Future<bool> tryAutoLogin() async {
//     final savedToken = await _authService.loadSavedAuthToken();
//     if (savedToken == null) {
//       return false;
//     }
//
//     _setAuthToken(savedToken);
//     return true;
//   }
//
//   Future<void> logout() async {
//     _authToken = null;
//     if (_authTimer != null) {
//       _authTimer!.cancel();
//       _authTimer = null;
//     }
//     notifyListeners();
//     _authService.clearSavedAuthToken();
//   }
//
//   void _autoLogout() {
//     if (_authTimer != null) {
//       _authTimer!.cancel();
//     }
//     final timeToExpiry =
//         _authToken!.expiryDate.difference(DateTime.now()).inSeconds;
//     _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//   }
// }