import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';

class DictionarySearchViewModel extends ChangeNotifier {
  DictionarySearchViewModel(this._entryRepository);

  final EntryRepository _entryRepository;

  List<Entry> _chineseSearchResults = <Entry>[];
  List<Entry> get chineseSearchResults => _chineseSearchResults;
  List<Entry> _englishSearchResults = <Entry>[];
  List<Entry> get englishSearchResults => _englishSearchResults;

  int searchMode = SearchMode.byChineseInDictionary;

  Future<void> search(String query) async {
    searchChineseInDict(query);
    searchEnglishInDict(query);
  }

  Future<void> searchChineseInDict(String query) async {
    _chineseSearchResults = await _entryRepository.searchForChinese(query);
    notifyListeners();
  }

  Future<void> searchEnglishInDict(String query) async {
    _englishSearchResults = await _entryRepository.searchForEnglish(query);
    notifyListeners();
  }

  void setSearchMode(int mode) {
    searchMode = mode;
    notifyListeners();
  }
}
