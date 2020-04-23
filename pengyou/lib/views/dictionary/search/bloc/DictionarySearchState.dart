import 'package:equatable/equatable.dart';
import 'package:pengyou/models/entry.dart';

class DictionarySearchState extends Equatable {
  final List<Entry> chineseSearchResults;

  const DictionarySearchState({
    this.chineseSearchResults,
  });

  factory DictionarySearchState.initial() {
    return DictionarySearchState(
      chineseSearchResults: <Entry>[],
    );
  }

  DictionarySearchState copyWith({
    List<Entry> chineseSearchResults,
  }) {
    return DictionarySearchState(
      chineseSearchResults: chineseSearchResults ?? this.chineseSearchResults,
    );
  }

  @override
  List<Object> get props => [
        chineseSearchResults,
      ];
}
