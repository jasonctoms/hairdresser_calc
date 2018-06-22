import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class LocalizedStrings {
  LocalizedStrings(this.locale);

  final Locale locale;

  static LocalizedStrings of(BuildContext context) {
    return Localizations.of<LocalizedStrings>(context, LocalizedStrings);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Hairdre\$\$er',
      'cancel': 'Cancel',
      'done': 'Done',
      'clear': 'CLEAR',
      //SalaryScreen---------------------------------
      'commission': 'Commission:',
      'currentCommission': 'Current commission:',
      'commissionPercent': 'Commission %',
      'change': 'CHANGE',
      'validationMessage': 'Invalid number entered',
      'todaysIntake': 'Today\'s Intake',
      'monthsIntake': 'Month\'s Intake',
      'daysLeft': 'Days Left',
      'goalGross': 'Goal Gross',
      'goalNet': 'Goal Net',
      'goalSalary': 'Goal Salary',
      'gross': 'Gross',
      'net': 'Net',
      'salary': 'Salary',
      'goalGrossResult': 'Goal gross:',
      'goalNetResult': 'Goal net:',
      'goalSalaryResult': 'Goal salary:',
      'salaryWithCurrentIntake': 'Salary with current intake:',
      'intakeNeededToReachGoal': 'Intake needed to reach goal:',
      'intakeNeededPerDay': 'Intake needed per day:',
      //Rebooking/Hair mask---------------------------
      'rebookingHairMaskTitle': 'Rebooking/Hair mask',
      'dailyClients': 'Daily Clients',
      'totalClients': 'Total Clients',
      'dailyRebooking': 'Daily Rebooking',
      'totalRebooking': 'Total Rebooking',
      'dailyHairMasks': 'Daily Hair Masks',
      'totalHairMasks': 'Total Hair Masks',
    },
    'nb': {
      'appName': 'Fri\$ør',
      'cancel': 'Avbryt',
      'done': 'Ferdig',
      'clear': 'TOMT',
      //SalaryScreen---------------------------------
      'commission': 'Provisjon:',
      'currentCommission': 'Nåværende provisjon:',
      'commissionPercent': 'Provisjon %',
      'change': 'ENDRE',
      'validationMessage': 'Ugyldig nummer inntastet',
      'todaysIntake': 'Dagens Inntak',
      'monthsIntake': 'Måneds Inntak:',
      'daysLeft': 'Dager Igjen',
      'goalGross': 'Mål Brutto',
      'goalNet': 'Mål Netto',
      'goalSalary': 'Mål Lønn',
      'gross': 'Brutto',
      'net': 'Netto',
      'salary': 'Lønn',
      'goalGrossResult': 'Mål brutto:',
      'goalNetResult': 'Mål netto:',
      'goalSalaryResult': 'Mål lønn:',
      'salaryWithCurrentIntake': 'Lønn med nåværende inntak:',
      'intakeNeededToReachGoal': 'Må ta inn å oppnå mål:',
      'intakeNeededPerDay': 'Må ta inn per dag:',
      //Rebooking/Hair mask---------------------------
      'rebookingHairMaskTitle': 'Rebooking/Hårkur',
      'dailyClients': 'Daglige Klienter',
      'totalClients': 'Totale Klienter',
      'dailyRebooking': 'Daglige Rebooking',
      'totalRebooking': 'Totale Rebooking',
      'dailyHairMasks': 'Daglige Hårkur',
      'totalHairMasks': 'Totale Hårkur',
    },
  };

  String get appName {
    return _localizedValues[locale.languageCode]['appName'];
  }

  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get done {
    return _localizedValues[locale.languageCode]['done'];
  }

  String get clear {
    return _localizedValues[locale.languageCode]['clear'];
  }

  String get commission {
    return _localizedValues[locale.languageCode]['commission'];
  }

  String get currentCommission {
    return _localizedValues[locale.languageCode]['currentCommission'];
  }

  String get commissionPercent {
    return _localizedValues[locale.languageCode]['commissionPercent'];
  }

  String get change {
    return _localizedValues[locale.languageCode]['change'];
  }

  String get validationMessage {
    return _localizedValues[locale.languageCode]['validationMessage'];
  }

  String get todaysIntake {
    return _localizedValues[locale.languageCode]['todaysIntake'];
  }

  String get monthsIntake {
    return _localizedValues[locale.languageCode]['monthsIntake'];
  }

  String get daysLeft {
    return _localizedValues[locale.languageCode]['daysLeft'];
  }

  String get goalGross {
    return _localizedValues[locale.languageCode]['goalGross'];
  }

  String get goalNet {
    return _localizedValues[locale.languageCode]['goalNet'];
  }

  String get goalSalary {
    return _localizedValues[locale.languageCode]['goalSalary'];
  }

  String get gross {
    return _localizedValues[locale.languageCode]['gross'];
  }

  String get net {
    return _localizedValues[locale.languageCode]['net'];
  }

  String get salary {
    return _localizedValues[locale.languageCode]['salary'];
  }

  String get goalGrossResult {
    return _localizedValues[locale.languageCode]['goalGrossResult'];
  }

  String get goalNetResult {
    return _localizedValues[locale.languageCode]['goalNetResult'];
  }

  String get goalSalaryResult {
    return _localizedValues[locale.languageCode]['goalSalaryResult'];
  }

  String get salaryWithCurrentIntake {
    return _localizedValues[locale.languageCode]['salaryWithCurrentIntake'];
  }

  String get intakeNeededToReachGoal {
    return _localizedValues[locale.languageCode]['intakeNeededToReachGoal'];
  }

  String get intakeNeededPerDay {
    return _localizedValues[locale.languageCode]['intakeNeededPerDay'];
  }

  String get rebookingHairMaskTitle {
    return _localizedValues[locale.languageCode]['rebookingHairMaskTitle'];
  }

  String get dailyClients {
    return _localizedValues[locale.languageCode]['dailyClients'];
  }

  String get totalClients {
    return _localizedValues[locale.languageCode]['totalClients'];
  }

  String get dailyRebooking {
    return _localizedValues[locale.languageCode]['dailyRebooking'];
  }

  String get totalRebooking {
    return _localizedValues[locale.languageCode]['totalRebooking'];
  }

  String get dailyHairMasks {
    return _localizedValues[locale.languageCode]['dailyHairMasks'];
  }

  String get totalHairMasks {
    return _localizedValues[locale.languageCode]['totalHairMasks'];
  }
}

class LocalizedStringsDelegate extends LocalizationsDelegate<LocalizedStrings> {
  const LocalizedStringsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'nb'].contains(locale.languageCode);

  @override
  Future<LocalizedStrings> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return new SynchronousFuture<LocalizedStrings>(
        new LocalizedStrings(locale));
  }

  @override
  bool shouldReload(LocalizedStringsDelegate old) => false;
}
