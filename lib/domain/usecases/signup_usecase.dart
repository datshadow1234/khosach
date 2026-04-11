import 'usecase.dart';

class SignupUseCase {
  final SignupRepository repository;

  SignupUseCase({required this.repository});

  Future<AuthTokenEntity> call(
      String email, String password, String phone, String name, String address,
      ) async {
    final baseEntity = await repository.signUp(email, password);
    await repository.createUserInfo(baseEntity.userId, baseEntity.token, {
      'uid': baseEntity.userId,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'role': 'user',
    });

    final finalEntity = AuthTokenEntity(
      token: baseEntity.token,
      userId: baseEntity.userId,
      expiryDate: baseEntity.expiryDate,
      role: 'user',
    );

    await repository.saveLocalToken(finalEntity);

    return finalEntity;
  }
}