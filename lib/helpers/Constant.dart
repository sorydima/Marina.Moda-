import 'package:flutter/material.dart';
import 'package:marinamoda/helpers/icons.dart';

import 'Strings.dart';

const appName = 'Marina.Moda ® 💖♥️';

const String appbartitle = 'Marina.Moda ® 💖♥️';
const String andoidPackageName = 'com.marina.moda';

//change this url to set your URL in app
const String webinitialUrl =
    'https://marina.moda/';
const String firstTabUrl = 'https://marina.moda/channel/popular-albums/';

//keep local content of pages of setting screen
const String aboutPageURL = 'https://marina.moda/pages/about-us/';
const String privacyPageURL = 'https://marina.moda/pages/privacy-policy/';
const String termsPageURL = 'https://marina.moda/pages/terms-of-service/';

//Change App id of android and IOS app
const String androidAppId = 'com.marina.moda';

const String iOSAppId = 'com.marina.moda';

const String shareAppTitle = 'Marina.Moda';
const String shareiOSAppMessage =
    'Download $appName App from this link : $appstoreURLIos !';
const String shareAndroidAppMessge =
    'Download $appName App from this link : $playstoreURLAndroid !';

const String playstoreURLAndroid = 'https://play.google.com/store/apps/details?id=$androidAppId';
const String appstoreURLIos = '';

//To turn on/off ads
const bool showInterstitialAds = false;
const bool showBannerAds = false;
const bool showOpenAds = false;

//To turn on/off display of bottom navigation bar
const bool showBottomNavigationBar = false;

//To show/remove splash screen
const bool showSplashScreen = true;

//To show/remove onboarding screen
const bool showOnboardingScreen = false;

//To remove/display header/footer of website
const bool hideHeader = true;
const bool hideFooter = false;

//Ids for interstitial Ad
const androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
const iosInterstitialAdId = 'ca-app-pub-3940256099942544/4411468910';

//Ids for banner Ad
const androidBannerAdId = 'ca-app-pub-3940256099942544/6300978111';
const iosBannerAdId = 'ca-app-pub-3940256099942544/2934735716';

//Ids for app open Ad
const androidOpenAdId = 'ca-app-pub-3940256099942544/3419835294';
const iosOpenAdId = 'ca-app-pub-3940256099942544/5662855259';

//icon to set when get firebase messages
const String notificationIcon = '@mipmap/ic_launcher_squircle';

//path to icons   *** don't change these values**
const String iconPath = 'assets/icons/';

//turn on/off enable storage permission
const bool isStoragePermissionEnabled = true;

//add/remove tabs here
List navigationTabs(BuildContext context) => [
      {
        'url': webinitialUrl,
        'label': CustomStrings.home,
        'icon': Theme.of(context).colorScheme.homeIcon
      },
    ];
