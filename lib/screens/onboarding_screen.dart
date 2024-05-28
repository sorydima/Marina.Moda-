import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marinamoda/helpers/icons.dart';
import 'package:marinamoda/helpers/Colors.dart';
import 'package:marinamoda/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:marinamoda/helpers/Constant.dart';
import 'package:marinamoda/helpers/Strings.dart';
import 'package:marinamoda/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedIndex = 0;
  late int totalPages;
  TextStyle headline =
      TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18);
  TextStyle desc = TextStyle(color: primaryColor, fontSize: 16);
  List slidersList(BuildContext context) => [
      ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    PageController pageController = PageController();
    totalPages = slidersList(context).length;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: onboardingBGColor,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.7,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: PageView.builder(
                    controller: pageController,
                    itemCount: totalPages,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          // decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //         fit: BoxFit.cover,
                          //         image: AssetImage(imagePath + images[index]))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Spacer(
                                flex: 2,
                              ),
                              Text(
                                slidersList(context)[index]['title'],
                                style: headline,
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: SvgPicture.asset(
                                  slidersList(context)[index]['image'],
                                  // width: double.maxFinite,
                                  // height: size.height * 0.2,
                                ),
                              ),
                              const Spacer(flex: 2),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60),
                                  child: Text(
                                    slidersList(context)[index]['desc'],
                                    style: desc,
                                    textAlign: TextAlign.center,
                                  )),
                              const Spacer(
                                flex: 1,
                              ),
                            ],
                          ));
                    }),
              ),
            ),
            Pageindicator(
              index: _selectedIndex,
              length: slidersList(context).length,
            ),
            const Spacer(
              flex: 1,
            ),
            GestureDetector(
              onTap: () async {
                if (_selectedIndex < totalPages - 1) {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                } else if (_selectedIndex == totalPages - 1) {
                  jumpToMainPage();
                }
              },
              child: Container(
                width: _selectedIndex == totalPages - 1 ? 213 : 65,
                height: _selectedIndex == totalPages - 1 ? 50 : 65,
                child: _selectedIndex == totalPages - 1
                    ? Text(
                        CustomStrings.done,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: whiteColor),
                      )
                    : const Icon(
                        Icons.arrow_forward,
                        color: whiteColor,
                      ),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          spreadRadius: 0)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          onboardingButtonColor1,
                          onboardingButtonColor2
                        ])),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Row(
              children: <Widget>[
                if (_selectedIndex > 0)
                  TextButton(
                      onPressed: () => pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: Text(
                        'Prev',
                        style: headline,
                      )),
                const Spacer(),
                TextButton(
                    onPressed: () => jumpToMainPage(),
                    child: Text(
                      'Skip',
                      style: headline,
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  jumpToMainPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isFirstTimeUser', false);
    navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (_) => const MyHomePage(
              webUrl: webinitialUrl,
            
            )));
  }
}

class Pageindicator extends StatelessWidget {
  final int length;
  final int index;
  const Pageindicator({Key? key, required this.index, required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (indexDots) {
          return // Rectangle 20
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: index == indexDots ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: index == indexDots
                          ? onboardingButtonColor1
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      border:
                          Border.all(color: onboardingButtonColor1, width: 1)));
        }));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
