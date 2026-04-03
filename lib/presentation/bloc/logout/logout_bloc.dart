import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/logout_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository repository;
  LogoutBloc({required this.repository}) : super(LogoutInitial()) {
    on<LogoutSubmitted>((event, emit) async {
      emit(LogoutLoading());
      await repository.clearSession();
      emit(LogoutSuccess());
    });
  }
}