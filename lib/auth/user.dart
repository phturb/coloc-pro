import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
      {this.username,
      this.name,
      this.familyName,
      this.currentGroup,
      this.mapOfGroup}) {
    mapOfGroup ??= Map<String, String>();
    currentGroup ??= mapOfGroup.isEmpty ? '' : mapOfGroup.keys.first;
  }
  String username;
  String name;
  String familyName;
  String currentGroup;
  Map<String, String> mapOfGroup = Map<String, String>();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static Future<User> getUserFromFireBase(String userId) async {
    if (userId.isEmpty) return null;
    var doc =
        await Firestore.instance.collection('users').document(userId).get();
    if (doc.data != null) {
      User user = User(
          username: doc.data['username'],
          name: doc.data['name'],
          familyName: doc.data['familyName'],
          mapOfGroup: Map<String, String>.from(doc.data['groups']),
          currentGroup: doc.data['currentGroup']);
      return user;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
