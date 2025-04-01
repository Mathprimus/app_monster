import 'package:app_monster/screens/login_screen.dart';
import 'package:app_monster/screens/menu_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (BuildContext context) => LoginScreen(),
      'menu': (BuildContext context) => MenuScreen(),
    },
  ));
}
