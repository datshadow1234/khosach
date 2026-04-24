import 'repositories.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final OrderClient orderClient;

  StatisticRepositoryImpl({required this.orderClient});
  @override
  Future<StatisticEntity> getStatistics(String token, String timeRange, String status) async {
    try {
      final response = await orderClient.getOrders(token, null, null);
      if (response == null) return _emptyData();

      double revenue = 0;
      double shippingFee = 0;
      int ordersCount = 0;
      Map<String, double> chartData = {};
      final now = DateTime.now();

      final Map<String, dynamic> ordersMap = Map<String, dynamic>.from(response);

      ordersMap.forEach((key, value) {
        final orderData = Map<String, dynamic>.from(value);
        final DateTime orderDate = DateTime.parse(orderData['dateTime']);
        final String orderStatus = orderData['status'] ?? 'placed';

        if (status != 'all' && orderStatus != status) {
          return;
        }

        bool isTimeMatch = false;
        String chartKey = "";

        if (timeRange == 'month') {
          isTimeMatch = orderDate.month == now.month && orderDate.year == now.year;
          chartKey = "${orderDate.day}/${orderDate.month}";
        } else if (timeRange == 'quarter') {
          final currentQuarter = (now.month - 1) ~/ 3 + 1;
          final orderQuarter = (orderDate.month - 1) ~/ 3 + 1;
          isTimeMatch = currentQuarter == orderQuarter && orderDate.year == now.year;
          chartKey = "Tháng ${orderDate.month}";
        } else if (timeRange == 'year') {
          isTimeMatch = orderDate.year == now.year;
          chartKey = "T${orderDate.month}";
        }

        if (isTimeMatch) {
          ordersCount++;
          if (orderStatus == 'completed') {

            final sFee = (orderData['shippingFee'] ?? 0).toDouble();
            shippingFee += sFee;

            double orderPrice = 0;
            final products = orderData['products'];
            if (products is List) {
              for (var item in products) {
                orderPrice += (item['price'] ?? 0) * (item['quantity'] ?? 1);
              }
            } else {
              orderPrice = (orderData['totalAmount'] ?? 0).toDouble() - sFee;
            }

            revenue += orderPrice;
            chartData[chartKey] = (chartData[chartKey] ?? 0) + orderPrice;
          }
        }
      });

      return StatisticEntity(
        totalRevenue: revenue,
        totalOrders: ordersCount,
        totalShippingFee: shippingFee,
        chartData: chartData,
      );
    } catch (e) {
      throw Exception('Lỗi xử lý: $e');
    }
  }

  StatisticEntity _emptyData() => const StatisticEntity(
      totalRevenue: 0, totalOrders: 0, totalShippingFee: 0, chartData: {});
}