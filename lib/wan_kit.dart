import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/setting.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constans.dart';
import 'net/interceptor/cookie_interceptor.dart';

class Wankit {
  /// 是否登录
  static bool isLogin = false;
  static User? user;

  /// 不能用于 showdialog push overlayState，暂时只是用来读取provider
  /// 可以利用 navigatorKey.currentState.push
  /// overlayState 可以利用 navigatorKey.currentState.overlayState 拿到
  static late BuildContext context;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 按道理来说初始化完成所有的东西才能进入主页面
  static void init() {
    context = navigatorKey.currentState!.context;
    // 初始化路径和cook
    CookieManager.initPath().then((cookieJar) {
      CookieManager.cookieJar = cookieJar;
    });
    // 初始化用户
    initUser();
    // var state = navigatorKey.currentState;
    // state.pushNamed(routeName)
    // Logger.e(state);
  }

  /// 存用户
  static void saveUser(User userTemp) {
    user = userTemp;
    SharedPreferences.getInstance().then((sb) {
      sb.setString(Constans.login, json.encode(user));
    });
    Wankit.isLogin = true;
  }

  /// 初始化用户
  static void initUser() {
    SharedPreferences.getInstance().then((sb) {
      return sb.getString(Constans.login);
    }).then((userStr) {
      if (userStr != null && userStr.isNotEmpty) {
        User user = User().fromJson(const JsonCodec().decode(userStr));
        context.read<User>().changeUser(user);
        isLogin = true;
      } else {
        isLogin = false;
      }
    }).catchError((e) {
      Logger.e(e);
    });

    SharedPreferences.getInstance().then((value) {
      int? index = value.getInt("color_index");
      context.read<ThemeState>().changeThemeData(index ?? 0);
    });
  }

  /// 退出登录操作
  static void loginOut() async {
    isLogin = false;
    SharedPreferences sb = await SharedPreferences.getInstance();
    sb.setString(Constans.login, "");
    CookieManager.cookieJar!.deleteAll();
    User user = User();
    context.read<User>().changeUser(user);
  }
}
