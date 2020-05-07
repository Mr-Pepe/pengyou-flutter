import 'dart:async';
import 'dart:collection';

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

  StreamSubscription<List<Entry>> _chineseResultsSubscription;
  StreamSubscription<List<Entry>> _englishResultsSubscription1;
  StreamSubscription<List<Entry>> _englishResultsSubscription2;

  Future<void> search(String query) async {
    searchChineseInDict(query);
    searchEnglishInDict(query);
  }

  Future<void> searchChineseInDict(String query) async {
    _chineseResultsSubscription?.cancel();

    _chineseResultsSubscription = _entryRepository.searchForChinese(query).listen((List<Entry> results) {
      _chineseSearchResults = sortChineseSearchResults(results);
      notifyListeners();
    });
  }

  Future<void> searchEnglishInDict(String query) async {

    _englishResultsSubscription1?.cancel();
    _englishResultsSubscription2?.cancel();

    _englishResultsSubscription1 = _entryRepository.searchForEnglish(query).asStream().listen((List<Entry> results) {
      _englishSearchResults = results;
      if (_englishSearchResults.isNotEmpty) {
        notifyListeners();
      }


      _englishResultsSubscription2 = _entryRepository.searchForEnglish('*' + query + '*').asStream().listen((List<Entry> wildCardResults) {
        _englishSearchResults.addAll(wildCardResults);
        _englishSearchResults = LinkedHashSet<Entry>.from(_englishSearchResults).toList();
        notifyListeners();
      });
    });

  }

  void setSearchMode(int mode) {
    searchMode = mode;
    notifyListeners();
  }

  List<Entry> sortChineseSearchResults(List<Entry> results) {
    results.sort((a, b) {
        final wordLengthComparison = a.wordLength.compareTo(b.wordLength);
        if (wordLengthComparison != 0) {
          return wordLengthComparison;
        }
        else {
          final hskComparison = a.hsk.compareTo(b.hsk);
          if (hskComparison != 0) {
            return hskComparison;
          }
          else {
            final pinyinLengthComparison = a.pinyinLength.compareTo(b.pinyinLength);

            if (pinyinLengthComparison != 0) {
              return pinyinLengthComparison;
            }
            else {
              return a.priority.compareTo(b.priority);
            }
          }
        }
      });
    
    return results;
  }
}
