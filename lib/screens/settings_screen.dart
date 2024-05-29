// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:marinamoda/main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:marinamoda/helpers/Strings.dart';
import 'package:marinamoda/helpers/icons.dart';
import 'package:marinamoda/helpers/Constant.dart';
import 'package:marinamoda/widgets/admob_service.dart';
import 'package:marinamoda/widgets/change_theme_button_widget.dart';
import 'app_content_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin<SettingsScreen> {
  @override
  bool get wantKeepAlive => true;
  final InAppReview inAppReview = InAppReview.instance;
  @override
  void initState() {
    super.initState();
    if (showInterstitialAds) {
      AdMobService.createInterstitialAd();
    }
    // inAppReview.openStoreListing(
    //   appStoreId: iOSAppId,
    // );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      top: Platform.isIOS ? false : true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(CustomStrings.settings),
          elevation: 2,
        ),
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: !showBottomNavigationBar
            ? FloatingActionButton(
                child: Lottie.asset(
                  Theme.of(context).colorScheme.homeIcon,
                  height: 30,
                  repeat: true,
                ),
                onPressed: () {
                  // setState(() {
                  Navigator.of(context).pop();
                  // });
                },
              )
            : null,
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        _buildIcon(Theme.of(context).colorScheme.darkModeIcon),
                    title: _buildTitle(CustomStrings.darkMode),
                    trailing: ChangeThemeButtonWidget(),
                  ),
                  ListTile(
                    leading:
                        _buildIcon(Theme.of(context).colorScheme.shareIcon),
                    title: _buildTitle(CustomStrings.share),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () => Share.share(
                        Platform.isAndroid
                            ? shareAndroidAppMessge
                            : shareiOSAppMessage,
                        subject: Platform.isAndroid
                            ? shareAndroidAppMessge
                            : shareiOSAppMessage),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildIcon(String icon) {
    return SvgPicture.asset(
      icon,
      width: 20,
      height: 20,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  void _onPressed(Widget routeName) {
    if (showInterstitialAds) {
      AdMobService.showInterstitialAd();
    }
    navigatorKey.currentState!
        .push(CupertinoPageRoute(builder: (_) => routeName));
  }
}
