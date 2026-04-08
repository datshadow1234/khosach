import 'auth_bloc_widget.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}
class AppStarted extends AuthEvent {
  const AppStarted();
}
class AuthLoggedIn extends AuthEvent {
  final AuthTokenEntity authToken;
  const AuthLoggedIn({required this.authToken});
  @override
  List<Object?> get props => [authToken];
}

class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}