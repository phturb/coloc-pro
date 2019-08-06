import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JoinGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group'),
      ),
      body: JoinGroupFrom(),
    );
  }
}

class JoinGroupFrom extends StatefulWidget {
  @override
  _JoinGroupFromState createState() => _JoinGroupFromState();
}

class _JoinGroupFromState extends State<JoinGroupFrom> {
  final TextEditingController groupNameController = TextEditingController();
  static final RegExp validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Row(
          children: <Widget>[
            Text('Group ID :'),
            Flexible(
              child: TextFormField(
                controller: groupNameController,
                decoration: InputDecoration(labelText: 'Enter the group ID'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (validCharacters.hasMatch(value)) {
                    return 'Please enter a valid group ID';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
