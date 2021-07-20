import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'interceptor/cookie_interceptor.dart';
import 'interceptor/error_intercceptor.dart';
import 'interceptor/log_interceptor.dart';

class NetHelper {
  // 因为在deug 状态 如果 超过这个时间 dio 会在日志打印错误，所以 开发的时候改小一点即可
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const String baseUrl = "https://www.wanandroid.com";
  late Dio dio;

  static NetHelper netHelper = NetHelper._();

  NetHelper._() {
    dio = Dio();
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(CookieManager());
    dio.interceptors.add(CustomInterceptors());

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
  }

  static NetHelper getInstance() {
    return netHelper;
  }

  static Dio getDio() {
    return netHelper.dio;
  }
}
