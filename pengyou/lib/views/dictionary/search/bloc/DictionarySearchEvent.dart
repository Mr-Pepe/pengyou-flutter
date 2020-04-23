
import 'package:equatable/equatable.dart';

abstract class DictionarySearchEvent extends Equatable {
  const DictionarySearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends DictionarySearchEvent {
  final String query;

  const SearchQueryChanged({this.query});

  @override
  List<Object> get props => [query];
}