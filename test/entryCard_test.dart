import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/ui/reusable/entryCard.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/utils/utils.dart';
import 'package:pengyou/values/colors.dart';
import 'package:provider/provider.dart';

class MockPrefs extends Mock implements AppPreferences {}

void main() {
  final mockEntry1 = Entry(
      id: 4300,
      simplified: "事实",
      traditional: "事實",
      pinyin: "shi4 shi2",
      priority: 383.5,
      hsk: 5,
      wordLength: 2,
      pinyinLength: 9,
      definitions: "fact/measure word: §個|个§[ge4]");

  final mockEntry2 = Entry(
      id: 4300,
      simplified: "事实",
      traditional: "事實",
      pinyin: "shi4 shi2",
      priority: 383.5,
      hsk: 7,
      wordLength: 2,
      pinyinLength: 9,
      definitions: "fact/measure word: §個|个§[ge4]");

  final mockPrefs = MockPrefs();
  List<Color> toneColors = [
    tone1DefaultColor,
    tone2DefaultColor,
    tone3DefaultColor,
    tone4DefaultColor,
    tone5DefaultColor
  ];
  when(mockPrefs.getToneColors()).thenReturn(toneColors);

  testWidgets('Entry card using simplified headword, tone marks, and HSK tag',
      (WidgetTester tester) async {
    when(mockPrefs.chineseMode).thenReturn(ChineseMode.simplified);
    when(mockPrefs.intonationMode).thenReturn(IntonationMode.pinyinMarks);
    when(mockPrefs.showHskLabels).thenReturn(true);
    when(mockPrefs.alternativeHeadwordScalingFactor).thenReturn(0.8);

    await tester.pumpWidget(ChangeNotifierProvider<AppPreferences>.value(
        value: mockPrefs,
        child: Directionality(
          child: EntryCard(mockEntry1),
          textDirection: TextDirection.ltr,
        )));

    final headwordFinder = find
        .byWidgetPredicate((widget) => fromRichTextToPlainText(widget) == '事实');
    final pinyinFinder = find.byWidgetPredicate(
        (widget) => fromRichTextToPlainText(widget) == 'shìshí');
    final hskFinder = find.byWidgetPredicate(
        (widget) => fromRichTextToPlainText(widget) == 'HSK 5');
    final definitionFinder = find.byWidgetPredicate((widget) =>
        fromRichTextToPlainText(widget) == '1 fact 2 measure word: 个 [gè]');

    expect(headwordFinder, findsOneWidget);
    expect(pinyinFinder, findsOneWidget);
    expect(hskFinder, findsOneWidget);
    expect(definitionFinder, findsOneWidget);
  });

  testWidgets(
      'Entry card using traditional and smaller alternative simple headword, number notation, and no HSK tag',
      (WidgetTester tester) async {
    when(mockPrefs.chineseMode).thenReturn(ChineseMode.traditionalSimplified);
    when(mockPrefs.intonationMode).thenReturn(IntonationMode.pinyinNumbers);
    when(mockPrefs.showHskLabels).thenReturn(true);
    when(mockPrefs.alternativeHeadwordScalingFactor).thenReturn(0.8);

    await tester.pumpWidget(ChangeNotifierProvider<AppPreferences>.value(
        value: mockPrefs,
        child: Directionality(
          child: EntryCard(mockEntry2),
          textDirection: TextDirection.ltr,
        )));

    final headwordFinder = find.byWidgetPredicate(
        (widget) => fromRichTextToPlainText(widget) == '事實 (事实)');
    final pinyinFinder = find.byWidgetPredicate(
        (widget) => fromRichTextToPlainText(widget) == 'shi4 shi2');
    final hskFinder = find.byWidgetPredicate(
        (widget) => (fromRichTextToPlainText(widget) ?? '').contains('HSK'));
    final definitionFinder = find.byWidgetPredicate((widget) =>
        fromRichTextToPlainText(widget) == '1 fact 2 measure word: 個(个) [gè]');

    expect(headwordFinder, findsOneWidget);
    expect(pinyinFinder, findsOneWidget);
    expect(hskFinder, findsNothing);
    expect(definitionFinder, findsOneWidget);
  });

  testWidgets(
      // TODO: Test Zhuyin here once implemented
      'Entry card using traditional, mark notation, and disabled HSK tag',
      (WidgetTester tester) async {
    when(mockPrefs.chineseMode).thenReturn(ChineseMode.traditional);
    when(mockPrefs.intonationMode).thenReturn(IntonationMode.pinyinMarks);
    when(mockPrefs.showHskLabels).thenReturn(false);
    when(mockPrefs.alternativeHeadwordScalingFactor).thenReturn(0.8);

    await tester.pumpWidget(ChangeNotifierProvider<AppPreferences>.value(
        value: mockPrefs,
        child: Directionality(
          child: EntryCard(mockEntry1),
          textDirection: TextDirection.ltr,
        )));

    final headwordFinder = find.byWidgetPredicate(
        (widget) => fromRichTextToPlainText(widget) == '事實');
    final pinyinFinder = find.byWidgetPredicate(
        (widget) => fromRichTextToPlainText(widget) == 'shìshí');
    final hskFinder = find.byWidgetPredicate(
        (widget) => (fromRichTextToPlainText(widget) ?? '').contains('HSK'));
    final definitionFinder = find.byWidgetPredicate((widget) =>
        fromRichTextToPlainText(widget) == '1 fact 2 measure word: 個(个) [gè]');

    expect(headwordFinder, findsOneWidget);
    expect(pinyinFinder, findsOneWidget);
    expect(hskFinder, findsNothing);
    expect(definitionFinder, findsOneWidget);
  });
}
