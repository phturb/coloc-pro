import 'dart:convert';
import 'package:colocpro/auth/user.dart';
import 'package:colocpro/group/group.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupInfoPage extends StatefulWidget {
  @override
  _GroupInfoPageState createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  _GroupInfoPageState() {
    getGroup().then((Group g) => setState(() {
          group = g;
        }));
  }

  Group group;

  Future<Group> getGroup() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    dynamic g = sharedUser.get('group');
    if (g == null) {
      Group tempGroup = Group(
          groupName: 'testGroup',
          listOfMembers: Set<User>()
            ..add(User(name: 'Phil', familyName: 'Turn', username: 'turn'))
            ..add(User(name: 'Steph', familyName: 'Vidg', username: 'queen'))
            ..add(User(name: 'Alpha', familyName: 'Beta', username: 'romeo')));
      print(jsonEncode(tempGroup.toJson()));
      sharedUser.setString('group', jsonEncode(tempGroup.toJson()));
      return tempGroup;
    } else {
      return Group.fromJson(jsonDecode(g));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(group == null ? 'Temp ' : group.toString());
  }
}
