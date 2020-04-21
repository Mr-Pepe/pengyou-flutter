import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EntryList extends StatefulWidget {
  List<String> entryList;

  EntryList({this.entryList});

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
        return ListTile(
          title: Text(widget.entryList[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
