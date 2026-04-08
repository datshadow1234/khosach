import 'login_bloc_widget.dart';

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