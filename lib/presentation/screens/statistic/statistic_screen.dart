import 'package:intl/intl.dart';
import 'statistic.dart';

class StatisticScreen extends HookWidget {
  const StatisticScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final selectedRange = useState('month');
    final selectedStatus = useState('all');

    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
      decimalDigits: 0,
    );
    void loadData() {
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        final token = authState.authToken.token;
        if (token != null) {
          BlocProvider.of<StatisticBloc>(context).add(
            FetchStatisticEvent(
              token,
              selectedRange.value,
              selectedStatus.value,
            ),
          );
        }
      }
    }
    useEffect(() {
      loadData();
      return null;
    }, [selectedRange.value, selectedStatus.value]);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Thống Kê Doanh Thu'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<StatisticBloc, StatisticState>(
        builder: (context, state) {
          if (state is StatisticLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatisticError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text('Lỗi: ${state.message}'),
                  TextButton(onPressed: loadData, child: const Text('Thử lại')),
                ],
              ),
            );
          }

          if (state is StatisticLoaded) {
            final data = state.data;
            final chartKeys = data.chartData.keys.toList();

            return RefreshIndicator(
              onRefresh: () async => loadData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildFilterRow(selectedRange, selectedStatus),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Doanh thu',
                            formatter.format(data.totalRevenue),
                            Icons.monetization_on,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<OrderBloc>(context),
                                    child: const OrderStatusScreen(),
                                  ),
                                ),
                              );
                            },
                            child: _buildStatCard(
                              'Đơn hàng',
                              '${data.totalOrders}',
                              Icons.shopping_bag,
                              Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Phí vận chuyển',
                      formatter.format(data.totalShippingFee),
                      Icons.local_shipping,
                      Colors.orange,
                    ),
                    const SizedBox(height: 30),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Biểu đồ tăng trưởng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildChart(data.chartData, chartKeys),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
  Widget _buildFilterRow(
    ValueNotifier<String> selectedRange,
    ValueNotifier<String> selectedStatus,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDropdownItem(
            label: 'Thời gian:',
            value: selectedRange.value,
            items: const [
              DropdownMenuItem(value: 'month', child: Text('Tháng này')),
              DropdownMenuItem(value: 'quarter', child: Text('Quý này(3th)')),
              DropdownMenuItem(value: 'year', child: Text('Năm nay')),
            ],
            onChanged: (val) => selectedRange.value = val!,
          ),
          const Divider(),

          _buildDropdownItem(
            label: 'Trạng thái:',
            value: selectedStatus.value,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Tất cả đơn')),
              DropdownMenuItem(value: 'placed', child: Text('Đã đặt')),
              DropdownMenuItem(value: 'preparing', child: Text('Đang chuẩn bị')),
              DropdownMenuItem(value: 'delivering', child: Text('Đang giao')),
              DropdownMenuItem(value: 'completed', child: Text('Thành công')),
            ],
            onChanged: (val) => selectedStatus.value = val!,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(Map<String, double> chartData, List<String> keys) {
    if (chartData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Không có dữ liệu')),
      );
    }
    final maxVal = chartData.values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarChart(
        BarChartData(
          maxY: maxVal == 0 ? 100 : maxVal * 1.3,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueAccent.withOpacity(0.9),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  NumberFormat.compact().format(rod.toY),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, m) {
                  final index = v.toInt();
                  if (index >= 0 && index < keys.length) {
                    return SideTitleWidget(
                      meta: m,
                      child: Text(
                        keys[index],
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (v, m) => Text(
                  NumberFormat.compact().format(v),
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ),
            ),
          ),
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            keys.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: chartData[keys[i]]!,
                  color: Colors.blueAccent.withOpacity(0.7),
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
