// lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String uid,
    @Default('') String email,
    @Default('') String name,
    @Default('') String phone,
    @Default('') String address,
    @Default('') String imageUrl,
    @Default('user') String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      uid: model.uid,
      imageUrl: model.imageUrl,
      email: model.email,
      name: model.name,
      phone: model.phone,
      address: model.address,
      role: model.role,
    );
  }
}