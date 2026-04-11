import 'search.dart';
abstract class SearchEvent {}

class SearchTextChanged extends SearchEvent {
  final String query;

  SearchTextChanged(this.query);
}