import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/commission_dialog.dart';

const _padding = EdgeInsets.all(16.0);

class SalaryScreen extends StatefulWidget {
  SalaryScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  String _commissionText;
  double _commissionValue;
  int _currentIntake;
  bool _showIntakeValidationError = false;
  final _intakeFieldKey = GlobalKey(debugLabel: 'currentIntake');
  TextEditingController _intakeController;
  int _daysLeft;
  bool _showDaysLeftValidationError = false;
  final _daysLeftFieldKey = GlobalKey(debugLabel: 'daysLeft');
  TextEditingController _daysLeftController;
  int _goalNet;
  int _goalGross;

  @override
  void initState() {
    super.initState();
    _getCommissionFromSharedPrefs();
    _getOtherValuesFromSharedPrefs();
  }

  _getOtherValuesFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentIntake = prefs.getInt(prefKeys.currentIntakeKey);
    int daysLeft = prefs.getInt(prefKeys.daysLeftKey);
    int goalNet = prefs.getInt(prefKeys.goalNetKey);
    int goalGross = prefs.getInt(prefKeys.goalGrossKey);
    setState(
        () => _initPrefValues(currentIntake, daysLeft, goalNet, goalGross));
  }

  _initPrefValues(int currentIntake, int daysLeft, int goalNet, int goalGross) {
    _currentIntake = currentIntake;
    _intakeController = TextEditingController(text: _currentIntake.toString());
    _daysLeft = daysLeft;
    _daysLeftController = TextEditingController(text:_daysLeft.toString());
    _goalNet = goalNet;
    _goalGross = goalGross;
  }

  _getCommissionFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var commissionValue = prefs.getDouble(prefKeys.commissionKey);
    var correctDecimals = commissionValue.toStringAsFixed(1);
    commissionValue = double.parse(correctDecimals);
    setState(() => _setCommission(commissionValue));
  }

  _setCommission(double commissionValue) {
    _commissionValue = commissionValue;
    _commissionText = (commissionValue * 100.0).toString();
  }

  String _setCommissionText() {
    if (_commissionValue == null) {
      return 'Commission: X%';
    }
    return 'Commission: ' + _commissionText + '%';
  }

  Future<Null> _openDialog(BuildContext context) async {
    var newCommission = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommissionDialog(commission: _commissionText);
        });
    if (newCommission.isNotEmpty) {
      _getCommissionFromSharedPrefs();
    }
  }

  _updateCurrentIntake(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _showIntakeValidationError = false;
        _currentIntake = 0;
        _setCurrentIntakePref();
      }
      try {
        final inputInt = int.parse(input);
        _showIntakeValidationError = false;
        _currentIntake = inputInt;
        _setCurrentIntakePref();
      } on Exception catch (e) {
        print('Error: $e');
        _showIntakeValidationError = true;
      }
    });
  }

  _updateDaysLeft(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _showDaysLeftValidationError = false;
        _daysLeft = 0;
        _setDaysLeftPref();
        //_intakeController.text = '0';
      }
      try {
        final inputInt = int.parse(input);
        _showDaysLeftValidationError = false;
        _daysLeft = inputInt;
        _setDaysLeftPref();
      } on Exception catch (e) {
        print('Error: $e');
        _showDaysLeftValidationError = true;
      }
    });
  }

  _setCurrentIntakePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefKeys.currentIntakeKey, _currentIntake);
  }

  _setDaysLeftPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(prefKeys.daysLeftKey, _daysLeft);
  }

  @override
  Widget build(BuildContext context) {
    final commissionRow = Padding(
      padding: EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(_setCommissionText()),
          ),
          RaisedButton(
            child: Text('Change'),
            color: Colors.blue,
            onPressed: () => _openDialog(context),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        ],
      ),
    );

    final currentIntakeAndDaysRow = Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: TextField(
              key: _intakeFieldKey,
              controller: _intakeController,
              style: Theme.of(context).textTheme.body1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.body1,
                errorText: _showIntakeValidationError
                    ? 'Invalid number entered'
                    : null,
                labelText: 'Current Intake',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateCurrentIntake,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: TextField(
              key: _daysLeftFieldKey,
              controller: _daysLeftController,
              style: Theme.of(context).textTheme.body1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.body1,
                errorText: _showDaysLeftValidationError
                    ? 'Invalid number entered'
                    : null,
                labelText: 'Days Left',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateDaysLeft,
            ),
          ),
        ),
      ],
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          padding: _padding,
          child: Column(
            children: [
              commissionRow,
              currentIntakeAndDaysRow,
            ],
          )),
    );
  }
}
