import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'pref_keys.dart' as prefKeys;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hairdresser_calc/localized_strings.dart';

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
      padding: EdgeInsets.only(bottom: 32.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocalizedStrings.of(context).currentCommission),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
          Text(
            widget.commission + '%',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    final commissionInput = TextField(
      key: _inputKey,
      style: Theme.of(context).textTheme.body1,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.body1,
        errorText: _showValidationError
            ? LocalizedStrings.of(context).validationMessage
            : null,
        labelText: LocalizedStrings.of(context).commissionPercent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: _updateCommission,
    );

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [currentCommission, commissionInput],
      ),
      actions: [
        FlatButton(
          child: Text(LocalizedStrings.of(context).cancel),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(LocalizedStrings.of(context).done),
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
    prefs.setDouble(prefKeys.commissionKey, _commissionValue);
  }
}
