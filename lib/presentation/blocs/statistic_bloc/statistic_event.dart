import 'statistic.dart';

abstract class StatisticEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchStatisticEvent extends StatisticEvent {
  final String token;
  final String timeRange; // 'month', 'quarter', 'year'

  FetchStatisticEvent(this.token, this.timeRange);

  @override
  List<Object> get props => [token, timeRange];
}