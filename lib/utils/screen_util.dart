import 'dart:ui';

import 'package:flutter_autosize_screen/auto_size_util.dart';








class SizeUtil {
  static double density = 0;
  static double widthRatio = 0;
  static double heightRatio = 0;

  static void initialize({double width = 360, double height = 780}) {
    // 2.获取   android中 dp 转 px 就是通过 dp*density做的
    density = window.devicePixelRatio;
    // 5.计算 比例
    widthRatio = AutoSizeUtil.getScreenSize().width / width;
    heightRatio = AutoSizeUtil.getScreenSize().height / height;

    // Logger.e(
    //     "physicalWidth $screenWidthPx ---- physicalHeight $screenHeightPx");
    // Logger.e(
    //     "density $density  ------- screenWidth $screenWidth ---- screenHeight $screenHeight");
    // Logger.e(
    //     "statusHeight $statusHeight ---- bottomBar ${window.padding.bottom / density}");
    // Logger.e("appbarHeight $kToolbarHeight");
  }

  static double setPx(double size) {
    return density * size;
  }

  static double setW(double size) {
    return widthRatio * size;
  }

  static double setH(double size) {
    return heightRatio * size;
  }
}
