import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/views/dictionary/search/bloc/DictionarySearchEvent.dart';
import 'package:pengyou/views/dictionary/search/bloc/DictionarySearchState.dart';

class DictionarySearchBloc
    extends Bloc<DictionarySearchEvent, DictionarySearchState> {
  final _entryRepository = EntryRepository();

  @override
  DictionarySearchState get initialState => DictionarySearchState.initial();

  @override
  Stream<DictionarySearchState> mapEventToState(
    DictionarySearchEvent event,
  ) async* {
    if (event is SearchQueryChanged) {
      yield state.copyWith(
        chineseSearchResults: await search(event.query),
      );
    }
  }

  Future<List<Entry>> search(String query) async {
    return _entryRepository.searchForChinese(query);
  }
}
