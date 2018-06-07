import 'package:flutter/material.dart';
import 'package:hairdresser_calc/other_calc_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/incdec_widget.dart';
import 'package:hairdresser_calc/localized_strings.dart';

class OtherCalculations extends StatefulWidget {
  OtherCalculations({Key key}) : super(key: key);

  @override
  _OtherCalculationsState createState() => _OtherCalculationsState();
}

class _OtherCalculationsState extends State<OtherCalculations> {
  int _dailyClients;
  int _totalClients;
  int _dailyRebooking;
  int _totalRebooking;
  int _dailyHairMasks;
  int _totalHairMasks;
  int _totalDays;
  double _dailyRebookingPercent;
  double _totalRebookingPercent;
  double _dailyHairMasksPercent;
  double _totalHairMasksPercent;

  @override
  void initState() {
    super.initState();
    _setDefaultPrefs();
  }

  _setDefaultPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalDays = prefs.getInt(prefKeys.totalDaysKey);
    if (totalDays == null) {
      await prefs.setInt(prefKeys.totalDaysKey, 1);
    }
    int dailyClients = prefs.getInt(prefKeys.dailyClientsKey);
    if (dailyClients == null) {
      await prefs.setInt(prefKeys.dailyClientsKey, 1);
    }
    int totalClients = prefs.getInt(prefKeys.totalClientsKey);
    if (totalClients == null) {
      await prefs.setInt(prefKeys.totalClientsKey, 0);
    }
    int dailyRebooking = prefs.getInt(prefKeys.dailyRebookingKey);
    if (dailyRebooking == null) {
      await prefs.setInt(prefKeys.dailyRebookingKey, 1);
    }
    int totalRebooking = prefs.getInt(prefKeys.totalRebookingKey);
    if (totalRebooking == null) {
      await prefs.setInt(prefKeys.totalRebookingKey, 0);
    }
    int dailyHairMasks = prefs.getInt(prefKeys.dailyHairMasksKey);
    if (dailyHairMasks == null) {
      await prefs.setInt(prefKeys.dailyHairMasksKey, 1);
    }
    int totalHairMasks = prefs.getInt(prefKeys.totalHairMasksKey);
    if (totalHairMasks == null) {
      await prefs.setInt(prefKeys.totalHairMasksKey, 0);
    }
    _getValuesFromSharedPrefs();
  }

  _getValuesFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalDays = prefs.getInt(prefKeys.totalDaysKey);
    int dailyClients = prefs.getInt(prefKeys.dailyClientsKey);
    int totalClients = prefs.getInt(prefKeys.totalClientsKey);
    int dailyRebooking = prefs.getInt(prefKeys.dailyRebookingKey);
    int totalRebooking = prefs.getInt(prefKeys.totalRebookingKey);
    int dailyHairMasks = prefs.getInt(prefKeys.dailyHairMasksKey);
    int totalHairMasks = prefs.getInt(prefKeys.totalHairMasksKey);
    setState(() => _initPrefValues(totalDays, dailyClients, totalClients,
        dailyRebooking, totalRebooking, dailyHairMasks, totalHairMasks));
  }

  _initPrefValues(
      int totalDays,
      int dailyClients,
      int totalClients,
      int dailyRebooking,
      int totalRebooking,
      int dailyHairMasks,
      int totalHairMasks) {
    _totalDays = totalDays;
    _dailyClients = dailyClients;
    _totalClients = totalClients;
    _dailyRebooking = dailyRebooking;
    _totalRebooking = totalRebooking;
    _dailyHairMasks = dailyHairMasks;
    _totalHairMasks = totalHairMasks;
  }

  _addDay() {
    setState(() {
      if (_totalDays == 31)
        _totalDays = 1;
      else
        _totalDays += 1;

      _setTotalDaysPref();
    });
  }

  _subtractDay() {
    setState(() {
      if (_totalDays == 1)
        _totalDays = 31;
      else
        _totalDays -= 1;

      _setTotalDaysPref();
    });
  }

  _setTotalDaysPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.totalDaysKey, _totalDays);
  }

  _addClient() {
    setState(() {
      _dailyClients += 1;

      _setDailyClientsPref();
    });
  }

  _subtractClient() {
    setState(() {
      if (_dailyClients == 0)
        _dailyClients = 0;
      else
        _dailyClients -= 1;

      _setDailyClientsPref();
    });
  }

  _setDailyClientsPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.dailyClientsKey, _dailyClients);
  }

  _addDailyClientsToTotal() {
    setState(() {
      _totalClients += _dailyClients;
      _setTotalClientsPref();
    });
  }

  _clearTotalClients() {
    setState(() {
      _totalClients = 0;
      _setTotalClientsPref();
    });
  }

  _setTotalClientsPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.totalClientsKey, _totalClients);
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = IncDecWidget(
      titleOnTop: false,
      title: 'Total Days:',
      value: _totalDays,
      incrementFunction: _addDay,
      decrementFunction: _subtractDay,
    );

    final clients = OtherCalcWidget(
      incDecWidget: IncDecWidget(
        value: _dailyClients,
        incrementFunction: _addClient,
        decrementFunction: _subtractClient,
      ),
      title: 'Clients:',
      totalValue: _totalClients,
      addToTotalFunction: _addDailyClientsToTotal,
      clearFunction: _clearTotalClients,
    );

    final rebooking = OtherCalcWidget(
      incDecWidget: IncDecWidget(
        value: _dailyRebooking,
        incrementFunction: _addClient,
        decrementFunction: _subtractClient,
      ),
      title: 'Rebooking:',
      totalValue: _totalRebooking,
      addToTotalFunction: _addDailyClientsToTotal,
      clearFunction: _clearTotalClients,
    );

    final hairMasks = OtherCalcWidget(
      incDecWidget: IncDecWidget(
        value: _dailyHairMasks,
        incrementFunction: _addClient,
        decrementFunction: _subtractClient,
      ),
      title: 'Hair masks:',
      totalValue: _totalHairMasks,
      addToTotalFunction: _addDailyClientsToTotal,
      clearFunction: _clearTotalClients,
    );

    return new SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            daysLeft,
            clients,
            rebooking,
            hairMasks,
          ],
        ),
      ),
    );
  }
}
