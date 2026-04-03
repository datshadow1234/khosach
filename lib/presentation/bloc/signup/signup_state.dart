import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_token_entity.dart';

abstract class SignupState extends Equatable {
  const SignupState();
  @override
  List<Object?> get props => [];
}
class SignupInitial extends SignupState {}
class SignupLoading extends SignupState {}
class SignupSuccess extends SignupState {
  final AuthTokenEntity authToken;
  const SignupSuccess(this.authToken);
}
class SignupFailure extends SignupState {
  final String message;
  const SignupFailure(this.message);
}