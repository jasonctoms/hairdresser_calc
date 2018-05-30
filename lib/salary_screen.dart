import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/commission_dialog.dart';
import 'package:hairdresser_calc/localized_strings.dart';

const _padding = EdgeInsets.all(16.0);

enum GoalSelection { gross, net, salary }

class SalaryScreen extends StatefulWidget {
  SalaryScreen({Key key}) : super(key: key);

  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  String _commissionText;
  double _commissionValue;
  int _todaysIntake;
  int _monthsIntake;
  bool _showIntakeValidationError = false;
  final _intakeFieldKey = GlobalKey(debugLabel: 'currentIntake');
  TextEditingController _intakeController;
  FocusNode _intakeFocus = FocusNode();
  int _daysLeft = 20;
  int _goalGross;
  int _goalNet;
  int _goalSalary;
  bool _showGoalValidationError = false;
  final _goalFieldKey = GlobalKey(debugLabel: 'goal');
  TextEditingController _goalController;
  FocusNode _goalFocus = FocusNode();
  GoalSelection _goalSelection = GoalSelection.gross;

  @override
  void dispose() {
    _intakeFocus.dispose();
    _goalFocus.dispose();
    super.dispose();
  }

  int _remainingIntake() {
    if (_goalGross == null || _monthsIntake == null)
      return 0;
    else
      return _goalGross - _monthsIntake;
  }

  int _amountNeededPerDay() {
    if (_daysLeft == null)
      return 0;
    else
      return (_remainingIntake() / _daysLeft).round();
  }

  int _salaryWithCurrentIntake() {
    if (_monthsIntake == null || _commissionValue == null)
      return 0;
    else
      return (_monthsIntake * 0.8 * _commissionValue).round();
  }

  _onIntakeFocusChange() {
      if (_intakeFocus.hasFocus) {
        _intakeController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _intakeController.text.length,
        );
      }
  }

  _onGoalFocusChange() {
    if (_goalFocus.hasFocus) {
      _goalController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _goalController.text.length,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _setDefaultPrefs();
    _intakeFocus.addListener(_onIntakeFocusChange);
    _goalFocus.addListener(_onGoalFocusChange);
  }

  _setDefaultPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double commission = prefs.getDouble(prefKeys.commissionKey);
    if (commission == null) {
      await prefs.setDouble(prefKeys.commissionKey, 0.40);
    }
    int monthsIntake = prefs.getInt(prefKeys.monthsIntakeKey);
    if (monthsIntake == null) {
      await prefs.setInt(prefKeys.monthsIntakeKey, 0);
    }
    int todaysIntake = prefs.getInt(prefKeys.todaysIntakeKey);
    if (todaysIntake == null) {
      await prefs.setInt(prefKeys.todaysIntakeKey, 0);
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

    _getOtherValuesFromSharedPrefs();
    _getCommissionFromSharedPrefs();
  }

  _getOtherValuesFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int todaysIntake = prefs.getInt(prefKeys.todaysIntakeKey);
    int monthsIntake = prefs.getInt(prefKeys.monthsIntakeKey);
    int daysLeft = prefs.getInt(prefKeys.daysLeftKey);
    int goalNet = prefs.getInt(prefKeys.goalNetKey);
    int goalGross = prefs.getInt(prefKeys.goalGrossKey);
    int goalSalary = prefs.getInt(prefKeys.goalSalaryKey);
    setState(() => _initPrefValues(
        todaysIntake, monthsIntake, daysLeft, goalNet, goalGross, goalSalary));
  }

  _initPrefValues(int todaysIntake, int monthsIntake, int daysLeft, int goalNet,
      int goalGross, int goalSalary) {
    _todaysIntake = todaysIntake;
    _intakeController = TextEditingController(text: _todaysIntake.toString());
    _monthsIntake = monthsIntake;
    _daysLeft = daysLeft;
    _goalGross = goalGross;
    _goalController = TextEditingController(text: _goalGross.toString());
    _goalNet = goalNet;
    _goalSalary = goalSalary;
  }

  _getCommissionFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var commissionValue = prefs.getDouble(prefKeys.commissionKey);
    var correctDecimals = commissionValue.toStringAsFixed(3);
    commissionValue = double.parse(correctDecimals);
    setState(() => _setCommission(commissionValue));
  }

  _setCommission(double commissionValue) {
    _commissionValue = commissionValue;
    _goalSalary = (_goalNet * _commissionValue).round();
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

  _updateTodaysIntake(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _showIntakeValidationError = false;
        _todaysIntake = 0;
        _setTodaysIntakePref();
      } else {
        try {
          final inputInt = int.parse(input);
          _showIntakeValidationError = false;
          _todaysIntake = inputInt;
          _setTodaysIntakePref();
        } on Exception catch (e) {
          print('Error: $e');
          _showIntakeValidationError = true;
        }
      }
    });
  }

  _addTodaysIntakeToMonth() {
    setState(() {
      _monthsIntake += _todaysIntake;
      _setMonthsIntakePref();
    });
  }

  _clearMonthlyIntake() {
    setState(() {
      _monthsIntake = 0;
      _setMonthsIntakePref();
    });
  }

  _addDay() {
    setState(() {
      if (_daysLeft == 31)
        _daysLeft = 1;
      else
        _daysLeft += 1;

      _setDaysLeftPref();
    });
  }

  _subtractDay() {
    setState(() {
      if (_daysLeft == 1)
        _daysLeft = 31;
      else
        _daysLeft -= 1;

      _setDaysLeftPref();
    });
  }

  _setTodaysIntakePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.todaysIntakeKey, _todaysIntake);
  }

  _setMonthsIntakePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.monthsIntakeKey, _monthsIntake);
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
    final daysLeft = Column(
      children: [
        Text(
          LocalizedStrings.of(context).daysLeft,
          style: TextStyle(
            fontSize: 11.0,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.teal[400],
              ),
              onPressed: () => _subtractDay(),
            ),
            Text(
              _daysLeft.toString(),
              style: TextStyle(fontSize: 20.0),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.teal[400],
              ),
              onPressed: () => _addDay(),
            ),
          ],
        ),
      ],
    );

    final commission = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(LocalizedStrings.of(context).commission),
            Padding(padding: EdgeInsets.only(right:2.0),),
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
          textColor: Colors.teal,
          onPressed: () => _openDialog(context),
        ),
      ],
    );

    final commissionRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        commission,
        daysLeft,
      ],
    );

    final todaysIntakeField = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: TextField(
          key: _intakeFieldKey,
          controller: _intakeController,
          focusNode: _intakeFocus,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
            labelStyle: Theme.of(context).textTheme.body1,
            errorText: _showIntakeValidationError
                ? LocalizedStrings.of(context).validationMessage
                : null,
            labelText: LocalizedStrings.of(context).todaysIntake,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: _updateTodaysIntake,
        ),
      ),
    );

    final monthsIntake = Column(
      children: [
        Text(LocalizedStrings.of(context).monthsIntake),
        Text(
          _formatMoney(_monthsIntake),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );

    final currentIntakeRow = Row(
      children: [
        todaysIntakeField,
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.teal[400],
          ),
          onPressed: () => _addTodaysIntakeToMonth(),
        ),
        monthsIntake,
        IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
          onPressed: () => _clearMonthlyIntake(),
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
        focusNode: _goalFocus,
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
              color: Colors.teal[300],
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
                      color: Colors.teal[300],
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
                      color: Colors.teal[300],
                      fontSize: 30.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return new SingleChildScrollView(
      child: Container(
        padding: _padding,
        child: Column(
          children: [
            commissionRow,
            currentIntakeRow,
            goal,
            goalInfo,
            currentSalary,
            importantNumbers,
          ],
        ),
      ),
    );
  }
}
