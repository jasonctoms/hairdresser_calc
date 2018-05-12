import 'package:flutter/material.dart';

import 'package:hairdresser_calc/salary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _commissionKey = 'commission';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _setDefaultCommission();
    return MaterialApp(
      title: 'Hairdresser Calc',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        textSelectionHandleColor: Colors.blue[900],
      ),
      home: SalaryScreen(title: 'Hairdresser Calc'),
    );
  }

  _setDefaultCommission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double counter = prefs.getDouble(_commissionKey);
    if (counter == null) {
      await prefs.setDouble(_commissionKey, 0.4);
    }
  }
}
