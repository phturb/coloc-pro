import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colocpro/chat/chat_room.dart';
import 'package:colocpro/auth/base_auth.dart';
import 'package:flutter/material.dart';

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

class DrawerItems {
  DrawerItems(this.icon, this.title);

  final IconData icon;
  final String title;
}

class _HomePageState extends State<HomePage> {
  int _index = 1;

  List<DrawerItems> drawerItems = <DrawerItems>[
    DrawerItems(Icons.shopping_basket, 'Page 1'),
    DrawerItems(Icons.invert_colors, 'Page 2'),
    DrawerItems(Icons.pets, 'Page 3'),
    DrawerItems(Icons.stars, 'Page 4')
  ];

  ListTile drawerListTile(DrawerItems di, VoidCallback callback, int i) {
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
        Navigator.of(context).pop();
        callback();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cool Kid"),
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
                drawerListTile(DrawerItems(Icons.shopping_basket, 'Page 1'),
                    () => print("Page 1"), 1),
                drawerListTile(DrawerItems(Icons.chat_bubble_outline, 'Group Chat'),
                    () => print("Chat"), 2),
                drawerListTile(DrawerItems(Icons.pets, 'Page 3'),
                    () => print("Page 3"), 3),
                drawerListTile(DrawerItems(Icons.stars, 'Page 4'),
                    () => print("Page 4"), 4),
                ListTile(title: Text('SignOut'), onTap: _signOut),
              ],
            ),
          ],
        ),
      ),
      body: buildPage(),
    );
  }

  Widget buildPage() {
    switch (_index) {
      case 1:
        var test = Firestore.instance.collection('acounts').document('testid').snapshots().single;
        print(test);
        return Center(child: Text(test.toString()));
      case 2:
        return ChatRoom(groupChatId: "TestGroup", userId: widget.userId);
      default:
        return Center(child: Text('Page with index '+_index.toString()+' in progress...'));
    }
  }

  Future<String> test() async {
    var test = await Firestore.instance.collection('acounts').document('testid').snapshots().single;
    return test.data.toString();
  }
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}
