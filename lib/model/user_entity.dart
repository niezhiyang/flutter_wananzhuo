import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/generated/json/base/json_convert_content.dart';

class UserBase with JsonConvert<UserBase> {
	User? data;
	int? errorCode;
	String? errorMsg;
}

class User with JsonConvert<User> , ChangeNotifier{
	bool? admin;
	List<dynamic>? chapterTops;
	int? coinCount;
	List<int>? collectIds;
	String? email;
	String? icon;
	int? id;
	String? nickname;
	String? password;
	String? publicName;
	String? token;
	int? type;
	String? username;



  void changeUser(User user) {
		username = user.username;
		admin = user.admin;
		coinCount = user.coinCount;
		collectIds = user.collectIds;
		email = user.email;
		icon = user.icon;
		id = user.id;
		username = user.username;
		nickname = user.nickname;
		password = user.password;
		publicName = user.publicName;
		notifyListeners();
	}
}
