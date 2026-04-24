import 'auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final AuthTokenEntity authToken;
  const AuthAuthenticated({required this.authToken});

  @override
  List<Object?> get props => [authToken];
}

class AuthUnauthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}