import 'repositories_widget.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final OrderClient orderClient;

  StatisticRepositoryImpl({required this.orderClient});

  @override
  Future<StatisticEntity> getStatistics(String token, String timeRange) async {
    try {
      final response = await orderClient.getOrders(token, null, null);

      if (response == null) {
        return const StatisticEntity(totalRevenue: 0, totalOrders: 0);
      }

      double revenue = 0;
      int ordersCount = 0;
      final now = DateTime.now();

      final Map<String, dynamic> ordersMap;
      if (response is List) {
        ordersMap = response.asMap().map((key, value) => MapEntry(key.toString(), value));
      } else {
        ordersMap = Map<String, dynamic>.from(response);
      }

      ordersMap.forEach((key, value) {
        if (value == null) return;
        final orderData = Map<String, dynamic>.from(value);

        final String? dateStr = orderData['orderDate'];
        final DateTime orderDate = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();

        bool isMatch = false;
        if (timeRange == 'month') {
          isMatch = orderDate.month == now.month && orderDate.year == now.year;
        } else if (timeRange == 'quarter') {
          final int currentQuarter = (now.month - 1) ~/ 3 + 1;
          final int orderQuarter = (orderDate.month - 1) ~/ 3 + 1;
          isMatch = currentQuarter == orderQuarter && orderDate.year == now.year;
        } else if (timeRange == 'year') {
          isMatch = orderDate.year == now.year;
        }

        if (isMatch) {
          ordersCount++;
          double orderPrice = 0;
          if (orderData['products'] != null) {
            final products = orderData['products'];
            if (products is List) {
              for (var item in products) {
                final itemMap = Map<String, dynamic>.from(item);
                final double p = (itemMap['price'] ?? 0).toDouble();
                final int q = itemMap['quantity'] ?? 1;
                orderPrice += (p * q);
              }
            }
          }
          else {
            orderPrice = (orderData['price'] ?? orderData['totalAmount'] ?? 0).toDouble();
          }

          revenue += orderPrice;
        }
      });

      return StatisticEntity(totalRevenue: revenue, totalOrders: ordersCount);
    } catch (e) {
      throw Exception('Lỗi xử lý dữ liệu: $e');
    }
  }
}