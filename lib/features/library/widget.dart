import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade101/features/library/models/book_model.dart';

import '../../utils/device/get_pixel.dart';




class Constant {
  static String assetImagePath = "assets/images/";
  static String assetImagePathNight = "assets/imagesNight/";
  static bool isDriverApp = false;
  static const String fontsFamily = "SFPRODISPLAY";
  static const String fontsPlayFamily = "Play";
  static const String fromLogin = "getFromLoginClick";
  static const String homePos = "getTabPos";
  static const String nameSend = "name";
  static const String imageSend = "image";
  static const String bgColor = "bgColor";
  static const String heroKey = "sendHeroKey";
  static const String sendVal = "sendVal";
  static const int stepStatusNone = 0;
  static const int stepStatusActive = 1;
  static const int stepStatusDone = 2;
  static const int stepStatusWrong = 3;

  static double getPercentSize(double total, double percent) {
    return (percent * total) / 100;
  }
}

