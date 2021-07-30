import 'package:flutter/widgets.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/base/base_viewmodel.dart';
import 'package:flutter_wananzhuo/model/banner_entity.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';

import 'first_mode.dart';

class FirstViewModel extends BaseViewModel<FirstModle> {
  final HomeRepository _repository = HomeRepository();

  var index = 0;

  final EasyRefreshController easyRefreshController;
  final ScrollController scrollController;

  FirstViewModel(
      {required this.easyRefreshController, required this.scrollController})
      : super(FirstModle());

  /// 刷新或者是首次加载数据
  Future<void> getNetData() async {
    value.loadStatus = LoadStatus.loading;

    Future<HomeResponseEntity> home = _repository.getHome(index);
    Future<BannerEntity> banner = _repository.geyBanner();

    Future.wait([home, banner]).then((futureList) {
      BannerEntity banner = futureList[1] as BannerEntity;
      value.loadStatus = LoadStatus.content;
      value.homeResponse = futureList[0] as HomeResponseEntity;

      List<HomeResponseDataDatas>? homeDataResponse =
          value.homeResponse?.data?.datas;

      if (homeDataResponse != null && homeDataResponse.isNotEmpty) {
        value.articleList.clear();
        value.articleList.addAll(homeDataResponse);
      }
      value.banners.clear();
      value.bannerUrl.clear();
      value.banners.addAll(banner.data!);
      for (BannerData data in value.banners) {
        value.bannerUrl.add(data.imagePath!);
      }

      index++;
      easyRefreshController.resetLoadState();
      easyRefreshController.finishRefresh();
    }).onError((error, stackTrace) {
      Logger.e(error);
      value.loadStatus = LoadStatus.netError;
      easyRefreshController.finishRefresh(success: false);
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future<void> onLoad() async {
    Future<HomeResponseEntity> home = _repository.getHome(index);

    home.then((homeRes) {
      value.articleList.addAll(homeRes.data!.datas!);
      easyRefreshController.finishLoad(
          success: true,
          noMore: homeRes.data!.total! <= value.articleList.length);
      index++;
    }).onError((error, stackTrace) {
      Logger.e(error);
      easyRefreshController.finishLoad(success: false);
    }).whenComplete(() {
      notifyListeners();
    });
  }

  /// 收藏
  Future<void> saveArticle(int? articId, int postioon) async {
    _repository.saveArticle(articId).then((res) {
      Toast.show("收藏成功");
      value.articleList[postioon].collect = true;
    }).catchError((e) {
      Logger.e(e);
    }).whenComplete(() {
      notifyListeners();
    });
    ;
  }

  /// 取消收藏
  Future<void> cancelArticle(int? articId, int postioon) async {
    _repository.cancelArticle(articId).then((_) {
      Toast.show("取消成功");
      value.articleList[postioon].collect = false;
    }).catchError((e) {
      Logger.e(e);
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
