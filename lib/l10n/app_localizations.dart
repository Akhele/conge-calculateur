import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ar.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizationsEn();
  }

  // Home Screen
  String get appTitle;
  String get remainingDays;
  String get outOfDays;
  String get used;
  String get total;
  String get calculateVacation;
  String get planYourRestDays;
  String get history;
  String get viewPastVacations;
  String get holidays;
  String get moroccanHolidaysCalendar;
  String get resetYear;
  String get settings;

  // Calculator Screen
  String get calculateVacationTitle;
  String get workingDaysAvailable;
  String get days;
  String get weekendsAndHolidaysAutoAdded;
  String get startDate;
  String get numberOfWorkingDays;
  String get workingDaysOnly;
  String get calculate;

  // Result Screen
  String get calculationResult;
  String get returnToWorkDate;
  String get vacationDetails;
  String get requestedWorkingDays;
  String get weekendsIncluded;
  String get holidaysIncluded;
  String get totalDuration;
  String get holidaysDuringVacation;
  String get youWillBeOnVacation;
  String get confirmAndSave;
  String get modify;

  // History Screen
  String get vacationHistory;
  String get noVacationsRecorded;
  String get confirmedVacationsWillAppearHere;
  String get ongoing;
  String get upcoming;
  String get completed;
  String get workingDays;
  String get deleteVacation;
  String get areYouSureDeleteVacation;
  String get cancel;
  String get delete;
  String get vacationDeleted;

  // Holidays Screen
  String get moroccanHolidays;
  String get noHolidaysAvailable;
  String get refreshHolidays;
  String get refreshingHolidays;
  String get today;
  String get soon;

  // Settings Screen
  String get settingsTitle;
  String get configureAnnualVacationDays;
  String get annualVacationDays;
  String get totalWorkingDaysPerYear;
  String get currently;
  String get important;
  String get reduceDaysWarning;
  String get save;
  String get settingsSaved;
  String get enterValidNumber;
  String get noInternetConnection;
  String get noInternetMessage;
  String get understood;

  // Reset Dialog
  String get resetYearTitle;
  String get resetYearMessage;
  String get reset;
  String get yearResetSuccessfully;

  // Language
  String get language;
  String get selectLanguage;
  String get languageChanged;

  // Common
  String get monday;
  String get tuesday;
  String get wednesday;
  String get thursday;
  String get friday;
  String get saturday;
  String get sunday;
  String get january;
  String get february;
  String get march;
  String get april;
  String get may;
  String get june;
  String get july;
  String get august;
  String get september;
  String get october;
  String get november;
  String get december;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'fr':
        return AppLocalizationsFr();
      case 'ar':
        return AppLocalizationsAr();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

