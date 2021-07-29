import 'package:flutter_wananzhuo/base/base_mode.dart';
import 'package:flutter_wananzhuo/model/banner_entity.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';

class FirstMode extends BaseMode {
  HomeResponseEntity? homeResponse = HomeResponseEntity();
  List<BannerData> banners = [];
  List<String> bannerUrl = [];
  List<HomeResponseDataDatas> articleList = [];
}
