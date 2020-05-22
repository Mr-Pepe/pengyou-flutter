import 'package:flutter/widgets.dart';

class StrokeOrderDiagram extends StatefulWidget {
  @override
  _StrokeOrderDiagramState createState() => _StrokeOrderDiagramState();

  StrokeOrderDiagram(this.strokeOrder);

  final String strokeOrder;
}

class _StrokeOrderDiagramState extends State<StrokeOrderDiagram> {
  @override
  Widget build(BuildContext context) {
    return (Center(child: Text(widget.strokeOrder),));
  }
}