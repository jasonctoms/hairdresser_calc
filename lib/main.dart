import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hairdresser_calc/localized_strings.dart';
import 'package:hairdresser_calc/main_tab_bar.dart';

void main() => runApp(HairdresserCalc());

class HairdresserCalc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const LocalizedStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('nb', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          LocalizedStrings.of(context).appName,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        textSelectionHandleColor: Colors.teal,
      ),
      home: MainTabBar(),
    );
  }
}
