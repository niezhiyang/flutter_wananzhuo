import 'package:flutter_wananzhuo/generated/json/base/json_convert_content.dart';

class WxOfficalEntity with JsonConvert<WxOfficalEntity> {
	List<WxOfficalData>? data;
	int? errorCode;
	String? errorMsg;
}

class WxOfficalData with JsonConvert<WxOfficalData> {
	List<dynamic>? children;
	int? courseId;
	int? id;
	String? name;
	int? order;
	int? parentChapterId;
	bool? userControlSetTop;
	int? visible;
}
