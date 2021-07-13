import 'dart:convert';

import 'package:dio/src/response.dart';

import '../net_helper.dart';
import 'home_response_entity.dart';

class HomeRepository {
  // 返回的这个Future 可以不用写
  Future<HomeResponseEntity> getHome(int index) async {
    Response response = await NetHelper.getDio().get<String>(
      "/user_article/list/$index/json",
    );
    Map<String, dynamic> userMap = json.decode(response.data);
    HomeResponseEntity home = HomeResponseEntity().fromJson(userMap);
    // Logger.json(response.data);
    return home;
  }


}
