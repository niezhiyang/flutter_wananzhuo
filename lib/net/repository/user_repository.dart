import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

import '../net_helper.dart';

class UserRepository {
  Future<void> login() async {
    var formData = FormData.fromMap({
      'username': 'nzyandroid',
      'password': "nzyandroid",
    });
    var response = await NetHelper.getDio().post(
      "/user/login",
      data: formData,
    );


  }
}
