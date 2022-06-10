import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationHelper {
  TranslationHelper._();

  static  getLanguage(BuildContext context) {
    var language = context.deviceLocale.countryCode!.toLowerCase();
    switch (language) {
      case "tr":
        return LocaleType.tr;
      case "en":
        return LocaleType.en;
    }
  }
}
