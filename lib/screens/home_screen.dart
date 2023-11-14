// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/src/provider.dart';

import '../helpers/Icons.dart';
import '../main.dart';
// import '../widgets/admob_service.dart';
import '../widgets/admob_service.dart';
import '../provider/navigationBarProvider.dart';
import '../helpers/Constant.dart';
import '../widgets/load_web_view.dart';

class HomeScreen extends StatefulWidget {
  final String url;
  final bool mainPage;
  const HomeScreen(this.url, {Key? key, this.mainPage = true})
      : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController navigationContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));
  @override
  void initState() {
    super.initState();
    if (!showBottomNavigationBar) {
      Future.delayed(Duration.zero, () {
        context
            .read<NavigationBarProvider>()
            .setAnimationController(navigationContainerAnimationController);
      });
    }
  }

  @override
  void dispose() {
    navigationContainerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        bottomNavigationBar: displayAd(),
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: LoadWebView(
            url: widget.url,
            webUrl: true,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: !showBottomNavigationBar
            ? FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                    CurvedAnimation(
                        parent: navigationContainerAnimationController,
                        curve: Curves.easeInOut)),
                child: SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset.zero, end: const Offset(0.0, 1.0))
                        .animate(CurvedAnimation(
                            parent: navigationContainerAnimationController,
                            curve: Curves.easeInOut)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: FloatingActionButton(
                        child: Lottie.asset(
                          Theme.of(context).colorScheme.settingsIcon,
                          height: 30,
                          repeat: true,
                        ),
                        onPressed: () {
                          // setState(() {
                          navigatorKey.currentState!.pushNamed('settings');
                          // });
                        },
                      ),
                    )))
            : !widget.mainPage
                ? Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20),
                    child: FloatingActionButton(
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 30,
                      ),
                      onPressed: () {
                        if (mounted) {
                          context
                              .read<NavigationBarProvider>()
                              .animationController
                              .reverse();
                        }
                        Navigator.of(context).pop();
                        // });
                      },
                    ),
                  )
                : null);
  }

  Widget displayAd() {
    if (showBannerAds) {
      return SizedBox(
        height: 50.0,
        width: double.maxFinite,
        child: AdWidget(
            key: UniqueKey(), ad: AdMobService.createBannerAd()..load()),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
