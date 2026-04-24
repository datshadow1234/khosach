import 'auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final token = await repository.tryAutoLogin();

      if (token != null) {
        emit(AuthAuthenticated(authToken: token));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void _onAuthLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(authToken: event.authToken));
  }

  void _onAuthLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}
