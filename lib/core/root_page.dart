import 'package:flutter/material.dart';
import 'package:colocpro/auth/login_signup_page.dart';
import 'package:colocpro/auth/base_auth.dart';
import 'package:colocpro/auth/user.dart';
import 'home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userEmail = "";

  User _user;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((user) {
      if (user != null) {
        _userId = user?.uid;
        _userEmail = user?.email;
      }
      User.getUserFromFireBase(_userId).then((User u) {
        setState(() {
          _user = u;
          authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        });
      });
    });
  }

  void _onLoggedIn() async {
    await widget.auth.getCurrentUser().then((user) async {
      setState(() {
        _userId = user?.uid;
        _userEmail = user?.email;
      });
      _user = await User.getUserFromFireBase(_userId);
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _userEmail = "";
      _user = null;
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            userEmail: _userEmail,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            user: _user,
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
