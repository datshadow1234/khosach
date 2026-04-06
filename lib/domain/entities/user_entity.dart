import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String address;
  final String role;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.role,
  });

  @override
  List<Object?> get props => [uid, email, name, phone, address, role];
}