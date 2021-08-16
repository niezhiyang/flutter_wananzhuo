import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/constans/easy_listview.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/page/login/base_login_page.dart';
import 'package:flutter_wananzhuo/page/repository/collect_repository.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';

import 'article_details.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({Key? key}) : super(key: key);

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final _articalRepository = HomeRepository();
  final _collectRepository = CollectRepository();
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
    return BaseLoginWidget(
        child: Scaffold(
      appBar: AppBar(title: Text("我的收藏")),
      body: LoadLayout(
        LoadLayout(
          EasyRefresh(
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            controller: _controller,
            scrollController: _scrollController,
            header: ClassicalHeader(
              refreshText: ConstansListView.pullToRefresh,
              refreshReadyText: ConstansListView.releaseToRefresh,
              refreshingText: ConstansListView.refreshing,
              refreshedText: ConstansListView.refreshed,
              refreshFailedText: ConstansListView.refreshFailed,
              noMoreText: ConstansListView.noMore,
              infoText: ConstansListView.updateAt,
            ),
            footer: ClassicalFooter(
              loadText: ConstansListView.pushToLoad,
              loadReadyText: ConstansListView.releaseToLoad,
              loadingText: ConstansListView.loading,
              loadedText: ConstansListView.loaded,
              loadFailedText: ConstansListView.loadFailed,
              noMoreText: ConstansListView.noMore,
              infoText: ConstansListView.updateAt,
            ),
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
        ),
        loadStatus: loadState,
        errorRetry: _getNetData,
      ),
    ));
  }

  Future<void> _getNetData() async {
    setState(() {
      loadState = LoadStatus.loading;
    });
    _index = 0;

    _collectRepository.getCollectArtical(_index).then((value) {
      if (value != null) {
        setData(value);
      }
      _index++;
      _controller.resetLoadState();
      _controller.finishRefresh();
    }).onError((error, stackTrace) {
      Logger.e(error);
      setState(() {
        loadState = LoadStatus.netError;
      });

      _controller.finishRefresh(success: false);
    });
  }

  Future<void> _onLoad() async {
    _collectRepository.getCollectArtical(_index).then((value) {
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
        _controller.finishLoad(
            success: true, noMore: _article.total! <= _articleList.length);
      });
    }
  }

  Widget _articleItem(HomeResponseDataDatas homeItem, int index) {
    String? chapter = homeItem.superChapterName;
    if (homeItem.chapterName != null) {
      chapter = "$chapter/${homeItem.chapterName}";
    }
    homeItem.collect = true;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))), //设置圆角
      elevation: 2,
      child: InkWell(
        onTap: () {
          ArticleDetailPage.push(context, homeItem);
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (homeItem.collect!) {
                      _articalRepository
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
                      _articalRepository.saveArticle(homeItem.id).then((value) {
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
              const SizedBox(
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
