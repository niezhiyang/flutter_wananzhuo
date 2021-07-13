import 'package:flutter_easylogger/flutter_logger.dart';

import '../net_helper.dart';

class UserRepository {
  Future<void> login() async {
    var response = await NetHelper.getDio().post(
      "/user/login",
      data: {'username': "nzyandroid", 'password': 'nzyandroid'},
    );

    Logger.json(response.toString());
  }
}
