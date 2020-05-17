import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/utils/enumsAndConstants.dart';
import 'package:pengyou/values/strings.dart';

String fromRichTextToPlainText(final Widget widget) {
  if (widget is RichText) {
    if (widget.text is TextSpan) {
      final buffer = StringBuffer();
      (widget.text as TextSpan).computeToPlainText(buffer);
      return buffer.toString();
    }
  }
  return null;
}

void copyHeadwordToClipboard(Entry entry, int chineseMode) {
  final indicator = '(' +
      (chineseMode == ChineseMode.simplified ||
              chineseMode == ChineseMode.simplifiedTraditional
          ? AppStrings.simplified
          : AppStrings.traditional) +
      ')';

  final headword = chineseMode == ChineseMode.simplified ||
          chineseMode == ChineseMode.simplifiedTraditional
      ? entry.simplified
      : entry.traditional;

  Clipboard.setData(ClipboardData(text: headword));
  Fluttertoast.showToast(
    msg: 'Copied ' + headword + ' ' + indicator + ' to clipboard.',
    toastLength: Toast.LENGTH_SHORT,
  );
}
