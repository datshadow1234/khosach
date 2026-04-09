import 'admin_bloc_widget.dart';

class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  final GetAdminProfileUseCase getAdminProfileUseCase;
  final AdminUpdateInfoUseCase adminUpdateInfoUseCase;

  AdminProfileBloc({
    required this.getAdminProfileUseCase,
    required this.adminUpdateInfoUseCase,
  }) : super(AdminProfileInitial()) {

    on<FetchAdminProfileEvent>((event, emit) async {
      emit(AdminProfileLoading());
      try {
        final admin = await getAdminProfileUseCase.call(event.uid, event.token);
        emit(AdminProfileLoaded(admin));
      } catch (e) {
        emit(AdminProfileError(e.toString()));
      }
    });

    on<UpdateAdminProfileEvent>((event, emit) async {
      emit(AdminProfileUpdating(event.admin));
      try {
        await adminUpdateInfoUseCase.call(event.admin, event.token);
        emit(AdminProfileUpdatedSuccess(event.admin));
        emit(AdminProfileLoaded(event.admin));
      } catch (e) {
        emit(AdminProfileError(e.toString()));
        emit(AdminProfileLoaded(event.admin));
      }
    });
  }
}