import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key, @required this.groupChatId, @required this.userId}) : super(key: key);
  final String groupChatId;
  final String userId;

  @override
  _ChatRoomState createState() => _ChatRoomState(groupChatId, userId);
}

class _ChatRoomState extends State<ChatRoom> {
  _ChatRoomState(this.groupChatId,this.id);
  final String id;
  SharedPreferences sharedPrefs;
  final String groupChatId;
  bool isLoading;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  var listMessage;

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    // groupChatId = 'TestGroup';

    isLoading = false;

    readLocal();
  }

  readLocal() async {
    sharedPrefs = await SharedPreferences.getInstance();
    // id = sharedPrefs.getString('id') ?? '';
    setState(() {});
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idGroupChat': groupChatId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              document['content'],
              //style: TextStyle(color: const Color(0xff203152);),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
                color: const Color(0xffaeaeae),
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                /*
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(const Color(0xfff5a623)),
                                ),
                                width: 35.0,
                                height: 35.0,
                                padding: EdgeInsets.all(10.0),
                              ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),*/
                Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: const Color(0xff203152),
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))
                          .toString(),
                      style: TextStyle(
                          color: const Color(0xff203152),
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(const Color(0xfff5a623))),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style:
                    TextStyle(color: const Color(0xff203152), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: const Color(0xffaeaeae)),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text),
                color: const Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: const Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(const Color(0xfff5a623))))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xfff5a623),
                        ),
                      ),
                    );
                  default:
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                }
              },
            ),
    );
  }
}
