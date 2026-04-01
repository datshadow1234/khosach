import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String phone;
  final String name;
  final String address;

  const SignupSubmitted({
    required this.email,
    required this.password,
    required this.phone,
    required this.name,
    required this.address,
  });

  @override
  List<Object?> get props => [email, password, phone, name, address];
}

class LogoutRequested extends AuthEvent {}
