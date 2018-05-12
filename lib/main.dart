import 'package:flutter/material.dart';

import 'package:hairdresser_calc/salary_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hairdresser Calc',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        ),
        textSelectionHandleColor: Colors.blue[900],
      ),
      home: new SalaryScreen(title: 'Hairdresser Calc'),
    );
  }
}
