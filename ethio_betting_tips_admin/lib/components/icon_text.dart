import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({Key? key,
  required this.text,
  required this.backgroundColor,
  this.textColor = Colors.white,
  this.padding = 1,
  this.borderRadius = 50
  }) : super(key: key);
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double padding;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 22,
        height:22,
        padding: EdgeInsets.all(padding),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(50)),
        child: Center(child:Text(text, style: TextStyle(color: textColor))));
  }
}
