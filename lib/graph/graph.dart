import 'dart:math';

import 'package:colocpro/graph/graph_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'graph_middleLine.dart';

const List<Color> listOfColor = <Color>[
  Colors.red,
  Colors.blue,
  Colors.orange,
  Colors.green
];

class GraphWidget extends StatefulWidget {
  GraphWidget(this.deptPerMember, {this.width = 100, this.height = 100});
  final Map<String, double> deptPerMember;
  final double width;
  final double height;
  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  _GraphWidgetState();

  double maxDept;
  Map<String, double> graphLengthMap = Map<String, double>();
  List<CustomPaint> listOfBar = <CustomPaint>[];

  @override
  void initState() {
    super.initState();
    maxDept = 0;
    for (var dept in widget.deptPerMember.values) {
      maxDept = max(dept.abs(), maxDept.abs());
    }
    int colorIndex = 0;
    widget.deptPerMember.forEach((String username, double dept) {
      graphLengthMap[username] = widget.height / 2 * dept / maxDept;
      listOfBar.add(CustomPaint(
        painter: GraphLine(graphLengthMap[username], listOfColor[colorIndex++]),
        size: Size(10, widget.height),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: listOfBar,
            ),
            CustomPaint(
              painter: GraphMiddleLine(),
              size: Size(widget.width, widget.height),
            ),
          ],
        ));
  }
}
