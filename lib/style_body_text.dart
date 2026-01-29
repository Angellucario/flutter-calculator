import 'package:flutter/material.dart';

class StyleBodyText extends StatelessWidget {
  const StyleBodyText(this.text, {super.key, this.size = 18});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.blue[900],
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
