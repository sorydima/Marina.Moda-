import '../helpers/Constant.dart';

import 'package:flutter/material.dart';

extension CustomIcons on ColorScheme {
  String get homeIcon => brightness == Brightness.dark
      ? iconPath + 'home_dark.json'
      : iconPath + 'home_light.json';
  String get demoIcon => brightness == Brightness.dark
      ? iconPath + 'search_dark.json'
      : iconPath + 'search_light.json';
  String get settingsIcon => brightness == Brightness.dark
      ? iconPath + 'settings_dark.json'
      : iconPath + 'settings_light.json';
  String get splashLogo => iconPath + 'splash_logo.svg';

  String get darkModeIcon => iconPath + 'darkmode.svg';

  String get aboutUsIcon => iconPath + 'aboutus.svg';

  String get privacyIcon => iconPath + 'privacy.svg';

  String get termsIcon => iconPath + 'terms.svg';

  String get shareIcon => iconPath + 'share.svg';

  String get rateUsIcon => iconPath + 'rateus.svg';

  String get webIcon => iconPath + 'website.svg';

  String get noInternetIcon => iconPath + 'no_internet.svg';

  String get onboardingImage1 => iconPath + 'onboarding_a.svg';

  String get onboardingImage2 => iconPath + 'onboarding_b.svg';

  String get onboardingImage3 => iconPath + 'onboarding_c.svg';
}
