import 'statistic.dart';

abstract class StatisticEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchStatisticEvent extends StatisticEvent {
  final String token;
  final String timeRange;
  final String status;

  FetchStatisticEvent(this.token, this.timeRange, this.status);

  @override
  List<Object> get props => [token, timeRange, status];
}
