import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pengyou/models/entry.dart';
import 'package:pengyou/ui/reusable/entryCard.dart';
import 'package:pengyou/values/dimensions.dart';

class EntryList extends StatefulWidget {
  final List<Entry> entryList;

  EntryList({this.entryList});

  @override
  EntryListState createState() => EntryListState();
}

class EntryListState extends State<EntryList> {
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, mediumPadding, 0, 0),
      child: ListView.separated(
        itemCount: widget.entryList.length,
        itemBuilder: (BuildContext context, int index) {
          return EntryCard(widget.entryList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.grey,
        ),
      ),
    );
  }
}
