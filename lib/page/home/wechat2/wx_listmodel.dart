import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/base/baselist/base_list_model.dart';
import 'package:flutter_wananzhuo/base/baselist/base_list_viewmodel.dart';
import 'package:flutter_wananzhuo/model/wx_off_mode.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';

class WxListViewModel extends BaseListViewModel<Datas, Data> {
  var wxOffcialId = 1;
  final _articalrepository = HomeRepository();

  @override
  String getUrl(int index) {
    var url = "/wxarticle/list/$wxOffcialId/$index/json?k=Java";
    return url;
  }

  @override
  Data getModel(Map<String, dynamic> json) {
    return Data.fromJson(json);
  }

  void cancelArticle(int? id, int index) {
    _articalrepository.cancelArticle(id).then((res) {
      itemList[index].collect = false;
      Toast.show("取消成功");
    }).catchError((e) {
      Logger.e(e);
    }).whenComplete(() {
      notifyListeners();
    });
  }

  void saveArticle(int? id, int index) {
    _articalrepository.saveArticle(id).then((res) {
      itemList[index].collect = true;
      Toast.show("收藏成功");
    }).catchError((e) {
      Logger.e(e);
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
