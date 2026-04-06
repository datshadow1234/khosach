// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      products: (json['products'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      totalQuantity: (json['totalQuantity'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      customerId: json['customerId'] as String,
      payResult: json['payResult'] as String,
      dateTime: json['dateTime'] as String,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'products': instance.products,
      'totalQuantity': instance.totalQuantity,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'customerId': instance.customerId,
      'payResult': instance.payResult,
      'dateTime': instance.dateTime,
    };
