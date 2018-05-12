import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';

const _padding = EdgeInsets.all(16.0);
const _commissionKey = 'commission';

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
  bool _showValidationError = false;
  final _inputKey = GlobalKey(debugLabel: 'commissionText');

  void _updateCommission(String input) {
    setState(() {
      // Even though we are using the numerical keyboard, we still have to check
      // for non-numerical input such as '5..0' or '6 -3'
      try {
        final inputDouble = (double.parse(input)) / 100;
        if (inputDouble > 1.0 || inputDouble < 0) {
          _showValidationError = true;
        } else {
          _showValidationError = false;
          _commissionValue = inputDouble;
        }
      } on Exception catch (e) {
        print('Error: $e');
        _showValidationError = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        // Since we only want numerical input, we use a number keyboard. There
        // are also other keyboards for dates, emails, phone numbers, etc.
        keyboardType: TextInputType.number,
        onChanged: _updateCommission,
      ),
    );

    return AlertDialog(
      content: commissionInput,
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Done"),
          onPressed:
              _showValidationError ? null : () => _updateSharedPrefs(context),
        ),
      ],
    );
  }

  _updateSharedPrefs(BuildContext context) {
    Navigator.pop(context);
    _setCommissionValue();
  }

  _setCommissionValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_commissionKey, _commissionValue);
  }
}
