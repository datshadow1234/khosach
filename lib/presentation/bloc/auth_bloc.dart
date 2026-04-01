import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/try_auto_login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final TryAutoLoginUseCase tryAutoLoginUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.tryAutoLoginUseCase,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final authToken = await tryAutoLoginUseCase();
    if (authToken != null && authToken.isValid) {
      emit(AuthAuthenticated(authToken: authToken));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authToken = await loginUseCase(event.email, event.password);
      emit(AuthAuthenticated(authToken: authToken));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onSignupSubmitted(SignupSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authToken = await signupUseCase(
        event.email,
        event.password,
        event.phone,
        event.name,
        event.address,
      );
      emit(AuthAuthenticated(authToken: authToken));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }
}
