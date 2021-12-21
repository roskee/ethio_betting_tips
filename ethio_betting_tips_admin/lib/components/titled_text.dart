import 'package:flutter/material.dart';

class TitledWidget extends StatelessWidget {
  const TitledWidget({
    Key? key,
    required this.title,
    required this.content,
    this.titleFontSize = 10
  }) : super(key: key);
  final String title;
  final Widget content;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(title,style: TextStyle(fontSize: titleFontSize),),
      Expanded(child:Center(child:content))
    ],);
  }
}
