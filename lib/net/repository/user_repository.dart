import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';

import '../net_helper.dart';

class UserRepository {
  Future<User> login(String username, String password) async {
    var formData = FormData.fromMap({
      'username': username,
      'password': password,
    });
    var response = await NetHelper.getDio().post(
      "/user/login",
      data: formData,
    );
    Map<String, dynamic> userMap = json.decode(response.data);
    User user = User().fromJson(userMap);
    return user;
  }
}
