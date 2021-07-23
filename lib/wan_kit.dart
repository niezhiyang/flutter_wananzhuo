import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constans.dart';
import 'net/interceptor/cookie_interceptor.dart';

class Wankit {
  /// 是否登录
  static bool isLogin = false;
  static User? user;
  static late BuildContext context;

  static void init(BuildContext buildContext) {
    context = buildContext;
    // 初始化路径和cook
    CookieManager.initPath().then((cookieJar) {
      CookieManager.cookieJar = cookieJar;
    });
    // 初始化用户
    initUser();
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
      if (userStr!=null && userStr.isNotEmpty) {
        User user = User().fromJson(const JsonCodec().decode(userStr));
        context.read<User>().changeUser(user);
        isLogin = true;
      } else {
        isLogin = false;
      }
    }).catchError((e){
       Logger.e(e);
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
