import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'admin_model.freezed.dart';
part 'admin_model.g.dart';

@freezed
class AdminModel with _$AdminModel {
  const AdminModel._();

  const factory AdminModel({
    @Default('') String uid,
    @Default('') String email,
    @Default('') String name,
    @Default('') String phone,
    @Default('') String address,
    @Default('admin') String role,
    @Default('') String lastLogin,
  }) = _AdminModel;

  factory AdminModel.fromJson(Map<String, dynamic> json) => _$AdminModelFromJson(json);

  // Dùng riêng cho Admin
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      imageUrl: '',
      email: email,
      name: name,
      phone: phone,
      address: address,
      role: role,
    );
  }

  factory AdminModel.fromEntity(UserEntity entity) {
    return AdminModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      address: entity.address,
      role: entity.role,
    );
  }
}