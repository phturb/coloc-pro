import 'package:flutter/material.dart';

class NoGroupPage extends StatelessWidget {
  NoGroupPage(this._navigateJoinGroup, this._navigateNewGroup);

  final Function _navigateJoinGroup;
  final Function _navigateNewGroup;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Join a group'),
            onPressed: () => _navigateJoinGroup(context),
          ),
          Container(
            height: 10,
          ),
          RaisedButton(
            child: Text('Create a group'),
            onPressed: () => _navigateNewGroup(context),
          ),
        ],
      ),
    );
  }
}
