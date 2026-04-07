import 'user_bloc_widget.dart';
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