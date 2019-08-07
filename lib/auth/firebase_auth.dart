import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colocpro/auth/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'base_auth.dart';

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> getCurrentFormatedUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String name;
    String familyname;
    var documentReference =
        Firestore.instance.collection('users').document(user.uid);
    Firestore.instance.runTransaction((Transaction t) async {
      DocumentSnapshot postSnapshot = await t.get(documentReference);
      name = postSnapshot.data['name'];
      familyname = postSnapshot.data['familyName'];
    });
    return User(username: user.displayName, name: name, familyName: familyname);
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return _firebaseAuth.currentUser();
  }

  @override
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password, String username,
      String name, String familyName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    UserUpdateInfo info = UserUpdateInfo()..displayName = username;
    await user.updateProfile(info);
    var documentReference =
        Firestore.instance.collection('users').document(user.uid);
    Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'familyName': familyName,
      'username': username,
      'email': email
    };
    await documentReference.setData(data);

    return user.uid;
  }
}
