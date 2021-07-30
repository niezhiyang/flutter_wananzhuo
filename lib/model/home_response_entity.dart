
import 'package:flutter_wananzhuo/base/base_mode.dart';
import 'package:flutter_wananzhuo/json/base/json_convert_content.dart';

class HomeResponseEntity extends BaseModle with JsonConvert<HomeResponseEntity> {
	HomeResponseData? data;
	int? errorCode;
	String? errorMsg;
}

class HomeResponseData with JsonConvert<HomeResponseData> {
	int? curPage;
	List<HomeResponseDataDatas>? datas;
	int? offset;
	bool? over;
	int? pageCount;
	int? size;
	int? total;
}

class HomeResponseDataDatas with JsonConvert<HomeResponseDataDatas> {
	String? apkLink;
	int? audit;
	String? author;
	bool? canEdit;
	int? chapterId;
	String? chapterName;
	bool? collect;
	int? courseId;
	String? desc;
	String? descMd;
	String? envelopePic;
	bool? fresh;
	String? host;
	int? id;
	String? link;
	String? niceDate;
	String? niceShareDate;
	String? origin;
	String? prefix;
	String? projectLink;
	int? publishTime;
	int? realSuperChapterId;
	int? selfVisible;
	int? shareDate;
	String? shareUser;
	int? superChapterId;
	String? superChapterName;
	List<dynamic>? tags;
	String? title;
	int? type;
	int? userId;
	int? visible;
	int? zan;
}
