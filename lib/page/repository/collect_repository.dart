import 'dart:convert';

import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/net/net_helper.dart';

class CollectRepository{
  Future<HomeResponseData?> getCollectArtical(int index) async {
    var response = await NetHelper.getDio().get(
      "/lg/collect/list/$index/json",
    );
    Map<String, dynamic> article = json.decode(response.toString());

    HomeResponseEntity wxArticle = HomeResponseEntity().fromJson(article);
    return wxArticle.data;
  }
}