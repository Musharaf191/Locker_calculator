import 'package:flutter/material.dart';
import 'package:locker_calculator/screens/home.dart';
import 'package:locker_calculator/screens/load.dart';
import 'package:locker_calculator/screens/locker.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedPassword = prefs.getString('password') ?? "";

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
       home: storedPassword.isNotEmpty ? HomePage() : Popup(),
      // home: Popup(),
    ),
  );
}
