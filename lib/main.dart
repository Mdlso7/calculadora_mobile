
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF151515),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  double firstNumber = 0;
  String operation = '';
  bool waitingForNumber = false;

  void pressButton(String value) {
    setState(() {
      if (value == 'AC') {
        display = '0';
        firstNumber = 0;
        operation = '';
        waitingForNumber = false;
        return;
      }

      if (value == '⌫') {
        if (!waitingForNumber && display != 'Erro') {
          display = display.length > 1
              ? display.substring(0, display.length - 1)
              : '0';
        }
        return;
      }

      if (value == '±') {
        if (display != '0' && display != 'Erro') {
          display = display.startsWith('-')
              ? display.substring(1)
              : '-$display';
        }
        return;
      }

      if (value == '%') {
        final number = double.tryParse(display);
        if (number != null) {
          display = formatNumber(number / 100);
        }
        return;
      }

      if (['+', '−', '×', '÷'].contains(value)) {
        firstNumber = double.tryParse(display) ?? 0;
        operation = value;
        waitingForNumber = true;
        return;
      }

      if (value == '=') {
        final secondNumber = double.tryParse(display);
        if (secondNumber == null || operation.isEmpty) return;

        double result;
        switch (operation) {
          case '+':
            result = firstNumber + secondNumber;
            break;
          case '−':
            result = firstNumber - secondNumber;
            break;
          case '×':
            result = firstNumber * secondNumber;
            break;
          case '÷':
            if (secondNumber == 0) {
              display = 'Erro';
              operation = '';
              waitingForNumber = true;
              return;
            }
            result = firstNumber / secondNumber;
            break;
          default:
            return;
        }

        display = formatNumber(result);
        operation = '';
        waitingForNumber = true;
        return;
      }

      if (value == '.') {
        if (waitingForNumber || display == 'Erro') {
          display = '0.';
          waitingForNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
        return;
      }

      if (double.tryParse(value) != null) {
        if (waitingForNumber || display == 'Erro') {
          display = value;
          waitingForNumber = false;
        } else if (display == '0') {
          display = value;
        } else if (display.length < 14) {
          display += value;
        }
      }
    });
  }

  String formatNumber(double number) {
    if (!number.isFinite) return 'Erro';
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsPrecision(10).replaceAll(
          RegExp(r'0+$'),
          '',
        ).replaceAll(RegExp(r'\.$'), '');
  }

  Widget calculatorButton(
    String text, {
    Color background = const Color(0xFF292929),
    Color foreground = Colors.white,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox.expand(
          child: ElevatedButton(
            onPressed: () => pressButton(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonRow(List<Widget> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9F0A);
    const lightButton = Color(0xFFA5A5A5);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 18, 15, 15),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CALCULADORA',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    display,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 76,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              buttonRow([
                calculatorButton('AC',
                    background: lightButton, foreground: Colors.black),
                calculatorButton('±',
                    background: lightButton, foreground: Colors.black),
                calculatorButton('%',
                    background: lightButton, foreground: Colors.black),
                calculatorButton('÷', background: orange),
              ]),
              buttonRow([
                calculatorButton('7'),
                calculatorButton('8'),
                calculatorButton('9'),
                calculatorButton('×', background: orange),
              ]),
              buttonRow([
                calculatorButton('4'),
                calculatorButton('5'),
                calculatorButton('6'),
                calculatorButton('−', background: orange),
              ]),
              buttonRow([
                calculatorButton('1'),
                calculatorButton('2'),
                calculatorButton('3'),
                calculatorButton('+', background: orange),
              ]),
              buttonRow([
                calculatorButton('⌫'),
                calculatorButton('0'),
                calculatorButton('.'),
                calculatorButton('=', background: orange),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
