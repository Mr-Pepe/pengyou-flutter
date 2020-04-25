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

    group('Simplify Chinese search query', () {

      when(mockDb.getTraditionalToSimplifiedCharacters(any))
          .thenAnswer((_) async => Future.value(''));
      when(mockDb.getTraditionalToSimplifiedCharacters('𫷷'))
          .thenAnswer((_) async => Future.value(''));
      when(mockDb.getTraditionalToSimplifiedCharacters('亂'))
          .thenAnswer((_) async => Future.value('乱'));
      when(mockDb.getTraditionalToSimplifiedCharacters('一目瞭然'))
          .thenAnswer((_) async => Future.value('一目了然'));
      when(mockDb.getTraditionalToSimplifiedCharacters('乾'))
          .thenAnswer((_) async => Future.value('干,乾'));
      when(mockDb.getTraditionalToSimplifiedCharacters('淨'))
          .thenAnswer((_) async => Future.value('净'));

      when(mockDb.getTraditionalToSimplifiedPhrases(any))
          .thenAnswer((_) async => Future.value(''));
      when(mockDb.getTraditionalToSimplifiedPhrases('情有獨鍾'))
          .thenAnswer((_) async => Future.value('情有独钟 情有独锺'));
      when(mockDb.getTraditionalToSimplifiedPhrases('乾乾淨淨'))
          .thenAnswer((_) async => Future.value('干干净净'));
      when(mockDb.getTraditionalToSimplifiedPhrases('一目瞭然'))
          .thenAnswer((_) async => Future.value('一目了然'));

      

      test('Simplify character', () async {
        expect(await repository.getSimplifiedQueries('亂'), ['乱']);
        expect(await repository.getSimplifiedQueries('𫷷'), ['𫷷']);
      });

      test('Simplify phrase 1', () async {
        expect((await repository.getSimplifiedQueries('一目瞭然')).contains('一目了然'),
            true);
      });

      test('Simplify phrase 2', () async {
        final simplifiedQueries = await repository.getSimplifiedQueries('情有獨鍾');
        expect(simplifiedQueries.length, 2); 
        expect(simplifiedQueries.contains('情有独钟'), true);
        expect(simplifiedQueries.contains('情有独锺'), true);
      });

      test('Simplify ambiguous input', () async {
        // Some traditional characters map to more than one simplified character
        expect(await repository.getSimplifiedQueries('乾'), ['干', '乾']);
      });

      test('All at once', () async {
        final simplifiedQueries = await repository.getSimplifiedQueries('乾乾淨淨');
        expect(simplifiedQueries.length, 1);
        expect(simplifiedQueries.contains('干干净净'), true);
      });

      test('All at once', () async {
        final simplifiedQueries = await repository.getSimplifiedQueries('亂乾𫷷');
        expect(simplifiedQueries.length, 2);
        expect(simplifiedQueries.contains('乱干𫷷'), true);
        expect(simplifiedQueries.contains('乱乾𫷷'), true);
      });
    });
  });
}
