import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/localized_strings.dart';

class OtherCalculations extends StatefulWidget{
  OtherCalculations({Key key}) : super(key: key);

  @override
  _OtherCalculationsState createState() => _OtherCalculationsState();
}

class _OtherCalculationsState extends State<OtherCalculations>{
  int _dailyClients;
  bool _showDailyClientsValidationError = false;
  final _dailyClientsFieldKey = GlobalKey(debugLabel: 'dailyClientsFieldKey');
  int _totalClients;
  int _dailyHairMasks;
  bool _showDailyHairMasksValidationError = false;
  final _dailyHairMasksFieldKey = GlobalKey(debugLabel: 'dailyHairMasksFieldKey');
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
    int dailyClients = prefs.getInt(prefKeys.dailyClientsKey);
    if (dailyClients == null) {
      await prefs.setInt(prefKeys.dailyClientsKey, 1);
    }
    int totalClients = prefs.getInt(prefKeys.totalClientsKey);
    if (totalClients == null) {
      await prefs.setInt(prefKeys.totalClientsKey, 20);
    }
    int dailyHairMasks = prefs.getInt(prefKeys.dailyHairMasksKey);
    if (dailyHairMasks == null) {
      await prefs.setInt(prefKeys.dailyHairMasksKey, 5);
    }
    int totalHairMasks = prefs.getInt(prefKeys.totalHairMasksKey);
    if (totalHairMasks == null) {
      await prefs.setInt(prefKeys.totalHairMasksKey, 10);
    }
    int totalDays = prefs.getInt(prefKeys.totalDaysKey);
    if (totalDays == null) {
      await prefs.setInt(prefKeys.totalDaysKey, 1);
    }
    _getValuesFromSharedPrefs();
  }

  _getValuesFromSharedPrefs(){

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }

}