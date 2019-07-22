import 'package:colocpro/core/root_page.dart';
import 'package:flutter/material.dart';
import 'package:colocpro/auth/firebase_auth.dart';

void main() => runApp(ColocPro());

class ColocPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coloc PRO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(
        auth: new Auth(),
      ),
    );
  }
}
