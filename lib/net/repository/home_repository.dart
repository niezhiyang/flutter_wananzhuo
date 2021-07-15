import 'dart:convert';

import 'package:dio/src/response.dart';
import 'package:flutter_wananzhuo/model/banner_entity.dart';

import '../net_helper.dart';
import '../../model/home_response_entity.dart';

class HomeRepository {
  /// 首页的文章
  Future<HomeResponseEntity> getHome(int index) async {
    Response response = await NetHelper.getDio().get<String>(
      "/user_article/list/$index/json",
    );
    Map<String, dynamic> userMap = json.decode(response.data);
    HomeResponseEntity home = HomeResponseEntity().fromJson(userMap);
    return home;
  }

  /// banner
  Future<BannerEntity> geyBanner() async {
    Response response = await NetHelper.getDio().get<String>(
      "/banner/json",
    );
    Map<String, dynamic> userMap = json.decode(response.data);
    BannerEntity banner = BannerEntity().fromJson(userMap);
    return banner;
  }



  /// 收藏
  Future<BannerEntity> saveArticle(int? articId) async {
    Response response = await NetHelper.getDio().post<String>(
      "/lg/collect/$articId/json",
    );
    Map<String, dynamic> userMap = json.decode(response.data);
    BannerEntity banner = BannerEntity().fromJson(userMap);
    return banner;
  }

  /// 取消收藏
  Future<BannerEntity> cancelArticle(int? articId) async {
    Response response = await NetHelper.getDio().post<String>(
      "/lg/collect/$articId/json",
    );
    Map<String, dynamic> userMap = json.decode(response.data);
    BannerEntity banner = BannerEntity().fromJson(userMap);
    return banner;
  }
}
