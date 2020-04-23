import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pengyou/views/dictionary/search/bloc/DictionarySearchEvent.dart';
import 'package:pengyou/views/dictionary/search/bloc/DictionarySearchState.dart';
import 'package:pengyou/views/dictionary/search/bloc/dictionarySearchBloc.dart';
import 'package:pengyou/views/reusable/entryList.dart';

class DictionarySearchView extends StatefulWidget {
  @override
  State<DictionarySearchView> createState() => _DictionarySearchViewState();
}

class _DictionarySearchViewState extends State<DictionarySearchView> {
  DictionarySearchBloc _bloc;

  TextEditingController _searchQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<DictionarySearchBloc>(context);
    _searchQueryController.addListener(_onQueryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DictionarySearchBloc, DictionarySearchState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchQueryController,
              autofocus: true,
            ),
          ),
          body: EntryList(
            entryList: state.chineseSearchResults,
          ),
        );
      },
    );
  }

  void _onQueryChanged() {
    _bloc.add(SearchQueryChanged(query: _searchQueryController.text));
  }
}
