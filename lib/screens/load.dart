import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locker_calculator/screens/home.dart';
import 'package:locker_calculator/styles/color_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Popup extends StatefulWidget {
  const Popup({Key? key}) : super(key: key);

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("SET Password")),
        backgroundColor: UIColorStyles.DEEP_MODE,
      ),
      body: Column(
        children: [
          const SizedBox(height: 200),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              obscuringCharacter: "*",
                cursorColor: UIColorStyles.DEEP_MODE,
              decoration: const InputDecoration(
                hintText: "Enter password",
                focusColor: Colors.amber,
                enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
     
    
                icon: Icon(
                  Icons.lock,
                  color: UIColorStyles.DEEP_MODE,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: confirmPasswordController,
              obscureText: true,
              obscuringCharacter: "*",
              cursorColor: UIColorStyles.DEEP_MODE,
          
              decoration: const InputDecoration(
                hintText: "Confirm Password",
                icon: Icon(
                  Icons.lock,
                  color: UIColorStyles.DEEP_MODE,
                ),
                      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
                    
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              setPasswords();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(UIColorStyles.DEEP_MODE)
            ),
            child: const Text("Set Password"),
            
          ),
        ],
      ),
    );
  }

  void setPasswords() async {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password.length >= 6) {
      if (password == confirmPassword) {
        await savePassword(password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        showPasswordMismatchError();
      }
    } 
  }

  Future<void> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  void showPasswordMismatchError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passwords do not match!'),
      ),
    );
  }




  
}
