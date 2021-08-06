import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

/// 屏幕宽像素 分辨率
double screenWidthPx = window.physicalSize.width;

/// 屏幕高像素 分辨率
double screenHeightPx = window.physicalSize.height;

/// 比如我们写一个 SizeBox(width:screenWidth,height:screenHeight) 那就是铺满全屏
double screenWidth = screenWidthPx / window.devicePixelRatio;

/// MediaQuery.of(context).size.width 屏幕宽度
double screenHeight = screenHeightPx / window.devicePixelRatio;

/// 状态栏高度
double  statusHeight = window.padding.top / window.devicePixelRatio;



class SizeUtil {
  static double density = 0;
  static double widthRatio = 0;
  static double heightRatio = 0;

  static void initialize({double width = 360, double height = 780}) {
    // 2.获取   android中 dp 转 px 就是通过 dp*density做的
    density = window.devicePixelRatio;
    // 5.计算 比例
    widthRatio = screenWidth / width;
    heightRatio = screenHeight / height;

    Logger.e(
        "physicalWidth $screenWidthPx ---- physicalHeight $screenHeightPx");
    Logger.e(
        "density $density  ------- screenWidth $screenWidth ---- screenHeight $screenHeight");
    Logger.e(
        "statusHeight $statusHeight ---- bottomBar ${window.padding.bottom / density}");
    Logger.e("appbarHeight $kToolbarHeight");
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
