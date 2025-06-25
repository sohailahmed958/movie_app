import 'package:flutter/material.dart';

extension StylesExtension on BuildContext {
  TextStyle get label8500 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 8,
    fontWeight: FontWeight.w500,
  );
  TextStyle get label10400 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
  TextStyle get label10700 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
  TextStyle get label14400 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  TextStyle get label14500 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  TextStyle get label16400 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  TextStyle get label16500 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  TextStyle get label16600 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  TextStyle get label18500 => Theme.of(this).textTheme.bodyMedium!.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  TextStyle get label26700 => Theme.of(this).textTheme.titleLarge!.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );
  TextStyle get label12500 => Theme.of(this).textTheme.titleLarge!.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  TextStyle get label12400 => Theme.of(this).textTheme.titleLarge!.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}

extension ScreenSizeExtension on BuildContext {
  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Get percentage of screen width
  double widthPct(double percent) => screenWidth * percent;

  // Get percentage of screen height
  double heightPct(double percent) => screenHeight * percent;
}