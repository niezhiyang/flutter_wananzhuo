import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/model/wx_article_entity.dart';
import 'package:flutter_wananzhuo/model/wx_offical_entity.dart';
import 'package:flutter_wananzhuo/net/net_helper.dart';

class Wechatepository {
  Future<List<WxOfficalData>?> getWxtOfficial() async {
    var response = await NetHelper.getDio().get(
      "/wxarticle/chapters/json",
    );
    Map<String, dynamic> article = json.decode(response.toString());

    WxOfficalEntity wxArticle = WxOfficalEntity().fromJson(article);
    return wxArticle.data;
  }

  Future<HomeResponseData?> getAritcForWxOffical(int id,int index) async {
    var response = await NetHelper.getDio().get(
      "/wxarticle/list/$id/$index/json?k=Java",
    );
    Map<String, dynamic> article = json.decode(response.toString());

    HomeResponseEntity wxArticle = HomeResponseEntity().fromJson(article);
    return wxArticle.data;
  }
}
