import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:marinamoda/main.dart';
import 'package:marinamoda/helpers/Icons.dart';
import 'package:marinamoda/helpers/Constant.dart';
import 'package:marinamoda/helpers/Strings.dart';
import 'package:marinamoda/widgets/GlassBoxCurve.dart';
import 'package:marinamoda/widgets/firebase_initialize.dart';
import 'package:marinamoda/provider/navigationBarProvider.dart';
import 'package:provider/src/provider.dart';

import 'package:marinamoda/screens/home_screen.dart';
import 'package:marinamoda/widgets/admob_service.dart';
import 'package:marinamoda/widgets/app_lifecycle_refactor.dart';
import 'settings_screen.dart';

class MyHomePage extends StatefulWidget {
  final String webUrl;

  const MyHomePage({Key? key, required this.webUrl}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = showBottomNavigationBar ? 1 : 0;
  var _previousIndex;
  late AnimationController idleAnimation;
  late AnimationController onSelectedAnimation;
  late AnimationController onChangedAnimation;
  Duration animationDuration = const Duration(milliseconds: 700);
  AppLifecycleReactor? _appLifecycleReactor;
  late AnimationController navigationContainerAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String deepLinkUrl = webinitialUrl;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];

  late final List<Widget> _tabs = [];
  List _navigationTabs = [];
  @override
  void initState() {
    super.initState();
    initializeTabs();
    idleAnimation = AnimationController(vsync: this);
    onSelectedAnimation =
        AnimationController(vsync: this, duration: animationDuration);
    onChangedAnimation =
        AnimationController(vsync: this, duration: animationDuration);
    Future.delayed(Duration.zero, () {
      context
          .read<NavigationBarProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
    FirebaseInitialize().initFirebaseState(context);

    initDynamicLinks();
    if (showOpenAds == true) {
      AdMobService appOpenAdManager = AdMobService()..loadOpenAd();
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor!.listenToAppStateChanges();
    }
  }

  initializeTabs() {
    if (showBottomNavigationBar) {
      Future.delayed(Duration.zero, () {
        for (int i = 0; i < _navigationTabs.length; i++) {
          _navigatorKeys.add(GlobalKey<NavigatorState>());

          _tabs.add(
            Navigator(
              key: _navigatorKeys[i],
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(
                  builder: (_) => HomeScreen(
                    _navigationTabs[i]['url'],
                  ),
                );
              },
            ),
          );
        }
        _navigatorKeys.add(GlobalKey<NavigatorState>());
        _tabs.add(
          Navigator(
            key: _navigatorKeys[_navigationTabs.length],
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(builder: (_) => const SettingsScreen());
            },
          ),
        );

        setState(() {});
      });
    } else {
      _navigatorKeys.add(GlobalKey<NavigatorState>());
      setState(() {});
    }
  }

  Future<void> initDynamicLinks() async {
    if (!mounted) {
      return;
    }
    dynamicLinks.onLink.listen((dynamicLinkData) {
      deepLinkUrl = dynamicLinkData.link.toString();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => MyHomePage(
                  webUrl: deepLinkUrl,
                )),
        (route) => false,
      );
    }).onError((error) {});
  }

  @override
  void dispose() {
    idleAnimation.dispose();
    onSelectedAnimation.dispose();
    onChangedAnimation.dispose();
    navigationContainerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //add / remove tabs here
    _navigationTabs = navigationTabs(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).cardColor,
      statusBarBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.dark
          : Brightness.light,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () => _navigateBack(context),
      child: GestureDetector(
        onTap: () =>
            context.read<NavigationBarProvider>().animationController.reverse(),
        child: SafeArea(
          top: Platform.isIOS ? false : true,
          bottom: true,
          child: Scaffold(
            extendBody: true,

            // extendBody: true,
            bottomNavigationBar: showBottomNavigationBar
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
                        child: _bottomNavigationBar),
                  )
                : null,
            body: showBottomNavigationBar
                ? IndexedStack(
                    index: _selectedIndex,
                    children: _tabs,
                  )
                : Navigator(
                    key: _navigatorKeys[0],
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                          builder: (_) => HomeScreen(
                                widget.webUrl,
                              ));
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget get _bottomNavigationBar {
    return Container(
      height: 75,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
      ),
      child: GlassBoxCurve(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 10,
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2.0),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_navigationTabs.length + 1, (i) {
                if (i == _navigationTabs.length) {
                  return _buildNavItem(
                      _navigationTabs.length,
                      CustomStrings.settings,
                      Theme.of(navigatorKey.currentContext!)
                          .colorScheme
                          .settingsIcon);
                }
                return _buildNavItem(
                    i, _navigationTabs[i]['label'], _navigationTabs[i]['icon']);
              })),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String title, String icon) {
    return InkWell(
      onTap: () {
        onButtonPressed(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10.0),
          Lottie.asset(icon,
              height: 30,
              repeat: true,
              // reverse: true,
              // animate: true,
              controller: _selectedIndex == index
                  ? onSelectedAnimation
                  : _previousIndex == index
                      ? onChangedAnimation
                      : idleAnimation),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text(title,
                textAlign: TextAlign.center,
                style: _selectedIndex == index
                    ? Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.normal,
                        )
                    : Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: 35,
                height: 3,
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Theme.of(context).indicatorColor
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0)),
                  boxShadow: _selectedIndex == index
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .indicatorColor
                                .withOpacity(0.5),
                            blurRadius: 50.0, // soften the shadow
                            spreadRadius: 20.0,
                            //extend the shadow
                          )
                        ]
                      : [],
                )),
          ),
        ],
      ),
    );
  }

  void onButtonPressed(int index) {
    if (!context
        .read<NavigationBarProvider>()
        .animationController
        .isAnimating) {
      context.read<NavigationBarProvider>().animationController.reverse();
    }
    // pageController.jumpToPage(index);
    onSelectedAnimation.reset();
    onSelectedAnimation.forward();

    onChangedAnimation.value = 1;
    onChangedAnimation.reverse();

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  Future<bool> _navigateBack(BuildContext context) async {
    if (Platform.isIOS && Navigator.of(context).userGestureInProgress) {
      return Future.value(true);
    }
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
    if (!context
        .read<NavigationBarProvider>()
        .animationController
        .isAnimating) {
      context.read<NavigationBarProvider>().animationController.reverse();
    }
    if (!isFirstRouteInCurrentTab) {
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Do you want to exit app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));

      return Future.value(true);
    }
  }
}
