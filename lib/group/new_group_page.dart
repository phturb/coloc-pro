import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group'),
      ),
      body: NewGroupFrom(),
    );
  }
}

class NewGroupFrom extends StatefulWidget {
  @override
  _NewGroupFromState createState() => _NewGroupFromState();
}

class _NewGroupFromState extends State<NewGroupFrom> {
  final TextEditingController groupNameController = TextEditingController();
  static final RegExp validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Text('Group Name :'),
                  Container(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: groupNameController,
                      decoration:
                          InputDecoration(labelText: 'Enter the group name'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (validCharacters.hasMatch(value)) {
                          return null;
                        }
                        return 'Please enter a valid group name';
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Creating the ${groupNameController.text} group')));
                  Navigator.pop(context, groupNameController.text);
                }
              },
              child: Text('Create new group'),
            ),
          ],
        ),
      ),
    );
  }
}
