import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/repositories/EntryRepository.dart';

class DictionarySearchViewModel extends ChangeNotifier {
  DictionarySearchViewModel(this._entryRepository);

  final EntryRepository _entryRepository;

  List<Entry> chineseSearchResults = <Entry>[];

  void search(String query) async {
    chineseSearchResults = await _entryRepository.searchForChinese(query);
    notifyListeners();
  }
}
