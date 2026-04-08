import 'login_bloc_widget.dart';

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