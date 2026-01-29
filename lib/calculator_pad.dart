import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:workspace/styled_button.dart';

class CalculatorPad extends StatefulWidget {
  const CalculatorPad({super.key});

  @override
  State<CalculatorPad> createState() => _CalculatorPadState();
}

class _CalculatorPadState extends State<CalculatorPad> {
  String _expression = '';
  String _accumulator = '0';
  String _error = '';

  // Prevent bad inputs like "++" or starting with "*" etc.
  bool _isOperator(String s) => s == '+' || s == '-' || s == '*' || s == '/';

  void _clear() {
    setState(() {
      _expression = '';
      _accumulator = '0';
      _error = '';
    });
  }

  void _append(String token) {
    setState(() {
      _error = '';

      if (token == '=') {
        _equals();
        return;
      }

      if (token == 'C') {
        _clear();
        return;
      }

      // Handle operators cleanly
      if (_isOperator(token)) {
        if (_expression.isEmpty) {
          // Allow starting with "-" for negative numbers
          if (token == '-') {
            _expression = '-';
            _accumulator = _expression;
          }
          return;
        }

        // If last char is operator, replace it
        final last = _expression[_expression.length - 1];
        if (_isOperator(last)) {
          _expression = _expression.substring(0, _expression.length - 1) + token;
        } else {
          _expression += token;
        }
      } else {
        // Digits (and optionally dot)
        _expression += token;
      }

      _accumulator = _expression.isEmpty ? '0' : _expression;
    });
  }

  String _formatNumber(num value) {
    // Avoid showing 14.0 when it's really 14
    if (value is int) return value.toString();
    final double d = value.toDouble();
    if (d.isInfinite || d.isNaN) return 'Error';
    if (d == d.roundToDouble()) return d.toInt().toString();
    return d.toStringAsFixed(6).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _equals() {
    if (_expression.isEmpty) return;

    // If expression ends in operator, don’t evaluate
    final last = _expression[_expression.length - 1];
    if (_isOperator(last)) {
      setState(() {
        _error = 'Incomplete expression';
      });
      return;
    }

    try {
      final exp = Expression.parse(_expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(exp, {});

      // expressions can return num/bool/etc; we only expect num here
      if (result is num) {
        final formatted = _formatNumber(result);
        if (formatted == 'Error') {
          setState(() {
            _error = 'Math error (ex: divide by zero)';
            _accumulator = '$_expression = Error';
          });
          return;
        }

        setState(() {
          _accumulator = '$_expression = $formatted'; // accumulator display requirement
          _expression = formatted; // lets you keep calculating with result
        });
      } else {
        setState(() {
          _error = 'Invalid result';
          _accumulator = '$_expression = Error';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Invalid expression';
        _accumulator = '$_expression = Error';
      });
    }
  }

  Widget _calcButton(String label, {Color? bg}) {
    // Determine if this is a number button
    bool isNumber = label == '0' || label == '1' || label == '2' || label == '3' || 
                    label == '4' || label == '5' || label == '6' || label == '7' || 
                    label == '8' || label == '9' || label == '.';
    
    // Use light blue for numbers, dark blue/custom for operators
    Color buttonBg = bg ?? (isNumber ? Colors.blue[300]! : Colors.blue[700]!);
    
    return StyledButton(
      bg: buttonBg,
      onPressed: () => _append(label),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display (accumulator)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _accumulator,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[900],
                ),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  _error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Buttons grid
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _calcButton('7')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('8')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('9')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('/', bg: Colors.blue[800])),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _calcButton('4')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('5')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('6')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('*', bg: Colors.blue[800])),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _calcButton('1')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('2')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('3')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('-', bg: Colors.blue[800])),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _calcButton('C', bg: Colors.red[600])),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('0')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('.')),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('=', bg: Colors.blue[900])),
                    const SizedBox(width: 10),
                    Expanded(child: _calcButton('+', bg: Colors.blue[800])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
