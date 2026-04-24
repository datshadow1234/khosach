import 'cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  Map<String, dynamic>? toJson();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  @override
  Map<String, dynamic>? toJson() => null;
}

class CartLoading extends CartState {
  @override
  Map<String, dynamic>? toJson() => null;
}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final double totalAmount;
  final int totalQuantity;

  const CartLoaded({
    required this.items,
    required this.totalAmount,
    required this.totalQuantity,
  });

  factory CartLoaded.fromJson(Map<String, dynamic> json) {
    final items =
        (json['items'] as List).map((e) => CartItemEntity.fromJson(e)).toList();

    return CartLoaded(
      items: items,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalQuantity: json['totalQuantity'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'totalQuantity': totalQuantity,
      };

  @override
  List<Object?> get props => [items, totalAmount, totalQuantity];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  Map<String, dynamic>? toJson() => null;

  @override
  List<Object?> get props => [message];
}
