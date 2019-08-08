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
    return Column(
      children: <Widget>[
        Text(
          widget.group == null ? 'Temp ' : widget.group.toString(),
        ),
        RaisedButton(
          child: Text('Copy Group ID'),
          onPressed: () =>
              Clipboard.setData(new ClipboardData(text: widget.group.groupId)),
        )
      ],
    );
  }
}
