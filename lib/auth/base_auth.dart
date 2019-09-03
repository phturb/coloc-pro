import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String userName,
      String name, String familyName);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}
