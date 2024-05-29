import 'package:flutter/widgets.dart';

class SizeConfig {
  static double screenHeight = 0;
  static double screenWidth = 0;
  static double blockHorizontal = 0;
  static double blockVertical = 0;
  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;

  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 490) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    blockHorizontal = screenWidth / 100;
    blockVertical = screenHeight / 100;

    textMultiplier = blockVertical;
    imageSizeMultiplier = blockHorizontal;
    heightMultiplier = blockVertical;
    widthMultiplier = blockHorizontal;
   
  }
}
