import 'package:equatable/equatable.dart';

class StatisticEntity extends Equatable {
  final double totalRevenue;
  final int totalOrders;

  const StatisticEntity({
    required this.totalRevenue,
    required this.totalOrders,
  });

  @override
  List<Object?> get props => [totalRevenue, totalOrders];
}