import 'package:colocpro/group/join_group_page.dart';
import 'package:colocpro/group/new_group_page.dart';
import 'package:flutter/material.dart';

class NoGroupPage extends StatelessWidget {
  Future<void> _navigateJoinGroup(BuildContext context) async {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => JoinGroupPage()))
        .then((dynamic value) {
      if (value != null) {
        print('it worked');
      }
    });
  }

  Future<void> _navigateNewGroup(BuildContext context) async {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NewGroupPage()))
        .then((dynamic value) {
      if (value != null) {
        print('it worked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Join a group'),
            onPressed: () => _navigateJoinGroup(context),
          ),
          RaisedButton(
            child: Text('Create a group'),
            onPressed: () => _navigateNewGroup(context),
          ),
        ],
      )),
    );
  }
}
