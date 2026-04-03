import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final token = await repository.tryAutoLogin();
      if (token != null) emit(AuthAuthenticated(authToken: token));
      else emit(AuthUnauthenticated());
    });
    on<AuthLoggedIn>((event, emit) => emit(AuthAuthenticated(authToken: event.authToken)));
    on<AuthLoggedOut>((event, emit) => emit(AuthUnauthenticated()));
  }
}