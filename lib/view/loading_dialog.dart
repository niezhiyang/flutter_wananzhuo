import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wananzhuo/utils/screen_util.dart';

import '../wan_kit.dart';
/// 返回键失效，不知怎么办呢，可以定义一个base widget，在 dispose 的时候关闭这个弹窗
class LoadUtil {

  static bool _isShow = false;
  static OverlayEntry? overlayEntry;

  LoadUtil._();

  static void show() {
    OverlayState? overlayState = Wankit.navigatorKey.currentState?.overlay;
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      // 在这里拦截失败
      return WillPopScope(child:  Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color(0x20000000),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.black38,
            child: const SpinKitCircle(
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),onWillPop: _onPop);
    });
    if (!_isShow) {
      overlayState!.insert(overlayEntry!);
      _isShow = true;
    }
  }

  static void close() {
    if (_isShow) {
      overlayEntry?.remove();
      _isShow = false;
    }
  }
 static Future<bool> _onPop() async {
    Logger.e("---------$_isShow");
   return !_isShow;
  }
}
