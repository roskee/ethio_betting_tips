import 'package:flutter/material.dart';

typedef ToggleCallback = void Function(int);

class ToggleWidget<T> extends StatefulWidget {
  const ToggleWidget(
      {Key? key,
      required this.toggleWidgetList,
      required this.onToggleChange,
      this.valueIndex = 0})
      : super(key: key);
  final List<Widget> toggleWidgetList;
  final ToggleCallback onToggleChange;
  final int valueIndex;
  @override
  _ToggleWidgetState<T> createState() => _ToggleWidgetState<T>();
}

class _ToggleWidgetState<T> extends State<ToggleWidget> {
  late int valueIndex;
  @override
  void initState() {
    super.initState();
    valueIndex = widget.valueIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: InkResponse(
          highlightShape: BoxShape.circle,
          radius: 20,
          onTap: () {
            int temp = valueIndex >= widget.toggleWidgetList.length - 1
                ? 0
                : valueIndex + 1;
            setState(() {
              valueIndex = temp;
            });
            widget.onToggleChange(temp);
          },
          child: widget.toggleWidgetList[valueIndex],
        ));
  }
}
