import 'package:flutter_wananzhuo/generated/json/base/json_convert_content.dart';

class User with JsonConvert<User> {
	UserData? data;
	int? errorCode;
	String? errorMsg;
}

class UserData with JsonConvert<UserData> {
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
}
