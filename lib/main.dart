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
}
