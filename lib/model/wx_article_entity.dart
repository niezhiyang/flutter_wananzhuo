import 'package:flutter_wananzhuo/generated/json/base/json_convert_content.dart';

class WxArticleEntity with JsonConvert<WxArticleEntity> {
	List<dynamic>? children;
	double? courseId;
	double? id;
	String? name;
	double? order;
	double? parentChapterId;
	bool? userControlSetTop;
	double? visible;
}
