import '../../presentation/blocs/admin_product_bloc/admin_product.dart';

class StatisticEntity extends Equatable {
  final double totalRevenue;
  final int totalOrders;
  final double totalShippingFee;
  final Map<String, double> chartData;

  const StatisticEntity({
    this.totalRevenue = 0.0,
    this.totalOrders = 0,
    this.totalShippingFee = 0.0,
    this.chartData = const {}, // Khởi tạo Map rỗng thay vì null
  });

  @override
  List<Object?> get props => [totalRevenue, totalOrders, totalShippingFee, chartData];
}