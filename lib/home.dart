import 'package:flutter/material.dart';
import 'package:workspace/calculator_pad.dart';
import 'package:workspace/style_body_text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Angel Lucario",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const StyleBodyText('Simple Calculator (Accumulator Display)'),
            ),
            const SizedBox(height: 16),
            const Expanded(child: CalculatorPad()),
          ],
        ),
      ),
    );
  }
}
