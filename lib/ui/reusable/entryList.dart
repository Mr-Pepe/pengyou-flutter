import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/ui/reusable/entryCard.dart';
import 'package:pengyou/values/theme.dart';
import 'package:provider/provider.dart';

class EntryList extends StatefulWidget {
  final List<Entry> entryList;
  final int intonationMode;

  EntryList({this.entryList, this.intonationMode});

  @override
  EntryListState createState() => EntryListState();
}

class EntryListState extends State<EntryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.all(0),
        itemCount: widget.entryList.length,
        itemBuilder: (BuildContext context, int index) {
          return EntryCard(widget.entryList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
          color: Provider.of<ExtendedAppTheme>(context).separatorColor,
        ),
    );
  }
}
