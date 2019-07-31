import 'package:colocpro/group/group.dart';
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
    return Text(widget.group == null ? 'Temp ' : widget.group.toString());
  }
}
