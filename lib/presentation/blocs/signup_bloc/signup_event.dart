import 'signup_bloc_widget.dart';
abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}
class SignupSubmitted extends SignupEvent {
  final String email, password, phone, name, address;
  const SignupSubmitted(this.email, this.password, this.phone, this.name, this.address);
}