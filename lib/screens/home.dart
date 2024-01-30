import 'package:flutter/material.dart';

import 'package:locker_calculator/constant/content_Extension.dart';
import 'package:locker_calculator/screens/locker.dart';
import 'package:locker_calculator/styles/color_style.dart';
import 'package:locker_calculator/styles/textstyle.dart';

import 'package:locker_calculator/widgets/buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<void> getPassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String password = prefs.get('password').toString();
  print(password);
}

class _HomePageState extends State<HomePage> {
  TextEditingController passwordController = TextEditingController();
  String savedPassword = '';

  var userInput = '';
  var answer = '';
  @override
  void initState() {
    getPassword();
    super.initState();
  }

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    '*',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '.',
    '0',
    '()',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColorStyles.background,
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child: calculateField(),
              )),
          Expanded(
            flex: 2,
            child: buildContainerButtonsField(),
          ),
        ],
      ),
    );
  }

  Container buildContainerButtonsField() {
    return Container(
      child: GridView.builder(
          itemCount: buttons.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return CalculatorButton(
                buttonTapped: () {
                  setState(() {
                    userInput = '';
                    answer = '';
                  });
                },
                buttonText: buttons[index],
                color: UIColorStyles.GREEN_MODE,
              );
            } else if (index == 1) {
              return CalculatorButton(
                buttonTapped: () {
                  setState(() {
                    userInput = userInput.substring(0, userInput.length - 1);
                  });
                },
                buttonText: buttons[index],
                color: UIColorStyles.RED_MODE,
              );
            } else if (index == buttons.length - 1) {
              return CalculatorButton(
                buttonTapped: () {
                  setState(() {
                    equalPressed();
                  });
                },
                buttonText: buttons[index],
                color: UIColorStyles.DEEP_MODE,
              );
            } else {
              return CalculatorButton(
                buttonTapped: () {
                  setState(() {
                    userInput += buttons[index];
                  });
                },
                buttonText: buttons[index],
                color: isOperator(buttons[index])
                    ? Colors.deepOrange
                    : Colors.deepOrange[50],
                textColor: isOperator(buttons[index])
                    ? Colors.white
                    : Colors.deepOrange,
              );
            }
          }),
    );
  }

  Column calculateField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            padding: context.paddingAllow,
            alignment: Alignment.centerLeft,
            child: Text(
              userInput,
              style: UITextStyles.buttonTextStyle,
            )),
        Container(
            padding: context.paddingAllow,
            alignment: Alignment.centerRight,
            child: Text(
              answer,
              style: UITextStyles.buttonTextStyle,
            )),
      ],
    );
  }

  bool isOperator(String x) {
    if (x == '%' || x == '/' || x == '*' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    print("i am equal");
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');
    checkpassword(answer);
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }

  void checkpassword(String checkpassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? password = prefs.getString('password');
    print("password ${password}");
    if (password == checkpassword.substring(0, checkpassword.indexOf('.'))) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Locker_page(),
          ));
      print("if");
    } else {
      print("else");
    }
  }
}
