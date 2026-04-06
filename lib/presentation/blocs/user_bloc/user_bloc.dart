import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user_info_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserInfoUseCase getUserInfoUseCase;

  UserBloc({required this.getUserInfoUseCase}) : super(UserInitial()) {
    on<FetchUserInfoEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await getUserInfoUseCase(event.uid, event.token);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError("Không thể tải thông tin người dùng: ${e.toString()}"));
      }
    });
  }
}