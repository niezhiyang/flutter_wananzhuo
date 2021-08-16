import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/base/baselist/base_state.dart';
import 'package:flutter_wananzhuo/model/wx_off_mode.dart';
import 'package:flutter_wananzhuo/page/home/wechat2/wx_listmodel.dart';

import '../../article_details.dart';

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
    //   List<int>? collectIds = contextatch<User>().collectIds;
    //   if (collectIds != null && collectIds.contains(homeItem.id)) {
    //     homeItem.collect = true;
    //   }
    // } else {
    //   homeItem.collect = false;
    // }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))), //设置圆角
      elevation: 2,
      child: InkWell(
        onTap: () {
          ArticleDetailPage.pushData(context, homeItem);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                width: 10,
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
                        width: 10,
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
                    height: 10,
                  ),
                  Text(
                    homeItem.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
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
