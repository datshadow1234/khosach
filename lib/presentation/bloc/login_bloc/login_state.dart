import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_token_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final AuthTokenEntity authToken;
  const LoginSuccess(this.authToken);
}
class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}