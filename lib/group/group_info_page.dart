import 'package:colocpro/graph/graph.dart';
import 'package:colocpro/group/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class GroupInfoPage extends StatefulWidget {
  GroupInfoPage(this.group);
  final Group group;
  @override
  _GroupInfoPageState createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  _GroupInfoPageState();

  @override
  Widget build(BuildContext context) {
    widget.group.calculateDept();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              widget.group.groupName,
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: GraphWidget(widget.group.mapOfDeptOfUsers),
            ),
          ],
        ),
        Flexible(
          child: ListView.builder(
            itemCount: widget.group.listOfUser.length,
            itemBuilder: (BuildContext buildContext, int index) {
              return ListTile(
                title: Text(widget.group.listOfUser[index]),
                trailing: Text(widget
                    .group.mapOfDeptOfUsers[widget.group.listOfUser[index]]
                    .toStringAsFixed(2)),
              );
            },
          ),
        ),
        RaisedButton(
          child: Text('Copy Group ID'),
          onPressed: () =>
              Clipboard.setData(new ClipboardData(text: widget.group.groupId)),
        ),
      ],
    );
  }

  void dept() {
    widget.group.calculateDept();
  }
}
