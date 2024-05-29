import 'dart:developer';
import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marinamoda/ads/banner_ad.dart';
import 'package:marinamoda/utils/colors.dart';
import 'package:marinamoda/utils/constants.dart';
import 'package:marinamoda/utils/responsible_file.dart';
import 'package:marinamoda/widget/checkinternet.dart';
import 'package:marinamoda/widget/custom_text.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool? isIntro;
  int _currentIndex = 0;

  String _connectionStatus = 'ConnectivityResult.none';

  void _onIntroEnd(context) {
    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
          debugPrint(_connectionStatus);
        }));
    saveShareInfo("intro", true);
    Navigator.pushNamed(context, "/homePage", arguments: _connectionStatus);
  }

  saveShareInfo(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  PageController pageViewController = PageController();

  int currentPage = 0;
  int totalPage = 3;

  List introImage = [
    assetsPath.toString() + firstIntroImage,
    assetsPath.toString() + secondIntroImage,
    assetsPath.toString() + thirdIntroImage
  ];

  List introTitle = [firstIntroTitle, secondIntroTitle, thirdIntroTitle];

  List introDescription = [
    firstIntroDescription,
    secondIntroDescription,
    thirdIntroDescription
  ];

  @override
  void initState() {
    Platform.isAndroid
        ? bannerAdIs
            ? bannerAd.load()
            : debugPrint("Banner Ad Android not loaded")
        : iosBannerAdIs
            ? bannerAd.load()
            : debugPrint("Banner Ad iOS not loaded");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: SizeConfig.heightMultiplier * 50,
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  _currentIndex = index;
                });
              },
              itemCount: introImage.length,
              scrollDirection: Axis.horizontal,
              controller: pageViewController,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: transparant,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        introImage[index],
                        height: SizeConfig.heightMultiplier * 40,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            position: _currentIndex.toDouble(),
            decorator: DotsDecorator(
              color: transparant,
              spacing: EdgeInsets.all(SizeConfig.widthMultiplier),
              size: Size.square(SizeConfig.heightMultiplier),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.heightMultiplier),
                  side: const BorderSide(
                    color: colorAccent,
                  )),
              activeColor: colorAccent,
              activeSize: Size(
                  SizeConfig.heightMultiplier, SizeConfig.heightMultiplier),
              activeShape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.heightMultiplier)),
            ),
          ),
          SizedBox(
              height: SizeConfig.heightMultiplier * 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: CustomText(
                      textAlign: TextAlign.center,
                      title: introTitle[_currentIndex],
                      size: SizeConfig.heightMultiplier * 3,
                      colors: colorAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: SizeConfig.heightMultiplier * 30,
                    child: CustomText(
                      title: introDescription[_currentIndex],
                      size: SizeConfig.heightMultiplier * 1.8,
                      colors: white,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 5, top: 15),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      child: const Text(
                        'Done',
                        style: TextStyle(color: white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                          minimumSize: MaterialStateProperty.all(Size(
                              (MediaQuery.of(context).size.width - 40), 60)),
                          backgroundColor:
                              MaterialStateProperty.all(colorAccent)),
                      onPressed: () {
                        log("===>${currentPage}");
                        log("===>$totalPage");
                        if (currentPage != (totalPage - 1)) {
                          pageViewController.animateToPage(
                            currentPage + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _onIntroEnd(context);
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: white, fontSize: 16),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        minimumSize: MaterialStateProperty.all(
                            Size((MediaQuery.of(context).size.width - 40), 60)),
                      ),
                      onPressed: () {
                        _onIntroEnd(context);
                      },
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
