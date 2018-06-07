import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class IncDecWidget extends StatelessWidget {
  final bool titleOnTop;
  final String title;
  final int value;
  final Function incrementFunction;
  final Function decrementFunction;

  const IncDecWidget({
    @required this.titleOnTop,
    @required this.title,
    @required this.value,
    @required this.incrementFunction,
    @required this.decrementFunction,
  })  : assert(titleOnTop != null),
        assert(title != null),
        assert(value != null),
        assert(incrementFunction != null),
        assert(decrementFunction != null);

  @override
  Widget build(BuildContext context) {
    final subtract = IconButton(
      icon: Icon(
        Icons.remove,
        color: Colors.teal[400],
      ),
      onPressed: decrementFunction,
    );

    final number = Text(
      value.toString(),
      style: TextStyle(fontSize: 20.0),
    );

    final add = IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.teal[400],
      ),
      onPressed: incrementFunction,
    );

    if (titleOnTop) {
      return Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.0,
            ),
          ),
          Row(
            children: [
              subtract,
              number,
              add,
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtract,
          number,
          add,
        ],
      );
    }
  }
}
