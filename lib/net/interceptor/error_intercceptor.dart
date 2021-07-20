import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';

class ErrorInterceptor extends Interceptor{
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      Map<String, dynamic> decode = json.decode(response.toString());
      int errorCode = decode["errorCode"];
      if(errorCode == -1001){
        // 登录失效或者是去登录,做登录的逻辑，比如说跳转到登录页面
        Toast.show("请先登录");
        var err = DioError(requestOptions: response.requestOptions, error: "errorCode 不是0");
        handler.reject(err, true);
      }else if(errorCode==0){
        // 请求数据成功
        handler.next(response);
      }else{
        Toast.show(decode["errorMsg"]);
        var err = DioError(requestOptions: response.requestOptions, error: "errorCode 不是0");
        handler.reject(err, true);
      }

    } catch (e,stackTrace) {
      // 上面出错，继续下走
      handler.next(response);
    }

  }
}