// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminModelImpl _$$AdminModelImplFromJson(Map<String, dynamic> json) =>
    _$AdminModelImpl(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      role: json['role'] as String? ?? 'admin',
      lastLogin: json['lastLogin'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AdminModelImplToJson(_$AdminModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'role': instance.role,
      'lastLogin': instance.lastLogin,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
