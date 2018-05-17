import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'pref_keys.dart' as prefKeys;
import 'package:hairdresser_calc/salary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hairdresser_calc/localized_strings.dart';

void main() => runApp(HairdresserCalc());

class HairdresserCalc extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _setDefaultPrefs();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => LocalizedStrings.of(context).appName,
      localizationsDelegates: [
        const LocalizedStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('nb', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        textSelectionHandleColor: Colors.green[800],
      ),
      home: SalaryScreen(),
    );
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
  }
}
