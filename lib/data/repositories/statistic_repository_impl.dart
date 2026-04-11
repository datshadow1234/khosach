import 'repositories.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final OrderClient orderClient;

  StatisticRepositoryImpl({required this.orderClient});

  @override
  Future<StatisticEntity> getStatistics(String token, String timeRange) async {
    try {
      final response = await orderClient.getOrders(token, null, null);
      if (response == null) return _emptyData();

      double revenue = 0;
      double shippingFee = 0;
      int ordersCount = 0;
      Map<String, double> chartData = {}; // Gom dữ liệu cho biểu đồ
      final now = DateTime.now();

      final Map<String, dynamic> ordersMap = Map<String, dynamic>.from(response);

      ordersMap.forEach((key, value) {
        final orderData = Map<String, dynamic>.from(value);
        final DateTime orderDate = DateTime.parse(orderData['dateTime']);

        bool isMatch = false;
        String chartKey = ""; // Nhãn cho trục X của biểu đồ

        if (timeRange == 'month') {
          isMatch = orderDate.month == now.month && orderDate.year == now.year;
          chartKey = "${orderDate.day}/${orderDate.month}"; // Biểu đồ theo ngày trong tháng
        } else if (timeRange == 'quarter') {
          final currentQuarter = (now.month - 1) ~/ 3 + 1;
          final orderQuarter = (orderDate.month - 1) ~/ 3 + 1;
          isMatch = currentQuarter == orderQuarter && orderDate.year == now.year;
          chartKey = "Tháng ${orderDate.month}"; // Biểu đồ theo tháng trong quý
        } else if (timeRange == 'year') {
          isMatch = orderDate.year == now.year;
          chartKey = "T${orderDate.month}"; // Biểu đồ theo tháng trong năm
        }

        if (isMatch) {
          ordersCount++;
          // 1. Tính phí ship (Giả sử key là 'shippingFee' trong Firebase)
          final sFee = (orderData['shippingFee'] ?? 0).toDouble();
          shippingFee += sFee;

          // 2. Tính doanh thu sản phẩm
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

          // 3. Gom dữ liệu biểu đồ
          chartData[chartKey] = (chartData[chartKey] ?? 0) + orderPrice;
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
      totalRevenue: 0, totalOrders: 0, totalShippingFee: 0, chartData: {}
  );
}