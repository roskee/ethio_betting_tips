import 'package:flutter/material.dart';

class Freezable extends StatelessWidget {
  const Freezable({Key? key, required this.child, required this.isFrozen})
      : super(key: key);
  final Widget child;
  final bool isFrozen;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      Visibility(
          visible: isFrozen,
          child: GestureDetector(
            child: Container(
              color: Colors.white54,
            ),
          ))
    ]);
  }
}
