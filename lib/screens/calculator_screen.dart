import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:tugas_modul4/widgets/button_calc.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CalculatorView(),
    );
  }
}

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  var userInput = '';
  var answer = '';

  final List<String> buttons = const [
    'C',
    '+/-',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.blueGrey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.centerRight,
                  child: Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (BuildContext context, int index) {
              // Clear Button
              if (index == 0) {
                return MyButton(
                  buttontapped: () {
                    setState(() {
                      userInput = '';
                      answer = '0';
                    });
                  },
                  buttonText: buttons[index],
                  color: Colors.blue[50],
                  textColor: Colors.black,
                );
              }

              // +/- button
              else if (index == 1) {
                return MyButton(
                  buttonText: buttons[index],
                  color: Colors.blue[50],
                  textColor: Colors.black,
                );
              }

              // % Button
              else if (index == 2) {
                return MyButton(
                  buttontapped: () {
                    setState(() {
                      userInput += buttons[index];
                    });
                  },
                  buttonText: buttons[index],
                  color: Colors.blue[50],
                  textColor: Colors.black,
                );
              }

              // Delete Button
              else if (index == 3) {
                return MyButton(
                  buttontapped: () {
                    setState(() {
                      userInput = userInput.substring(0, userInput.length - 1);
                    });
                  },
                  buttonText: buttons[index],
                  color: Colors.blue[50],
                  textColor: Colors.black,
                );
              }

              // Equal Button
              else if (index == 18) {
                return MyButton(
                  buttontapped: () {
                    setState(() {
                      equalPressed();
                    });
                  },
                  buttonText: buttons[index],
                  color: Colors.orange[700],
                  textColor: Colors.white,
                );
              }

              
              else {
                return MyButton(
                  buttontapped: () {
                    setState(() {
                      userInput += buttons[index];
                    });
                  },
                  buttonText: buttons[index],
                  color: isOperator(buttons[index])
                      ? Colors.blueAccent
                      : Colors.white,
                  textColor: isOperator(buttons[index])
                      ? Colors.white
                      : Colors.black,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }
}
