import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Don't use this class in Browser environment
class CookieManager extends Interceptor {
  /// Cookie manager for http requests。Learn more details about
  /// CookieJar please refer to [cookie_jar](https://github.com/flutterchina/cookie_jar)
  static CookieJar? cookieJar;


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    cookieJar?.loadForRequest(options.uri).then((cookies) {
      var cookie = getCookies(cookies);
      if (cookie.isNotEmpty) {
        options.headers[HttpHeaders.cookieHeader] = cookie;
      }
      handler.next(options);
    }).catchError((e, stackTrace) {
      var err = DioError(requestOptions: options, error: e);
      err.stackTrace = stackTrace;
      handler.reject(err, true);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _saveCookies(response)
        .then((_) => handler.next(response))
        .catchError((e, stackTrace) {
      var err = DioError(requestOptions: response.requestOptions, error: e);
      err.stackTrace = stackTrace;
      handler.reject(err, true);
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _saveCookies(err.response!)
          .then((_) => handler.next(err))
          .catchError((e, stackTrace) {
        var _err = DioError(
          requestOptions: err.response!.requestOptions,
          error: e,
        );
        _err.stackTrace = stackTrace;
        handler.next(_err);
      });
    } else {
      handler.next(err);
    }
  }

  Future<void> _saveCookies(Response response) async {
    var cookies = response.headers[HttpHeaders.setCookieHeader];

    if (cookies != null) {
      await cookieJar?.saveFromResponse(
        response.requestOptions.uri,
        cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
      );
    }
  }

  static String getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }

  static Future<PersistCookieJar> initPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var cookieJar = PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath + "/.cookies/"));

    return cookieJar;
  }


}

//JSESSIONID=B411CB9E43DCAA51952E71210B21D8BC; loginUserName=nzyandroid; token_pass=04ecc97792fce25e97b33ab44419cd3a; loginUserName_wanandroid_com=nzyandroid; token_pass_wanandroid_com=04ecc97792fce25e97b33ab44419cd3a
//loginUserName=nzyandroid; Expires=Wed, 18-Aug-2021 03:34:50 GMT; Path=/; token_pass=04ecc97792fce25e97b33ab44419cd3a; Expires=Wed, 18-Aug-2021 03:34:50 GMT; Path=/; loginUserName_wanandroid_com=nzyandroid; Domain=wanandroid.com; Expires=Wed, 18-Aug-2021 03:34:50 GMT; Path=/; token_pass_wanandroid_com=04ecc97792fce25e97b33ab44419cd3a; Domain=wanandroid.com; Expires=Wed, 18-Aug-2021 03:34:50 GMT; Path=/
//JSESSIONID=9E37A195B71B82DD9CCED0CB7BFA0317; loginUserName=nzyandroid; token_pass=04ecc97792fce25e97b33ab44419cd3a; loginUserName_wanandroid_com=nzyandroid; token_pass_wanandroid_com=04ecc97792fce25e97b33ab44419cd3a
