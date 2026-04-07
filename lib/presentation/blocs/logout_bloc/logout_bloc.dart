import 'logout_bloc_widget.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository repository;

  LogoutBloc({required this.repository}) : super(LogoutInitial()) {
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  Future<void> _onLogoutSubmitted(
      LogoutSubmitted event,
      Emitter<LogoutState> emit,
      ) async {
    try {
      emit(LogoutLoading());

      await repository.clearSession();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(message: e.toString()));
    }
  }
}