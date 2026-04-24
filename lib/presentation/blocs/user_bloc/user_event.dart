import 'user.dart';
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}
class FetchUserInfoEvent extends UserEvent {
  final String uid;
  final String token;
  const FetchUserInfoEvent({required this.uid, required this.token});

  @override
  List<Object?> get props => [uid, token];
}