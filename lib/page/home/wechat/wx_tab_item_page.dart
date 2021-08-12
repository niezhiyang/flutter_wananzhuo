import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/page/article_details.dart';
import 'package:flutter_wananzhuo/page/home/wechat/wechat_repository.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';
import 'package:flutter_wananzhuo/view/wan_refresh.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';
import 'package:provider/src/provider.dart';
class TabViewItem extends StatefulWidget {
  final int id;

  TabViewItem(this.id, {Key? key}) : super(key: key);

  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem> with AutomaticKeepAliveClientMixin {
  final _repository = Wechatepository();
  final _articalrepository = HomeRepository();
  int _index = 0;
  late EasyRefreshController _controller;

  late ScrollController _scrollController;
  var loadState = LoadStatus.loading;
  HomeResponseData? _responseData;
  final List<HomeResponseDataDatas> _articleList = [];

  @override
  void initState() {
    _controller = EasyRefreshController();
    _scrollController = ScrollController();
    super.initState();
    _getNetData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadLayout(
      WanRefresh(
        controller: _controller,
        scrollController: _scrollController,
        onRefresh: _getNetData,
        onLoad: _onLoad,
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _articleItem(_articleList[index], index);
            },
            itemCount: _articleList.length),
      ),
      errorRetry: _getNetData,
      loadStatus: loadState,
    );
  }

  Future<void> _getNetData() async {
    setState(() {
      loadState = LoadStatus.loading;
    });
    _index = 0;

    Future<HomeResponseData?> home =
    _repository.getAritcForWxOffical(widget.id, _index);

    home.then((value) {
      if (value != null) {
        setData(value);
      }
      _index++;
      _controller.resetLoadState();
      _controller.finishRefresh();
      if(value!.total! <= _articleList.length){
        _controller.finishLoad(success:true,noMore: true);
      }
    }).onError((error, stackTrace) {
      Logger.e(error);
      setState(() {
        loadState = LoadStatus.netError;
      });

      _controller.finishRefresh(success: false);

    });
  }

  Future<void> _onLoad() async {
    Future<HomeResponseData?> home =
    _repository.getAritcForWxOffical(widget.id, _index);

    home.then((value) {
      if (mounted) {
        setState(() {
          _articleList.addAll(value!.datas!);
        });
      }
      _controller.finishLoad(
          success: true, noMore: value!.total! <= _articleList.length);
      _index++;
    }).onError((error, stackTrace) {
      Logger.e(error);
      _controller.finishLoad(success: false);
    });
  }

  void setData(HomeResponseData _article) {
    if (mounted) {
      setState(() {
        loadState = LoadStatus.content;
        _responseData = _article;

        List<HomeResponseDataDatas>? homeDataResponse = _responseData?.datas;

        if (homeDataResponse != null && homeDataResponse.isNotEmpty) {
          _articleList.clear();
          _articleList.addAll(homeDataResponse);
        }

        if (_articleList.isEmpty) {
          loadState = LoadStatus.empty;
        }
      });
    }
  }

  Widget _articleItem(HomeResponseDataDatas homeItem, int index) {
    String? chapter = homeItem.superChapterName;
    if (homeItem.chapterName != null) {
      chapter = "$chapter/${homeItem.chapterName}";
    }

    // 找到收集的
    if (Wankit.isLogin) {
      List<int>? collectIds = context.watch<User>().collectIds;
      if (collectIds != null && collectIds.contains(homeItem.id)) {
        homeItem.collect = true;
      }
    } else {
      homeItem.collect = false;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.w))), //设置圆角
      elevation: 2,
      child: InkWell(
        onTap: () {
          ArticleDetailPage.push(context, homeItem);
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
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
                          _articleList[index].collect = false;
                        });
                      }).onError((error, stackTrace) {
                        Logger.e(error);
                      });
                    } else {
                      _articalrepository.saveArticle(homeItem.id).then((value) {
                        Toast.show("收藏成功");
                        setState(() {
                          _articleList[index].collect = true;
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

  @override
  bool get wantKeepAlive => true;
}
