import 'admin_bloc_widget.dart';

abstract class AdminProfileState extends Equatable {
  const AdminProfileState();
  @override
  List<Object?> get props => [];
}

class AdminProfileInitial extends AdminProfileState {}
class AdminProfileLoading extends AdminProfileState {}
class AdminProfileLoaded extends AdminProfileState {
  final UserEntity admin;
  const AdminProfileLoaded(this.admin);

  @override
  List<Object?> get props => [admin];
}

class AdminProfileUpdating extends AdminProfileState {
  final UserEntity admin;
  const AdminProfileUpdating(this.admin);

  @override
  List<Object?> get props => [admin];
}

class AdminProfileUpdatedSuccess extends AdminProfileState {
  final UserEntity admin;
  const AdminProfileUpdatedSuccess(this.admin);

  @override
  List<Object?> get props => [admin];
}

class AdminProfileError extends AdminProfileState {
  final String message;
  const AdminProfileError(this.message);

  @override
  List<Object?> get props => [message];
}