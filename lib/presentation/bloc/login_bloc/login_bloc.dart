import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/auth_token_entity.dart';
import '../../../domain/repositories/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final auth = await repository.signIn(event.email, event.password);
        final role = await repository.getUserRole(auth.userId, auth.token);
        final finalAuth = AuthTokenEntity(token: auth.token, userId: auth.userId, expiryDate: auth.expiryDate, role: role);
        await repository.saveLocalToken(finalAuth);
        emit(LoginSuccess(finalAuth));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}