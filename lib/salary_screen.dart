import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/commission_dialog.dart';
import 'package:hairdresser_calc/localized_strings.dart';

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

  int _remainingIntake() {
    if (_goalGross == null || _currentIntake == null)
      return 0;
    else
      return _goalGross - _currentIntake;
  }

  int _amountNeededPerDay() {
    if (_daysLeft == null)
      return 0;
    else
      return (_remainingIntake() / _daysLeft).round();
  }

  int _salaryWithCurrentIntake() {
    if (_currentIntake == null || _commissionValue == null)
      return 0;
    else
      return (_currentIntake * 0.8 * _commissionValue).round();
  }

  @override
  void initState() {
    super.initState();
    _setDefaultPrefs();
  }

  _setDefaultPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double commission = prefs.getDouble(prefKeys.commissionKey);
    if (commission == null) {
      await prefs.setDouble(prefKeys.commissionKey, 0.40);
    }
    int currentIntake = prefs.getInt(prefKeys.currentIntakeKey);
    if (currentIntake == null) {
      await prefs.setInt(prefKeys.currentIntakeKey, 0);
    }
    int daysLeft = prefs.getInt(prefKeys.daysLeftKey);
    if (daysLeft == null) {
      await prefs.setInt(prefKeys.daysLeftKey, 20);
    }
    int goalGross = prefs.getInt(prefKeys.goalGrossKey);
    if (goalGross == null) {
      await prefs.setInt(prefKeys.goalGrossKey, 125000);
    }
    int goalNet = prefs.getInt(prefKeys.goalNetKey);
    if (goalNet == null) {
      await prefs.setInt(prefKeys.goalNetKey, 100000);
    }
    int goalSalary = prefs.getInt(prefKeys.goalSalaryKey);
    if (goalSalary == null) {
      await prefs.setInt(prefKeys.goalSalaryKey, 40000);
    }
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
    _goalGross = goalGross;
    _goalController = TextEditingController(text: _goalGross.toString());
    _goalNet = goalNet;
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
      return 'X%';
    }
    return _commissionText + '%';
  }

  Future<Null> _openDialog(BuildContext context) async {
    var newCommission = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommissionDialog(commission: _commissionText);
        });
    if (newCommission != null) {
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
        _daysLeft = 1;
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
            var salary = net * _commissionValue;
            _goalSalary = salary.round();
          } else if (_goalSelection == GoalSelection.net) {
            _goalNet = inputInt;
            var gross = inputInt / 0.8;
            _goalGross = gross.round();
            var salary = inputInt * _commissionValue;
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

  String _formatMoney(int value) {
    var str = value.toString();
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function matchFunc = (Match match) => '${match[1]} ';
    var formattedString = str.replaceAllMapped(reg, matchFunc);
    formattedString = formattedString + 'kr';
    return formattedString;
  }

  @override
  Widget build(BuildContext context) {
    final commissionRow = Padding(
      padding: EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
      child: Row(
        children: [
          Row(
            children: [
              Text(LocalizedStrings.of(context).commission),
              Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
              Text(
                _setCommissionText(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          FlatButton(
            child: Text(
              LocalizedStrings.of(context).change,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Colors.purpleAccent,
            onPressed: () => _openDialog(context),
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
                    ? LocalizedStrings.of(context).validationMessage
                    : null,
                labelText: LocalizedStrings.of(context).currentIntake,
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
                    ? LocalizedStrings.of(context).validationMessage
                    : null,
                labelText: LocalizedStrings.of(context).daysLeft,
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
        return LocalizedStrings.of(context).goalGross;
      } else if (_goalSelection == GoalSelection.net) {
        return LocalizedStrings.of(context).goalNet;
      } else {
        return LocalizedStrings.of(context).goalSalary;
      }
    }

    Widget goalRadio(String title, GoalSelection goalType) {
      return Expanded(
        flex: 1,
        child: Row(
          children: [
            Radio<GoalSelection>(
              value: goalType,
              groupValue: _goalSelection,
              onChanged: (GoalSelection value) {
                setState(() {
                  _goalSelection = value;
                  if (value == GoalSelection.gross)
                    _goalController.text = _goalGross.toString();
                  else if (value == GoalSelection.net)
                    _goalController.text = _goalNet.toString();
                  else
                    _goalController.text = _goalSalary.toString();
                });
              },
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      );
    }

    final goal = Column(children: [
      Row(
        children: [
          goalRadio(LocalizedStrings.of(context).gross, GoalSelection.gross),
          goalRadio(LocalizedStrings.of(context).net, GoalSelection.net),
          goalRadio(LocalizedStrings.of(context).salary, GoalSelection.salary),
        ],
      ),
      TextField(
        key: _goalFieldKey,
        controller: _goalController,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.body1,
          errorText: _showGoalValidationError
              ? LocalizedStrings.of(context).validationMessage
              : null,
          labelText: _pickGoalLabel(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: _updateGoal,
      ),
    ]);

    final goalInfo = Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(LocalizedStrings.of(context).goalGrossResult),
              Text(_formatMoney(_goalGross),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              Text(LocalizedStrings.of(context).goalNetResult),
              Text(
                _formatMoney(_goalNet),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: [
              Text(LocalizedStrings.of(context).goalSalaryResult),
              Text(_formatMoney(_goalSalary),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );

    final currentSalary = Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocalizedStrings.of(context).salaryWithCurrentIntake),
          Text(
            _formatMoney(_salaryWithCurrentIntake()),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple[600],
            ),
          ),
        ],
      ),
    );

    final importantNumbers = Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  LocalizedStrings.of(context).intakeNeededToReachGoal,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(LocalizedStrings.of(context).intakeNeededPerDay,
                    textAlign: TextAlign.center),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  _formatMoney(_remainingIntake()),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[600],
                      fontSize: 30.0),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _formatMoney(_amountNeededPerDay()),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[600],
                      fontSize: 30.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text(LocalizedStrings.of(context).appName),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: _padding,
          child: Column(
            children: [
              commissionRow,
              currentIntakeAndDaysRow,
              goal,
              goalInfo,
              currentSalary,
              importantNumbers,
            ],
          ),
        ),
      ),
    );
  }
}
