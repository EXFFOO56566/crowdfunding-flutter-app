import 'dart:io';

import 'package:flutter/material.dart';

late bool isIos;

late double screenWidth;
late double screenHeight;

getScreenSize(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;
}

screenSizeAndPlatform(BuildContext context) {
  getScreenSize(context);
  checkPlatform();
}
//responsive screen codes ========>

var fourinchScreenHeight = 610;
var fourinchScreenWidth = 385;

checkPlatform() {
  if (Platform.isAndroid) {
    isIos = false;
  } else if (Platform.isIOS) {
    isIos = true;
  }
}
