import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _result = '';
      } else if (buttonText == 'C') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression.replaceAll('脳', '*').replaceAll('Ã·', '/'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
          _expression = _result;
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(color: Colors.white54, fontSize: 48),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _result,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                final button = buttons[index];
                return CalculatorButton(
                  label: button.label,
                  onTap: () => _onButtonPressed(button.label),
                  backgroundColor: button.backgroundColor,
                  labelColor: button.labelColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color labelColor;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonData {
  final String label;
  final Color backgroundColor;
  final Color labelColor;

  const ButtonData({
    required this.label,
    required this.backgroundColor,
    this.labelColor = Colors.white,
  });
}

const orangeColor = Color(0xFFF59E0B);
const darkGreyColor = Color(0xFF333333);
const lightGreyColor = Color(0xFFA5A5A5);

const List<ButtonData> buttons = [
  ButtonData(label: 'AC', backgroundColor: lightGreyColor, labelColor: Colors.black),
  ButtonData(label: 'C', backgroundColor: lightGreyColor, labelColor: Colors.black),
  ButtonData(label: '%', backgroundColor: lightGreyColor, labelColor: Colors.black),
  ButtonData(label: 'Ã·', backgroundColor: orangeColor),
  ButtonData(label: '7', backgroundColor: darkGreyColor),
  ButtonData(label: '8', backgroundColor: darkGreyColor),
  ButtonData(label: '9', backgroundColor: darkGreyColor),
  ButtonData(label: '脳', backgroundColor: orangeColor),
  ButtonData(label: '4', backgroundColor: darkGreyColor),
  ButtonData(label: '5', backgroundColor: darkGreyColor),
  ButtonData(label: '6', backgroundColor: darkGreyColor),
  ButtonData(label: '-', backgroundColor: orangeColor),
  ButtonData(label: '1', backgroundColor: darkGreyColor),
  ButtonData(label: '2', backgroundColor: darkGreyColor),
  ButtonData(label: '3', backgroundColor: darkGreyColor),
  ButtonData(label: '+', backgroundColor: orangeColor),
  ButtonData(label: '0', backgroundColor: darkGreyColor),
  ButtonData(label: '.', backgroundColor: darkGreyColor),
  ButtonData(label: '=', backgroundColor: orangeColor),
];
