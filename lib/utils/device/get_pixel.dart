import 'package:flutter/material.dart';


import '../helpers/helper_functions.dart';

class FetchPixels {
  static double mockupWidth = 375;
  static double mockupHeight = 812;
  static double width = 0;
  static double height = 0;

  FetchPixels(BuildContext context,
      {double mockUpWidth1 = 375, double mockUpHeight1 = 812}) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    mockupHeight = mockUpHeight1;
    mockupWidth = mockUpWidth1;
  }

  static double getHeightPercentSize(double percent) {
    return (percent * height) / 100;
  }

  static double getWidthPercentSize(double percent) {
    return (percent * width) / 100;
  }

  static double getPixelWidth(double val) {
    return val / mockupWidth * width;
  }

  static double getPixelHeight(double val) {
    return val / mockupHeight * height;
  }

  static double getDialogCorner() {
    return FetchPixels.getPixelHeight(6);
  }

  static double getDefaultHorSpaceFigma(BuildContext context) {
    return FetchPixels.getPixelWidth(20);
  }

  static double getTextScale({bool horFactor=false}) {
    double textScaleFactor = (width > height) ? width / mockupWidth : height / mockupHeight;
    if (DeviceUtil.isTablet && !horFactor) {
      textScaleFactor = height / mockupHeight;
    }


    return textScaleFactor;
  }

  static double getScale() {
    double scale =
    (width > height) ? mockupWidth / width : mockupHeight / height;

    if (DeviceUtil.isTablet) {
      scale = height / mockupHeight;
    }

    return scale;
  }
}
