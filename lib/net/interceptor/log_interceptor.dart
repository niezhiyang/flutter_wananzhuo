import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';

class CustomInterceptors extends Interceptor {
  static const jsonCode = JsonCodec();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Logger.d("请求是：${options.uri} ", tag: "http请求");
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Logger.d(
    //     "返回码是：${err.response?.statusCode}=> PATH: ${err.requestOptions.path}",
    //     tag: "http请求");
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Logger.d("请求返回的请求是：${response.realUri}  , 返回码是：${response.statusCode}",
    //     tag: "http请求");
    // Logger.json(response.toString(), tag: "http请求");
    super.onResponse(response, handler);
  }
}
