import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:hairdresser_calc/commission_dialog.dart';

const _commissionKey = 'commission';
const _padding = EdgeInsets.all(16.0);

class SalaryScreen extends StatefulWidget {
  SalaryScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  String _commissionText;
  double _commissionValue;

  @override
  void initState() {
    super.initState();
    _getCommissionFromSharedPrefs();
  }

  _getCommissionFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double commissionValue = prefs.getDouble(_commissionKey);
    setState(() => _setCommission(commissionValue));
  }

  _setCommission(double commissionValue) {
    _commissionValue = commissionValue;
    _commissionText = (commissionValue * 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: _padding,
        child: Column(
          children: [
            Text(_setCommissionText()),
            RaisedButton(
              child: Text('Change'),
              color: Colors.blue,
              onPressed: () => _openDialog(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.all(16.0),
            ),
          ],
        ),
      ),
    );
  }

  String _setCommissionText() {
    if (_commissionValue == null) {
      return 'Commission: X%';
    }
    return 'Commission: ' + _commissionText + '%';
  }

  //TODO: update this page after
  _openDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommissionDialog(commission: _commissionText);
        });
  }
}
