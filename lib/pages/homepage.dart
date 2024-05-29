import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:marinamoda/ads/banner_ad.dart';
import 'package:marinamoda/model/menu.dart';
import 'package:marinamoda/provider/homepageprovider.dart';
import 'package:marinamoda/provider/webview.dart';
import 'package:marinamoda/utils/adhelper.dart';
import 'package:marinamoda/utils/colors.dart';
import 'package:marinamoda/utils/constants.dart';
import 'package:marinamoda/utils/global_fuction.dart';
import 'package:marinamoda/utils/responsible_file.dart';
import 'package:marinamoda/utils/sharedpref.dart';
import 'package:marinamoda/widget/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  SharedPref sharedPref = SharedPref();

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          useOnDownloadStart: true,
          javaScriptEnabled: true,
          cacheEnabled: true,
          userAgent:
              "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36",
          verticalScrollBarEnabled: false,
          horizontalScrollBarEnabled: false,
          transparentBackground: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        thirdPartyCookiesEnabled: true,
        allowFileAccess: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  List<Menu> menulist = [
    if (firstMenuOpt) Menu(firstMenu, firsticon, firstMenuOpt, firstURL),
    if (secondMenuOpt) Menu(secondMenu, secondicon, secondMenuOpt, secondURL),
    if (thirdMenuOpt) Menu(thirdMenu, thirdicon, thirdMenuOpt, thirdURL),
    if (fourthMenuOpt) Menu(fourthMenu, fourthicon, fourthMenuOpt, forthURL),
  ];

  List<Menu> fmenulist = [
    if (ffirstMenuOpt) Menu(ffirstMenu, ffirsticon, ffirstMenuOpt, ffirstURL),
    if (fsecondMenuOpt)
      Menu(fsecondMenu, fsecondicon, fsecondMenuOpt, fsecondURL),
    if (fthirdMenuOpt) Menu(fthirdMenu, fthirdicon, fthirdMenuOpt, fthirdURL),
    if (ffourthMenuOpt)
      Menu(ffourthMenu, ffourthicon, ffourthMenuOpt, fforthURL),
  ];

  int checkStatus = 0;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: colorPrimary,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    debugPrint(bottomMenuHideShow.toString());
    debugPrint(floatingMenuHideShow.toString());

    AdHelper.createInterstitialAd();

    AdHelper.createRewardedAd();
  }

  Widget _getFloatingActionButton(WebViewProvider object) {
    return Consumer<HomePageProvider>(
        builder: (context, objectMenuProvider, widget) {
      return SpeedDialMenuButton(
        mainFABPosX: SizeConfig.widthMultiplier * 5,
        mainFABPosY: SizeConfig.heightMultiplier * 20,
        isShowSpeedDial: objectMenuProvider.floatingValueCurrent,
        updateSpeedDialStatus: (isShow) {
          objectMenuProvider.floatingValueCurrent = isShow;
        },
        isMainFABMini: false,
        isEnableAnimation: false,
        mainMenuFloatingActionButton: MainMenuFloatingActionButton(
            mini: false,
            child: SvgPicture.asset(
              assetsPath + floatingMenuIcon,
              height: SizeConfig.heightMultiplier * 3,
              color: colorAccent,
            ),
            onPressed: () {},
            elevation: 0,
            backgroundColor: colorPrimary,
            closeMenuChild: SvgPicture.asset(
              assetsPath + floatingMenuIcon,
              height: SizeConfig.heightMultiplier * 3,
              color: colorAccent,
            ),
            closeMenuBackgroundColor: colorPrimary),
        floatingActionButtonWidgetChildren: <FloatingActionButton>[
          for (int i = 0; i < fmenulist.length; i++) ...[
            FloatingActionButton(
              heroTag: i,
              mini: true,
              backgroundColor: colorPrimary,
              child: SizedBox(
                height: SizeConfig.heightMultiplier * 3,
                child: SvgPicture.asset(
                  assetsPath + fmenulist[i].icon,
                  color: colorAccent,
                ),
              ),
              onPressed: () async {
                checkInternetConnection().then((value) async {
                  return {
                    object.changeUrl(oldUrl: fmenulist[i].url),
                    activeConnection
                        ? await webViewController!.loadUrl(
                            urlRequest:
                                URLRequest(url: Uri.parse(object.currentUrl)),
                          )
                        : null,
                    Future.delayed(const Duration(seconds: 5), () {
                      debugPrint("after 5 sec");
                      setState(() {});
                    })
                  };
                });
                objectMenuProvider.floatingOnOff(oldFloatingValue: false);
              },
            ),
          ],
        ],
        isSpeedDialFABsMini: false,
        paddingBtwSpeedDialButton: SizeConfig.widthMultiplier * 1.6,
      );
    });
  }

  _onWillPop(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: CustomText(
                  title: "Do you want to exit",
                  size: SizeConfig.heightMultiplier * 1.5,
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: CustomText(
                      title: "No",
                      size: SizeConfig.heightMultiplier * 1.5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: CustomText(
                      title: "Yes",
                      size: SizeConfig.heightMultiplier * 1.5,
                    ),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: colorPrimary,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));
    WebViewProvider webViewProvider = Provider.of(context, listen: false);

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Scaffold(
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: floatingMenuHideShow == true
                ? _getFloatingActionButton(webViewProvider)
                : null,
            appBar: appBarHideShow
                ? AppBar(
                    backgroundColor: appBarBackgroundColor,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    title: CustomText(
                      title: appName,
                      size: SizeConfig.heightMultiplier * 2,
                      fontWeight: FontWeight.w500,
                      colors: colorAccent,
                    ),
                  )
                : null,
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Consumer<WebViewProvider>(
                          builder: (context, object, widget) {
                        return Consumer<HomePageProvider>(
                            builder: (context, objectProgress, widget) {
                          return InAppWebView(
                            key: webViewKey,
                            initialUrlRequest:
                                URLRequest(url: Uri.parse(object.currentUrl)),
                            initialOptions: options,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (controller) {
                              print("im in on Web View Created");
                              webViewController = controller;
                            },
                            androidOnGeolocationPermissionsShowPrompt:
                                (InAppWebViewController controller,
                                    String origin) async {
                              return GeolocationPermissionShowPromptResponse(
                                  origin: origin, allow: true, retain: true);
                            },
                            onLoadStart: (controller, url) {
                              checkInternetConnection().then((value) {
                                return null;
                              });
                              setState(() {});
                            },
                            androidOnPermissionRequest:
                                (controller, origin, resources) async {
                              return PermissionRequestResponse(
                                  resources: resources,
                                  action:
                                      PermissionRequestResponseAction.GRANT);
                            },
                            shouldOverrideUrlLoading:
                                (controller, navigationAction) async {
                              var uri = navigationAction.request.url!;

                              if (![
                                "http",
                                "https",
                                "file",
                                "chrome",
                                "data",
                                "javascript",
                                "about"
                              ].contains(uri.scheme)) {}

                              return NavigationActionPolicy.ALLOW;
                            },
                            onLoadStop: (controller, url) async {
                              pullToRefreshController.endRefreshing();
                            },
                            onDownloadStartRequest:
                                (controller, downloadStartRequest) async {
                              log('===>${downloadStartRequest.url}');
                              log('===>${controller.webStorage.localStorage.webStorageType}');

                              requestPermission().then((status) async {
                                if (status == true) {
                                  if (await canLaunch(
                                      downloadStartRequest.url.toString())) {
                                    // Launch the App
                                    await launch(
                                        downloadStartRequest.url.toString(),
                                        forceSafariVC: false,
                                        forceWebView: false);

                                    // and cancel the request
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Permision denied'),
                                  ));
                                }
                              });
                            },
                            onLoadError: (controller, url, code, message) {
                              pullToRefreshController.endRefreshing();
                            },
                            onUpdateVisitedHistory:
                                (controller, url, androidIsReload) {},
                            onConsoleMessage: (controller, consoleMessage) {},
                          );
                        });
                      }),
                      activeConnection == false
                          ? Center(
                              child: Container(
                                color: white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(assetsPath + "nointernet.png"),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 3,
                                    ),
                                    CustomText(
                                        title: "No internet connection",
                                        size: SizeConfig.heightMultiplier * 3,
                                        colors: colorPrimary,
                                        fontWeight: FontWeight.w700),
                                    CustomText(
                                      title:
                                          "Cheking  the network cables, modem and router",
                                      size: SizeConfig.heightMultiplier * 1.2,
                                      colors: noInternetDescriptionColor,
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _onWillPop(context);
                                        Future.delayed(Duration(seconds: 5),
                                            () {
                                          setState(() {
                                            activeConnection = true;
                                          });
                                        });
                                      },
                                      child: Container(
                                        width: SizeConfig.widthMultiplier * 40,
                                        height: SizeConfig.heightMultiplier * 5,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.heightMultiplier * 3),
                                          color: colorPrimary,
                                        ),
                                        child: Center(
                                            child: CustomText(
                                          title: "Retry",
                                          size:
                                              SizeConfig.heightMultiplier * 2.1,
                                          colors: white,
                                          fontWeight: FontWeight.w700,
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _bottomMenu(webViewProvider)),
      ),
    );
  }

  Widget _bottomMenu(WebViewProvider webViewProvider) {
    return Container(
      height: Platform.isAndroid
          ? bannerAdIs == true
              ? bottomMenuHideShow == true
                  ? 140
                  : 70
              : bottomMenuHideShow == true
                  ? 70
                  : 0
          : iosBannerAdIs == true
              ? bottomMenuHideShow == true
                  ? 150
                  : 70
              : 70,
      color: transparant,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                height: 60,
                child: AdWidget(
                    ad: AdHelper.createBannerAd()..load(), key: UniqueKey())),
            bottomMenuHideShow == true
                ? Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: const BoxDecoration(
                        color: bottomMenuBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    height: 60,
                    child: Consumer<WebViewProvider>(
                        builder: (context, object, widget) {
                      return Consumer<HomePageProvider>(
                          builder: (context, objectBottomMenu, widget) {
                        return SalomonBottomBar(
                          selectedColorOpacity: 1,
                          currentIndex: objectBottomMenu.currentIndex,
                          selectedItemColor: colorAccent,
                          onTap: (i) async {
                            if (objectBottomMenu.floatingValueCurrent == true) {
                              objectBottomMenu.floatingOnOff(
                                  oldFloatingValue: false);
                            }
                            if (i % 2 == 0) {
                              AdHelper.showInterstitialAd();
                            } else {
                              AdHelper.showRewardedAd();
                            }

                            objectBottomMenu.changeBottomMenu(oldIndex: i);
                            checkInternetConnection().then((value) async {
                              return {
                                webViewProvider.changeUrl(
                                    oldUrl: menulist[i].url),
                                activeConnection
                                    ? await webViewController!.loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(object.currentUrl)),
                                      )
                                    : null,
                              };
                            });
                          },
                          items: [
                            for (int i = 0; i < menulist.length; i++)
                              if (menulist[i].visible)
                                SalomonBottomBarItem(
                                    icon: SvgPicture.asset(
                                      "assets/icon/" +
                                          menulist[i].icon.toString(),
                                      color: objectBottomMenu.currentIndex == i
                                          ? colorAccent
                                          : colorAccent,
                                    ),
                                    title: CustomText(
                                      title: menulist[i].title,
                                      size: SizeConfig.heightMultiplier * 1.8,
                                      colors: colorAccent,
                                    ),
                                    selectedColor: colorPrimary,
                                    unselectedColor: colorPrimary),
                          ],
                        );
                      });
                    }),
                  )
                : const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Future<bool> requestPermission() async {
    final status = await Permission.storage.status;

    if (status == PermissionStatus.granted) {
      return true;
    } else if (status != PermissionStatus.granted) {
      //
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        // await openAppSettings();
        return false;
      }
    }
    return true;
  }
}
