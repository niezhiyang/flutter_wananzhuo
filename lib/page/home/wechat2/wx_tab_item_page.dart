import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/base/baselist/base_state.dart';
import 'package:flutter_wananzhuo/model/wx_off_mode.dart';
import 'package:flutter_wananzhuo/page/home/wechat2/wx_listmodel.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';


/**
 *  @author niezhiyang
 *  since 8/10/21
 */
class WxTabItemPage extends StatefulWidget {
  final int wxOffcialId;

  WxTabItemPage(this.wxOffcialId,{Key? key}) : super(key: key);

  @override
  _WxTabItemPageState createState() => _WxTabItemPageState();
}

class _WxTabItemPageState
    extends BaseListState<WxTabItemPage, WxListViewModel, Datas> {
  final _articalrepository = HomeRepository();

  @override
  WxListViewModel initViewModel() {
    return WxListViewModel();
  }
  @override
  Widget getChild() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _articleItem(viewModel.itemList[index], index);
        },
        itemCount: viewModel.itemList.length);
  }

  @override
  void init() {
    viewModel.wxOffcialId = widget.wxOffcialId;

  }

  WxListViewModel tempViewModel =  WxListViewModel();


  Widget _articleItem(Datas homeItem, int index) {
    String? chapter = homeItem.superChapterName;
    if (homeItem.chapterName != null) {
      chapter = "$chapter/${homeItem.chapterName}";
    }

    // // 找到收集的
    // if (Wankit.isLogin) {
    //   List<int>? collectIds = context.watch<User>().collectIds;
    //   if (collectIds != null && collectIds.contains(homeItem.id)) {
    //     homeItem.collect = true;
    //   }
    // } else {
    //   homeItem.collect = false;
    // }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.h),
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.h))), //设置圆角
      elevation: 2,
      child: InkWell(
        onTap: () {
          // ArticleDetailPage.push(context, homeItem);
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (homeItem.collect!) {
                      _articalrepository
                          .cancelArticle(homeItem.id)
                          .then((value) {
                        Toast.show("取消成功");
                        setState(() {
                          viewModel.itemList[index].collect = false;
                        });
                      }).onError((error, stackTrace) {
                        Logger.e(error);
                      });
                    } else {
                      _articalrepository.saveArticle(homeItem.id).then((value) {
                        Toast.show("收藏成功");
                        setState(() {
                          viewModel.itemList[index].collect = true;
                        });
                      }).onError((error, stackTrace) {
                        Logger.e(error);
                      });
                    }
                  },
                  icon: Icon(
                    homeItem.collect! ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  )),
              SizedBox(
                width: 10.h,
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                  text: "作者：",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black45)),
                              TextSpan(
                                  text: homeItem.shareUser ?? "",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87)),
                            ]),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                  text: "分类：",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black45)),
                              TextSpan(
                                  text: chapter,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87)),
                            ]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        homeItem.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "时间：",
                              style:
                              TextStyle(fontSize: 13, color: Colors.black45)),
                          TextSpan(
                              text: homeItem.niceDate ?? "",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87)),
                        ]),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }









}
