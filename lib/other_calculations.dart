import 'package:flutter/material.dart';
import 'package:hairdresser_calc/other_calc_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/incdec_widget.dart';
import 'package:hairdresser_calc/localized_strings.dart';

enum MetricType { rebooking, hairMask }

class OtherCalculations extends StatefulWidget {
  OtherCalculations({Key key}) : super(key: key);

  @override
  _OtherCalculationsState createState() => _OtherCalculationsState();
}

class _OtherCalculationsState extends State<OtherCalculations> {
  int _dailyClients = 0;
  int _totalClients = 0;
  int _dailyRebooking = 0;
  int _totalRebooking = 0;
  int _dailyHairMasks = 0;
  int _totalHairMasks = 0;

  @override
  void initState() {
    super.initState();
    _setDefaultPrefs();
  }

  _setDefaultPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    int dailyClients = prefs.getInt(prefKeys.dailyClientsKey);
    int totalClients = prefs.getInt(prefKeys.totalClientsKey);
    int dailyRebooking = prefs.getInt(prefKeys.dailyRebookingKey);
    int totalRebooking = prefs.getInt(prefKeys.totalRebookingKey);
    int dailyHairMasks = prefs.getInt(prefKeys.dailyHairMasksKey);
    int totalHairMasks = prefs.getInt(prefKeys.totalHairMasksKey);
    setState(() => _initPrefValues(dailyClients, totalClients, dailyRebooking,
        totalRebooking, dailyHairMasks, totalHairMasks));
  }

  _initPrefValues(int dailyClients, int totalClients, int dailyRebooking,
      int totalRebooking, int dailyHairMasks, int totalHairMasks) {
    _dailyClients = dailyClients;
    _totalClients = totalClients;
    _dailyRebooking = dailyRebooking;
    _totalRebooking = totalRebooking;
    _dailyHairMasks = dailyHairMasks;
    _totalHairMasks = totalHairMasks;
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

  _addRebooking() {
    setState(() {
      _dailyRebooking += 1;

      _setDailyRebookingPref();
    });
  }

  _subtractRebooking() {
    setState(() {
      if (_dailyRebooking == 0)
        _dailyRebooking = 0;
      else
        _dailyRebooking -= 1;

      _setDailyRebookingPref();
    });
  }

  _setDailyRebookingPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.dailyRebookingKey, _dailyRebooking);
  }

  _addDailyRebookingToTotal() {
    setState(() {
      _totalRebooking += _dailyRebooking;
      _setTotalRebookingPref();
    });
  }

  _clearTotalRebooking() {
    setState(() {
      _totalRebooking = 0;
      _setTotalRebookingPref();
    });
  }

  _setTotalRebookingPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.totalRebookingKey, _totalRebooking);
  }

  _addHairMask() {
    setState(() {
      _dailyHairMasks += 1;

      _setDailyHairMasksPref();
    });
  }

  _subtractHairMask() {
    setState(() {
      if (_dailyHairMasks == 0)
        _dailyHairMasks = 0;
      else
        _dailyHairMasks -= 1;

      _setDailyHairMasksPref();
    });
  }

  _setDailyHairMasksPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.dailyHairMasksKey, _dailyHairMasks);
  }

  _addDailyHairMasksToTotal() {
    setState(() {
      _totalHairMasks += _dailyHairMasks;
      _setTotalHairMasksPref();
    });
  }

  _clearTotalHairMasks() {
    setState(() {
      _totalHairMasks = 0;
      _setTotalHairMasksPref();
    });
  }

  _setTotalHairMasksPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeys.totalHairMasksKey, _totalHairMasks);
  }

  Widget _percentageWidget(
      String title, int variable, int clients, MetricType metricType) {
    double value;
    if (clients == 0)
      value = 0.0;
    else
      value = (variable / clients) * 100.0;

    return Column(
      children: [
        Text(title),
        Text(
          value.toStringAsPrecision(3) + '%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _percentageColor(value, metricType),
            fontSize: 30.0,
          ),
        ),
      ],
    );
  }

  Color _percentageColor(double value, MetricType metricType) {
    if (metricType == MetricType.rebooking) {
      if (value < 15.0) return Colors.red;
      if (value < 25.0) return Colors.orange;
      return Colors.green;
    } else if (metricType == MetricType.hairMask) {
      if (value < 10.0) return Colors.red;
      if (value < 12.5) return Colors.orange;
      return Colors.green;
    } else
      return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final clients = OtherCalcWidget(
      incDecWidget: IncDecWidget(
        titleOnTop: true,
        title: LocalizedStrings.of(context).dailyClients,
        value: _dailyClients,
        incrementFunction: _addClient,
        decrementFunction: _subtractClient,
      ),
      title: LocalizedStrings.of(context).totalClients,
      totalValue: _totalClients,
      addToTotalFunction: _addDailyClientsToTotal,
      clearFunction: _clearTotalClients,
    );

    final rebooking = OtherCalcWidget(
      incDecWidget: IncDecWidget(
        titleOnTop: true,
        title: LocalizedStrings.of(context).dailyRebooking,
        value: _dailyRebooking,
        incrementFunction: _addRebooking,
        decrementFunction: _subtractRebooking,
      ),
      title: LocalizedStrings.of(context).totalRebooking,
      totalValue: _totalRebooking,
      addToTotalFunction: _addDailyRebookingToTotal,
      clearFunction: _clearTotalRebooking,
    );

    final hairMasks = OtherCalcWidget(
      incDecWidget: IncDecWidget(
        titleOnTop: true,
        title: LocalizedStrings.of(context).dailyHairMasks,
        value: _dailyHairMasks,
        incrementFunction: _addHairMask,
        decrementFunction: _subtractHairMask,
      ),
      title: LocalizedStrings.of(context).totalHairMasks,
      totalValue: _totalHairMasks,
      addToTotalFunction: _addDailyHairMasksToTotal,
      clearFunction: _clearTotalHairMasks,
    );

    final rebookingPercents = Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        top: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _percentageWidget(LocalizedStrings.of(context).dailyRebooking + ' %',
              _dailyRebooking, _dailyClients, MetricType.rebooking),
          _percentageWidget(LocalizedStrings.of(context).totalRebooking + ' %',
              _totalRebooking, _totalClients, MetricType.rebooking),
        ],
      ),
    );

    final hairMaskPercents = Padding(
      padding: EdgeInsets.only(
        bottom: 16.0,
        top: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _percentageWidget(LocalizedStrings.of(context).dailyHairMasks + ' %',
              _dailyHairMasks, _dailyClients, MetricType.hairMask),
          _percentageWidget(LocalizedStrings.of(context).totalHairMasks + ' %',
              _totalHairMasks, _totalClients, MetricType.hairMask),
        ],
      ),
    );

    return new SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            clients,
            rebooking,
            hairMasks,
            rebookingPercents,
            hairMaskPercents,
          ],
        ),
      ),
    );
  }
}
