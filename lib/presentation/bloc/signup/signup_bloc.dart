import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/auth_token_entity.dart';
import '../../../domain/repositories/signup_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository repository;

  SignupBloc({required this.repository}) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        final auth = await repository.signUp(event.email, event.password);
        await repository.createUserInfo(auth.userId, auth.token, {
          'uid': auth.userId, 'email': event.email, 'name': event.name,
          'phone': event.phone, 'address': event.address, 'birthday': '', 'role': 'user'
        });
        final finalAuth = AuthTokenEntity(token: auth.token, userId: auth.userId, expiryDate: auth.expiryDate, role: 'user');
        await repository.saveLocalToken(finalAuth);
        emit(SignupSuccess(finalAuth));
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}