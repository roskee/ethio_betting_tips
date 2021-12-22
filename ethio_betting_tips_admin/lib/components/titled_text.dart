import 'package:flutter/material.dart';

class TitledWidget extends StatelessWidget {
  const TitledWidget(
      {Key? key,
      required this.title,
      required this.content,
      this.titleFontSize = 10,
      this.dividerWidth = 0})
      : super(key: key);
  final String title;
  final Widget content;
  final double titleFontSize;
  final double dividerWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleFontSize),
        ),
        Visibility(
            visible: dividerWidth != 0,
            child: Divider(
              thickness: dividerWidth,
            )),
        Expanded(child: Center(child: content))
      ],
    );
  }
}
