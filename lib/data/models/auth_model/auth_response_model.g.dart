// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseModelImpl(
      token: json['idToken'] as String? ?? '',
      userId: json['localId'] as String? ?? '',
      expiresIn: json['expiresIn'] as String? ?? '3600',
    );

Map<String, dynamic> _$$AuthResponseModelImplToJson(
        _$AuthResponseModelImpl instance) =>
    <String, dynamic>{
      'idToken': instance.token,
      'localId': instance.userId,
      'expiresIn': instance.expiresIn,
    };
