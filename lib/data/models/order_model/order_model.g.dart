// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      totalQuantity: (json['totalQuantity'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      payResult: json['payResult'] as String? ?? '',
      dateTime: json['dateTime'] as String? ?? '2024-01-01T00:00:00.000',
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'shippingFee': instance.shippingFee,
      'products': instance.products,
      'totalQuantity': instance.totalQuantity,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'customerId': instance.customerId,
      'payResult': instance.payResult,
      'dateTime': instance.dateTime,
    };
