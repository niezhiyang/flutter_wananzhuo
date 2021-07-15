import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

class NetHelper {
  // 因为在deug 状态 如果 超过这个时间 dio 会在日志打印错误，所以 开发的时候改小一点即可
  static const int CONNECT_TIMEOUT = 15000;
  static const int RECEIVE_TIMEOUT = 15000;
  static const String BASE_URL = "https://www.wanandroid.com";
  late Dio dio;

  static NetHelper netHelper = NetHelper._();

  NetHelper._() {
    dio = Dio();
    dio.interceptors.add(CustomInterceptors());
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

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.d("请求是：${options.uri} ",tag: "http请求");
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger.d("返回码是：${err.response?.statusCode}=> PATH: ${err.requestOptions.path}",tag: "http请求");
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.d("请求返回的请求是：${response.realUri}  , 返回码是：${response.statusCode}",tag: "http请求");
    Logger.json(response.data,tag: "http请求");
    super.onResponse(response, handler);
  }
}
