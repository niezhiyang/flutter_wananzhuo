import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';

class CustomInterceptors extends Interceptor {
  static const jsonCode = JsonCodec();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.d("请求是：${options.uri} ", tag: "http请求");
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger.d(
        "返回码是：${err.response?.statusCode}=> PATH: ${err.requestOptions.path}",
        tag: "http请求");
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.d("请求返回的请求是：${response.realUri}  , 返回码是：${response.statusCode}",
        tag: "http请求");
    Logger.json(response.toString(), tag: "http请求");

    try {
      Map<String, dynamic> decode = jsonCode.decode(response.toString());
      int errorCode = decode["errorCode"];
      if(errorCode == -1001){
        // 登录失效或者是去登录,做登录的逻辑，比如说跳转到登录页面
        Toast.show("请先登录");
      }else if(errorCode==0){
        // 请求数据成功
        handler.next(response);
      }else{
        var err = DioError(requestOptions: response.requestOptions, error: "errorCode 不是0");
        handler.reject(err, true);
      }

    } catch (e,stackTrace) {
      // 上面出错，继续下走
      handler.next(response);
    }

  }
}
