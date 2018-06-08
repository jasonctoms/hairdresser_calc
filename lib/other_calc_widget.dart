import 'package:flutter/material.dart';
import 'package:hairdresser_calc/incdec_widget.dart';
import 'package:meta/meta.dart';

class OtherCalcWidget extends StatelessWidget {
  final IncDecWidget incDecWidget;
  final String title;
  final int totalValue;
  final Function addToTotalFunction;
  final Function clearFunction;

  const OtherCalcWidget({
    @required this.incDecWidget,
    @required this.title,
    @required this.totalValue,
    @required this.addToTotalFunction,
    @required this.clearFunction,
  })  : assert(incDecWidget != null),
        assert(title != null),
        assert(totalValue != null),
        assert(addToTotalFunction != null),
        assert(clearFunction != null);

  @override
  Widget build(BuildContext context) {
    final incDec = Expanded(
      flex: 2,
      child: incDecWidget,
    );

    final addToTotalButton = Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.teal[400],
          ),
          onPressed: addToTotalFunction,
        ),
      ),
    );

    final total = Expanded(
      flex: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(title),
          ),
          Text(
            totalValue.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );

    final clearButton = IconButton(
      icon: Icon(
        Icons.clear,
        color: Colors.red,
      ),
      onPressed: clearFunction,
    );

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          incDec,
          addToTotalButton,
          total,
          clearButton,
        ],
      ),
    );
  }
}
