import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_token_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}
class AppStarted extends AuthEvent {}
class AuthLoggedIn extends AuthEvent {
  final AuthTokenEntity authToken;
  const AuthLoggedIn({required this.authToken});
}
class AuthLoggedOut extends AuthEvent {}