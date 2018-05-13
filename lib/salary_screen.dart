import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/commission_dialog.dart';

const _padding = EdgeInsets.all(16.0);

enum GoalSelection { gross, net, salary }

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
  int _goalGross;
  int _goalNet;
  int _goalSalary;
  bool _showGoalValidationError = false;
  final _goalFieldKey = GlobalKey(debugLabel: 'goal');
  TextEditingController _goalController;
  GoalSelection _goalSelection = GoalSelection.gross;

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
    int goalSalary = prefs.getInt(prefKeys.goalSalaryKey);
    setState(() => _initPrefValues(
        currentIntake, daysLeft, goalNet, goalGross, goalSalary));
  }

  _initPrefValues(int currentIntake, int daysLeft, int goalNet, int goalGross,
      int goalSalary) {
    _currentIntake = currentIntake;
    _intakeController = TextEditingController(text: _currentIntake.toString());
    _daysLeft = daysLeft;
    _daysLeftController = TextEditingController(text: _daysLeft.toString());
    _goalNet = goalNet;
    _goalController = TextEditingController(text: _goalNet.toString());
    _goalGross = goalGross;
    _goalSalary = goalSalary;
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
      } else {
        try {
          final inputInt = int.parse(input);
          _showIntakeValidationError = false;
          _currentIntake = inputInt;
          _setCurrentIntakePref();
        } on Exception catch (e) {
          print('Error: $e');
          _showIntakeValidationError = true;
        }
      }
    });
  }

  _updateDaysLeft(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _showDaysLeftValidationError = false;
        _daysLeft = 0;
        _setDaysLeftPref();
      } else {
        try {
          final inputInt = int.parse(input);
          _showDaysLeftValidationError = false;
          _daysLeft = inputInt;
          _setDaysLeftPref();
        } on Exception catch (e) {
          print('Error: $e');
          _showDaysLeftValidationError = true;
        }
      }
    });
  }

  _setCurrentIntakePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.currentIntakeKey, _currentIntake);
  }

  _setDaysLeftPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.daysLeftKey, _daysLeft);
  }

  _updateGoal(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _showGoalValidationError = false;
        _goalGross = 0;
        _goalNet = 0;
        _goalSalary = 0;
        _setGoalPrefs();
      } else {
        try {
          final inputInt = int.parse(input);
          _showGoalValidationError = false;
          if (_goalSelection == GoalSelection.gross) {
            _goalGross = inputInt;
            var net = inputInt * 0.8;
            _goalNet = net.round();
            var salary = inputInt * _commissionValue;
            _goalSalary = salary.round();
          } else if (_goalSelection == GoalSelection.net) {
            _goalNet = inputInt;
            var gross = inputInt / 0.8;
            _goalGross = gross.round();
            var salary = gross * _commissionValue;
            _goalSalary = salary.round();
          } else {
            _goalSalary = inputInt;
            var net = inputInt / _commissionValue;
            _goalNet = net.round();
            var gross = net / 0.8;
            _goalGross = gross.round();
          }
          _setGoalPrefs();
        } on Exception catch (e) {
          print('Error: $e');
          _showGoalValidationError = true;
        }
      }
    });
  }

  _setGoalPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.goalGrossKey, _goalGross);
    prefs.setInt(prefKeys.goalNetKey, _goalNet);
    prefs.setInt(prefKeys.goalSalaryKey, _goalSalary);
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

    String _pickGoalLabel() {
      if (_goalSelection == GoalSelection.gross) {
        return 'Goal Gross';
      } else if (_goalSelection == GoalSelection.net) {
        return 'Goal Net';
      } else {
        return 'Goal Salary';
      }
    }

    final goal = Column(children: [
      Row(
        children: [
          Expanded(
            child: RadioListTile<GoalSelection>(
              title: Text(
                'Gross',
                style: Theme.of(context).textTheme.body1,
              ),
              value: GoalSelection.gross,
              groupValue: _goalSelection,
              onChanged: (GoalSelection value) {
                setState(() {
                  _goalSelection = value;
                  _goalController.text = _goalGross.toString();
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<GoalSelection>(
              title: Text(
                'Net',
                style: Theme.of(context).textTheme.body1,
              ),
              value: GoalSelection.net,
              groupValue: _goalSelection,
              onChanged: (GoalSelection value) {
                setState(() {
                  _goalSelection = value;
                  _goalController.text = _goalNet.toString();
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<GoalSelection>(
              title: Text(
                'Salary',
                style: Theme.of(context).textTheme.body1,
              ),
              value: GoalSelection.salary,
              groupValue: _goalSelection,
              onChanged: (GoalSelection value) {
                setState(() {
                  _goalSelection = value;
                  _goalController.text = _goalSalary.toString();
                });
              },
            ),
          ),
        ],
      ),
      TextField(
        key: _goalFieldKey,
        controller: _goalController,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.body1,
          errorText: _showGoalValidationError ? 'Invalid number entered' : null,
          labelText: _pickGoalLabel(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: _updateGoal,
      ),
    ]);

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
              goal,
            ],
          )),
    );
  }
}
