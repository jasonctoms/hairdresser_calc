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
      'appName': 'Hairdresser Calc',
      'cancel': 'Cancel',
      'done': 'Done',
      'commission': 'Commission:',
      'currentCommission': 'Current commission:',
      'commissionPercent': 'Commission %',
      'change': 'CHANGE',
      'validationMessage': 'Invalid number entered',
      'currentIntake': 'Current Intake',
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
      'intakeNeededToReachGoal': 'Intake needed to reach goal:',
      'intakeNeededPerDay': 'Intake needed per day:',
    },
    'nb': {
      'appName': 'Frisør Kalk',
      'cancel': 'Avbryt',
      'done': 'Ferdig',
      'commission': 'Provisjon:',
      'currentCommission': 'Nåværende provisjon:',
      'commissionPercent': 'Provisjon %',
      'change': 'ENDRE',
      'validationMessage': 'Ugyldig nummer inntastet',
      'currentIntake': 'Nåværende Inntak',
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
      'intakeNeededToReachGoal': 'Må ta inn å oppnå mål:',
      'intakeNeededPerDay': 'Må ta inn per dag:',
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

  String get currentIntake {
    return _localizedValues[locale.languageCode]['currentIntake'];
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

  String get intakeNeededToReachGoal {
    return _localizedValues[locale.languageCode]['intakeNeededToReachGoal'];
  }

  String get intakeNeededPerDay {
    return _localizedValues[locale.languageCode]['intakeNeededPerDay'];
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
