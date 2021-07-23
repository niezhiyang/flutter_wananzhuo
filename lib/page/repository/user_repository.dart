import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/net/net_helper.dart';


class UserRepository {
  Future<String> login(String username, String password) async {
    var formData = FormData.fromMap({
      'username': username,
      'password': password,
    });
    var response = await NetHelper.getDio().post(
      "/user/login",
      data: formData,
    );
    return response.toString();
  }
}
