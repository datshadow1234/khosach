import 'statistic.dart';

abstract class StatisticState extends Equatable {
  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}
class StatisticLoading extends StatisticState {}
class StatisticLoaded extends StatisticState {
  final StatisticEntity data;
  final String currentTimeRange;
  StatisticLoaded(this.data, this.currentTimeRange);

  @override
  List<Object> get props => [data, currentTimeRange];
}
class StatisticError extends StatisticState {
  final String message;
  StatisticError(this.message);

  @override
  List<Object> get props => [message];
}