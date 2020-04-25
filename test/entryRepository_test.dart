import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pengyou/dataSources/appDatabase.dart';
import 'package:pengyou/repositories/EntryRepository.dart';

class MockDatabase extends Mock implements DBProvider {}

void main() {
  group('Chinese query cleaning', () {
    final mockDb = MockDatabase();
    final repository = EntryRepository(db: mockDb);

    test('Replace ü with u:', () {
      expect(repository.cleanChineseSearchQuery("abcüdef"), "abcu:def");
    });

    test('Replace v with u:', () {
      expect(repository.cleanChineseSearchQuery("abcvdef"), "abcu:def");
    });

    test('Remove white spaces', () {
      expect(repository.cleanChineseSearchQuery(" a b c "), "abc");
      // Also check whitespaces when using Chinese input (are the white spaces even different?)
      expect(repository.cleanChineseSearchQuery(" 擬 額哦 拉 "), "擬額哦拉");
    });

    test('Convert to lower case', () {
      expect(repository.cleanChineseSearchQuery("A你b我C"), "a你b我c");
    });

    test('All at once', () {
      expect(repository.cleanChineseSearchQuery(' Ü 你V 我 c '), "u:你u:我c");
    });
  });
}
