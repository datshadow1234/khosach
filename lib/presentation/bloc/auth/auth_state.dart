import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_token_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}
class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState {
  final AuthTokenEntity authToken;
  const AuthAuthenticated({required this.authToken});
}
class AuthUnauthenticated extends AuthState {}