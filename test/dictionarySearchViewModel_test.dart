import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/repositories/EntryRepository.dart';
import 'package:pengyou/viewModels/dictionarySearchViewModel.dart';

class MockEntryRepository extends Mock implements EntryRepository {}

void main() {
  Entry mockEntry = Entry(
      id: 112374,
      simplified: "飞",
      traditional: "飛",
      pinyin: "fei1",
      priority: 1243.0,
      hsk: 7,
      wordLength: 1,
      pinyinLength: 4,
      definitions: "to fly");


  final mockEntryRepository = MockEntryRepository();
  final model = DictionarySearchViewModel(mockEntryRepository);

  when(mockEntryRepository.searchForChinese("fei"))
        .thenAnswer((_) => Stream.value([mockEntry]));
  when(mockEntryRepository.searchForEnglish("fei"))
        .thenAnswer((_) async => Future.value([mockEntry]));
  when(mockEntryRepository.searchForEnglish("*fei*"))
        .thenAnswer((_) async => Future.value([mockEntry, mockEntry]));
  
  test('Search', () async {
    await model.search("fei");

    expect(model.chineseSearchResults.length, 1);
    // Duplicates should be removed
    expect(model.englishSearchResults.length, 1);
  });
}
