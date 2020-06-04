import 'package:flutter/widgets.dart';
import 'package:pengyou/utils/appPreferences.dart';
import 'package:pengyou/utils/formatting.dart';
import 'package:pengyou/values/dimensions.dart';
import 'package:pengyou/values/strings.dart';
import 'package:provider/provider.dart';

class DefinitionsView extends StatefulWidget {
  DefinitionsView(this.definitions);

  final String definitions;

  @override
  _DefinitionsViewState createState() => _DefinitionsViewState();
}

class _DefinitionsViewState extends State<DefinitionsView> {
  List<TextSpan> formattedDefinitions;
  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<AppPreferences>(context);

    if (formattedDefinitions == null) {
      formattedDefinitions = formatDefinitions(widget.definitions,
          prefs.chineseMode, prefs.intonationMode);
    }

    if (formattedDefinitions.isEmpty) {
      return Center(child: Text(AppStrings.noDefinitionsFound));
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(materialStandardPadding,
            materialStandardPadding, materialStandardPadding, 0),
        child: Table(
          columnWidths: {0: IntrinsicColumnWidth()},
          children: <TableRow>[
            ...List.generate(
              formattedDefinitions.length,
              (index) => TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: wordViewDefinitionFontSize),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: smallPadding),
                    child: Text.rich(
                      formattedDefinitions[index],
                      style: TextStyle(fontSize: wordViewDefinitionFontSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
