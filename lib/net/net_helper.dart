import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'interceptor/cookie_interceptor.dart';
import 'interceptor/cookie_mgr.dart';
import 'interceptor/log_interceptor.dart';

class NetHelper {
  // 因为在deug 状态 如果 超过这个时间 dio 会在日志打印错误，所以 开发的时候改小一点即可
  static const int CONNECT_TIMEOUT = 15000;
  static const int RECEIVE_TIMEOUT = 15000;
  static const String BASE_URL = "https://www.wanandroid.com";
  late Dio dio;

  static NetHelper netHelper = NetHelper._();

  NetHelper._() {
    dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CustomInterceptors());
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.baseUrl = BASE_URL;
    dio.options.connectTimeout = CONNECT_TIMEOUT;
    dio.options.receiveTimeout = RECEIVE_TIMEOUT;
  }

  static NetHelper getInstance() {
    return netHelper;
  }

  static Dio getDio() {
    return netHelper.dio;
  }
}



