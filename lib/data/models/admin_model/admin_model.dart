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
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
  }) = _AdminModel;

  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      imageUrl: '',
      email: email,
      name: name,
      phone: phone,
      address: address,
      role: role,
      latitude: latitude,
      longitude: longitude,
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
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
