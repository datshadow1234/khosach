import 'admin_bloc.dart';

abstract class AdminProfileEvent {}

class FetchAdminProfileEvent extends AdminProfileEvent {
  final String uid;
  final String token;
  FetchAdminProfileEvent(this.uid, this.token);
}

class UpdateAdminProfileEvent extends AdminProfileEvent {
  final UserEntity admin;
  final String token;
  UpdateAdminProfileEvent(this.admin, this.token);
}