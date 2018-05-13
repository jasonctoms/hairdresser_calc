import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'pref_keys.dart' as prefKeys;

import 'package:shared_preferences/shared_preferences.dart';

const _padding = EdgeInsets.all(16.0);

class CommissionDialog extends StatefulWidget {
  final String commission;

  const CommissionDialog({
    @required this.commission,
  }) : assert(commission != null);

  @override
  _CommissionDialogState createState() => _CommissionDialogState();
}

class _CommissionDialogState extends State<CommissionDialog> {
  double _commissionValue;
  String _commissionText;
  bool _showValidationError = false;
  final _inputKey = GlobalKey(debugLabel: 'commissionText');

  void _updateCommission(String input) {
    setState(() {
      try {
        final inputDouble = (double.parse(input)) / 100.0;
        if (inputDouble > 1.0 || inputDouble < 0) {
          _showValidationError = true;
        } else {
          _showValidationError = false;
          _commissionValue = inputDouble;
          _commissionText = input;
        }
      } on Exception catch (e) {
        print('Error: $e');
        _showValidationError = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCommission = Padding(
      padding: _padding,
      child: Text('The current commission value is ' + widget.commission + '%'),
    );

    final commissionInput = Padding(
      padding: _padding,
      child: TextField(
        key: _inputKey,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.body1,
          errorText: _showValidationError ? 'Invalid number entered' : null,
          labelText: 'Commission %',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: _updateCommission,
      ),
    );

    return AlertDialog(
      content: Column(
        children: <Widget>[currentCommission, commissionInput],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Done"),
          onPressed: (_showValidationError || _commissionText == null)
              ? null
              : () => _updateSharedPrefs(context),
        ),
      ],
    );
  }

  _updateSharedPrefs(BuildContext context) {
    Navigator.pop(context, _commissionText);
    _setCommissionValue();
  }

  _setCommissionValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(prefKeys.commissionKey, _commissionValue);
  }
}
