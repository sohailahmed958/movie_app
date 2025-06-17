
import 'package:flutter/material.dart';

class ScreenUtils {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late EdgeInsets safeAreaPadding;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    safeAreaPadding = mediaQuery.padding;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeBlockHorizontal = (screenWidth - safeAreaPadding.left - safeAreaPadding.right) / 100;
    safeBlockVertical = (screenHeight - safeAreaPadding.top - safeAreaPadding.bottom) / 100;
  }

  static bool get isTablet => screenWidth > 600;
  static bool get isSmallPhone => screenWidth < 375;
  static bool get isMediumPhone => screenWidth >= 375 && screenWidth < 414;
  static bool get isLargePhone => screenWidth >= 414 && screenWidth <= 600;
}





/*
import 'package:flutter/material.dart';

class ScreenUtils {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late EdgeInsets safeAreaPadding;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    safeAreaPadding = mediaQuery.padding;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeBlockHorizontal = (screenWidth - safeAreaPadding.left - safeAreaPadding.right) / 100;
    safeBlockVertical = (screenHeight - safeAreaPadding.top - safeAreaPadding.bottom) / 100;
  }

  static bool get isTablet => screenWidth > 600;
  static bool get isSmallPhone => screenWidth < 375;
  static bool get isMediumPhone => screenWidth >= 375 && screenWidth < 414;
  static bool get isLargePhone => screenWidth >= 414 && screenWidth <= 600;
}
*/