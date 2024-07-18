import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:salespro_admin/Screen/Widgets/Constant%20Data/constant.dart';

class CalcButton extends StatefulWidget {
  const CalcButton({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalcButtonState createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  final double _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var calc = SimpleCalculator(
      value: _currentValue,
      hideExpression: false,
      hideSurroundingBorder: true,
      autofocus: true,
      onChanged: (key, value, expression) {
        if (kDebugMode) {
          print('$key\t$value\t$expression');
        }
      },
      onTappedDisplay: (value, details) {
        if (kDebugMode) {
          print('$value\t${details.localPosition}');
        }
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: kWhiteTextColor,
        displayStyle: TextStyle(fontSize: 50, color: kTitleColor),
        expressionColor: kDarkWhite,
        expressionStyle: TextStyle(fontSize: 20, color: kTitleColor),
        operatorColor: kDarkWhite,
        operatorStyle: TextStyle(fontSize: 30, color: kTitleColor),
        commandColor: kDarkWhite,
        commandStyle: TextStyle(fontSize: 30, color: kTitleColor),
        numColor: kWhiteTextColor,
        numStyle: TextStyle(fontSize: 50, color: kTitleColor),
      ),
    );

    return SizedBox(height: MediaQuery.of(context).size.height * 0.5, child: calc);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('_currentValue', _currentValue));
  }
}
