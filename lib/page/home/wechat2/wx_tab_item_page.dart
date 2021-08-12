import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/base/baselist/base_state.dart';
import 'package:flutter_wananzhuo/model/wx_off_mode.dart';
import 'package:flutter_wananzhuo/page/home/wechat2/wx_listmodel.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';

///
class WxTabItemPage extends StatefulWidget {
  final int wxOfficialId;

  const WxTabItemPage(this.wxOfficialId, {Key? key}) : super(key: key);

  @override
  _WxTabItemPageState createState() => _WxTabItemPageState();
}

class _WxTabItemPageState
    extends BaseListState<WxTabItemPage, WxListViewModel, Datas> {
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
    viewModel.wxOffcialId = widget.wxOfficialId;
  }

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
      margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.w))), //设置圆角
      elevation: 2,
      child: InkWell(
        onTap: () {
          // ArticleDetailPage.push(context, homeItem);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (homeItem.collect!) {
                      viewModel.cancelArticle(homeItem.id, index);
                    } else {
                      viewModel.saveArticle(homeItem.id, index);
                    }
                  },
                  icon: Icon(
                    homeItem.collect! ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  )),
              SizedBox(
                width: 10.w,
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
                        width: 10.w,
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
                    height: 10.w,
                  ),
                  Text(
                    homeItem.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10.w,
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
