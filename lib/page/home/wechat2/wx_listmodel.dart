import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/base/baselist/base_list_model.dart';
import 'package:flutter_wananzhuo/base/baselist/base_list_viewmodel.dart';
import 'package:flutter_wananzhuo/model/wx_off_mode.dart';

class WxListViewModel extends BaseListViewModel<Datas,Data>{
  var wxOffcialId = 1;

  @override
  String getUrl(int index) {

    var url = "/wxarticle/list/$wxOffcialId/$index/json?k=Java";
    return url;
  }

  @override
  Data getModel(Map<String, dynamic> json) {
    return Data.fromJson(json);
  }

}