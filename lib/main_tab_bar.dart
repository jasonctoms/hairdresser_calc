import 'package:flutter/material.dart';

import 'package:hairdresser_calc/localized_strings.dart';
import 'package:hairdresser_calc/salary_screen.dart';

class MainTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocalizedStrings.of(context).appName),
          bottom: TabBar(
            tabs: [
              Tab(text: LocalizedStrings.of(context).salary),
              Tab(text: 'Other'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SalaryScreen(),
            Icon(Icons.hot_tub),
          ],
        ),
      ),
    );
  }
}
