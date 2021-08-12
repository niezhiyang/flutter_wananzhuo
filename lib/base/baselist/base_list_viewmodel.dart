import 'dart:convert';

import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/base/base_change_notifier.dart';
import 'package:flutter_wananzhuo/base/baselist/base_list_model.dart';
import 'package:flutter_wananzhuo/net/net_helper.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';

abstract class BaseListViewModel<T, M extends BaseListMode<T>>
    extends BaseChangeNotifier {
  final EasyRefreshController controller = EasyRefreshController();
  LoadStatus viewState = LoadStatus.loading;

  /// 因为 这里的网络请求下一页 就是通过index 来决定的
  /// 是否有 下一页 是通过 BaseListMode的total 和 当前的个数做对比的
  var index = 0;
  List<T> itemList = []; //集合数组

  late String nextPageUrl; //下一页请求链接
  void retry() {
    viewState = LoadStatus.loading;
    notifyListeners();
    refresh();
  }

  String getUrl(int index);

  //请求返回的真实数据模型
  M getModel(Map<String, dynamic> json);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///下拉刷新 或者 是首次加载
  void refresh()  {
    index = 0;
    NetHelper.getDio()
        .get<String>(getUrl(index)
            // "/user_article/list/$index/json",
            )
        .then((response) {
      Map<String,dynamic> jsonRes = json.decode(response.toString());

      M model = getModel(jsonRes["data"]);
      itemList.clear();
      itemList = model.datas;
      controller.resetLoadState();
      controller.finishRefresh();
      if(itemList.isEmpty){
        viewState = LoadStatus.empty;
      }else{
        viewState = LoadStatus.content;
      }

    }).catchError((e) {
      controller.finishRefresh(success: false);
      viewState = LoadStatus.netError;
    }).whenComplete(() {
      notifyListeners();
    });


  }

  /// 加载更多
  Future<void> onLoad() async {
    NetHelper.getDio()
        .get<String>(getUrl(index)
            // "/user_article/list/$index/json",
            )
        .then((response) {
      var jsonRes = json.decode(response.toString());
      M model = getModel(jsonRes["data"]);
      itemList.addAll(model.datas);
      controller.finishLoad(
          success: true, noMore: model.total <= itemList.length);
      index++;
    }).catchError((e) {
      Logger.e(e);
      controller.finishLoad(success: false);
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
