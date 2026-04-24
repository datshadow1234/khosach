import 'statistic.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final StatisticRepository repository;

  StatisticBloc({required this.repository}) : super(StatisticInitial()) {
    on<FetchStatisticEvent>((event, emit) async {
      emit(StatisticLoading());
      try {
        final data = await repository.getStatistics(
            event.token,
            event.timeRange,
            event.status
        );
        emit(StatisticLoaded(data, event.timeRange));
      } catch (e) {
        emit(StatisticError(e.toString()));
      }
    });
  }
}