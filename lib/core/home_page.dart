import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colocpro/auth/user.dart';
import 'package:colocpro/chat/chat_room.dart';
import 'package:colocpro/auth/base_auth.dart';
import 'package:colocpro/core/drawer_item.dart';
import 'package:colocpro/group/group.dart';
import 'package:colocpro/group/group_info_page.dart';
import 'package:colocpro/group/join_group_page.dart';
import 'package:colocpro/group/new_group_page.dart';
import 'package:colocpro/group/no_group_page.dart';
import 'package:colocpro/purchase_page/purchase.dart';
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
  bool newGroup = false;

  String pageTitle = "Group Purchases";

  Future<Null> setGroup() async {
    newGroup = false;
    if (widget.user.currentGroup.isEmpty) {
      setState(() {
        newGroup = true;
      });
      return null;
    } else {
      var doc = await Firestore.instance
          .collection('groups')
          .document(widget.user.mapOfGroup[widget.user.currentGroup])
          .get()
          .catchError((e) {
        setState(() {
          newGroup = true;
        });
        return null;
      });
      if (doc.data != null) {
        setState(() {
          group = Group.fromJson(doc.data);
        });
        var purchaseDoc = await Firestore.instance
            .collection('groups')
            .document(widget.user.mapOfGroup[widget.user.currentGroup])
            .collection('purchases')
            .getDocuments();
        group.listOfPurchaseItems = purchaseDoc.documents
            .map((snapshot) => PurchaseItem.fromJson(snapshot.data))
            .toList();
      } else {
        // SharedPreferences sharedUser = await SharedPreferences.getInstance();
        // dynamic g = sharedUser.get('group');

        // if (g == null) {
        //   setState(() {
        //     newGroup = true;
        //   });
        // } else {
        setState(() {
          newGroup = true;
          // group = Group.fromJson(jsonDecode(g));
        });
      }
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
    if (newGroup == false) {
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
                  drawerListTile(
                      DrawerItem(Icons.group_add, 'Join or Create Group'),
                      () => setState(() => pageTitle = "Group manager"),
                      1),
                  drawerListTile(DrawerItem(Icons.group, 'Group Info'),
                      () => setState(() => pageTitle = "Group Info"), 4),
                  ListTile(title: Text('SignOut'), onTap: _signOut),
                ],
              ),
            ],
          ),
        ),
        body: buildPage(),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Join Group'),
          ),
          body: NoGroupPage(_navigateJoinGroup, _navigateNewGroup));
    }
  }

  Future<void> _joinGroup(String groupId) async {
    var documentReference =
        await Firestore.instance.collection('groups').document(groupId).get();
    List<String> list = List<String>.from(documentReference.data['listOfUser']);
    Set<String> tempList = list.toSet();
    tempList.add(widget.user.username);
    Map<String, dynamic> data;
    data = {'listOfUser': tempList.toList()};
    await Firestore.instance
        .collection('groups')
        .document(groupId)
        .updateData(data);
    setState(() {
      group = Group.fromJson(documentReference.data);
      group.listOfUser.add(widget.user.username);
      widget.user.currentGroup = group.groupName;
      widget.user.mapOfGroup[group.groupName] = group.groupId;
    });
    data = <String, dynamic>{
      'groups': widget.user.mapOfGroup,
      'currentGroup': widget.user.currentGroup
    };
    await Firestore.instance
        .collection('users')
        .document(widget.userId)
        .updateData(data);
    setState(() {
      newGroup = false;
    });
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('group', jsonEncode(group.toJson()));
  }

  Future<void> _navigateJoinGroup(BuildContext context) async {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => JoinGroupPage()))
        .then((dynamic value) {
      if (value != null) {
        _joinGroup(value);
      }
    });
  }

  Future<void> _newGroup(String groupName) async {
    Group tempGroup = Group(
        groupName: groupName,
        listOfUser: List<String>()..add(widget.user.username));
    var documentReference =
        Firestore.instance.collection('groups').document(tempGroup.groupId);

    Map<String, dynamic> data = tempGroup.toJson();
    await documentReference.setData(data);

    widget.user.currentGroup = tempGroup.groupName;
    widget.user.mapOfGroup[tempGroup.groupName] = tempGroup.groupId;

    data = <String, dynamic>{
      'groups': widget.user.mapOfGroup,
      'currentGroup': widget.user.currentGroup
    };
    await Firestore.instance
        .collection('users')
        .document(widget.userId)
        .updateData(data);

    setState(() {
      group = tempGroup;
      newGroup = false;
    });

    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('group', jsonEncode(group.toJson()));
  }

  Future<void> _navigateNewGroup(BuildContext context) async {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NewGroupPage()))
        .then((dynamic value) async {
      if (value != null) {
        _newGroup(value);
      }
    });
  }

  Widget buildPage() {
    if (group != null) {
      switch (_index) {
        case 1:
          return Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text('Change group :'),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Flexible(
                    child: DropdownButton(
                  value: widget.user.currentGroup,
                  items: getDropDownMenuItems(),
                  onChanged: (String groupName) => setState(() {
                    widget.user.currentGroup = groupName;
                    setGroup();
                  }),
                  isExpanded: true,
                )),
              ],
            ),
            Flexible(child: NoGroupPage(_navigateJoinGroup, _navigateNewGroup))
          ]);
        case 2:
          return ChatRoom(groupID: group.groupId, userId: widget.userId);
        case 3:
          return PurchasePage(group);
        case 4:
          return GroupInfoPage(group);
        default:
          return GroupInfoPage(group);
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    widget.user.mapOfGroup.forEach((String groupName, String groupId) {
      items.add(DropdownMenuItem(
        value: groupName,
        child: Text(groupName),
      ));
    });
    return items;
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      sharedUser.clear();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}
