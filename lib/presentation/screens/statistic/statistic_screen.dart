import 'statistic.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  String _selectedRange = 'month';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final token = authState.authToken.token;
      if (token != null) {
        context.read<StatisticBloc>().add(
          FetchStatisticEvent(token, _selectedRange),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê Doanh Thu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterRow(),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<StatisticBloc, StatisticState>(
                builder: (context, state) {
                  if (state is StatisticLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StatisticError) {
                    return Center(
                        child: Text('Lỗi: ${state.message}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red))
                    );
                  } else if (state is StatisticLoaded) {
                    return ListView(
                      children: [
                        _buildStatCard(
                          title: 'Tổng Doanh Thu',
                          value: '${state.data.totalRevenue.toStringAsFixed(0)} đ',
                          icon: Icons.monetization_on,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          title: 'Tổng Đơn Hàng',
                          value: '${state.data.totalOrders} đơn',
                          icon: Icons.shopping_bag,
                          color: Colors.blue,
                        ),
                      ],
                    );
                  }
                  return const Center(child: Text('Đang đợi dữ liệu...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Lọc theo:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: _selectedRange,
          items: const [
            DropdownMenuItem(value: 'month', child: Text('Tháng này')),
            DropdownMenuItem(value: 'quarter', child: Text('Quý này')),
            DropdownMenuItem(value: 'year', child: Text('Năm nay')),
          ],
          onChanged: (value) {
            if (value != null && value != _selectedRange) {
              setState(() => _selectedRange = value);
              _loadData();
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}