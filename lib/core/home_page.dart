import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colocpro/auth/user.dart';
import 'package:colocpro/chat/chat_room.dart';
import 'package:colocpro/auth/base_auth.dart';
import 'package:colocpro/core/drawer_item.dart';
import 'package:colocpro/group/group.dart';
import 'package:colocpro/group/group_info_page.dart';
import 'package:colocpro/purchase_page/purchase_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final String userEmail;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final User user;

  HomePage(
      {Key key,
      this.auth,
      this.userId,
      this.userEmail,
      this.onSignedOut,
      this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 1;

  List<DrawerItem> drawerItem = <DrawerItem>[
    DrawerItem(Icons.shopping_basket, 'Page 1'),
    DrawerItem(Icons.invert_colors, 'Page 2'),
    DrawerItem(Icons.pets, 'Page 3'),
    DrawerItem(Icons.stars, 'Page 4')
  ];

  Group group;

  String pageTitle = "Group Purchases";

  Future<Null> setGroup() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.clear();
    dynamic g = sharedUser.get('group');
    if (g == null) {
      Group tempGroup = Group(
          groupName: 'testGroup',
          listOfUser: List<User>()
            ..add(User(name: 'Phil', familyName: 'Turn', username: 'turn'))
            ..add(User(name: 'Steph', familyName: 'Vidg', username: 'queen'))
            ..add(User(name: 'Alpha', familyName: 'Beta', username: 'romeo')));
      print(jsonEncode(tempGroup.toJson()));
      sharedUser.setString('group', jsonEncode(tempGroup.toJson()));
      setState(() {
        group = tempGroup;
      });
    } else {
      setState(() {
        group = Group.fromJson(jsonDecode(g));
      });
    }
  }

  initState() {
    super.initState();
    setGroup();
  }

  bool loaded() => group != null;

  ListTile drawerListTile(DrawerItem di, VoidCallback callback, int i) {
    return ListTile(
      leading: new Icon(di.icon),
      title: new Text(
        di.title,
        style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
      ),
      selected: i == _index,
      onTap: () {
        setState(() {
          _index = i;
        });
        callback();
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.username),
              accountEmail: Text(widget.userEmail),
            ),
            Column(
              children: <Widget>[
                drawerListTile(DrawerItem(Icons.shopping_basket, 'Purchases'),
                    () => setState(() => pageTitle = "Group Purchases"), 3),
                drawerListTile(DrawerItem(Icons.chat_bubble_outline, 'Chat'),
                    () => setState(() => pageTitle = "Chat"), 2),
                drawerListTile(DrawerItem(Icons.pets, 'WIP'),
                    () => setState(() => pageTitle = "Page 3"), 1),
                drawerListTile(DrawerItem(Icons.group, 'Group Info'),
                    () => setState(() => pageTitle = "Group Info"), 4),
                ListTile(title: Text('SignOut'), onTap: _signOut),
              ],
            ),
          ],
        ),
      ),
      body: !loaded()
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildPage(),
    );
  }

  Widget buildPage() {
    switch (_index) {
      case 1:
        var test = Firestore.instance
            .collection('acounts')
            .document('testid')
            .snapshots()
            .single;
        print(test);
        return Center(child: Text(test.toString()));
      case 2:
        return ChatRoom(groupChatId: "TestGroup", userId: widget.userId);
      case 3:
        return PurchasePage(group);
      case 4:
        return GroupInfoPage(group);
      default:
        return GroupInfoPage(group);
    }
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}
