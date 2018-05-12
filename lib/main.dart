import 'package:flutter/material.dart';

import 'package:hairdresser_calc/salary_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
}
