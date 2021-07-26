import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/constans/easy_listview.dart';
import 'package:flutter_wananzhuo/model/banner_entity.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/page/article_details.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/router.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/view/banner.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';
import 'package:provider/src/provider.dart';

import '../search_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPagePageState createState() {
    return FirstPagePageState();
  }
}

class FirstPagePageState extends State<FirstPage> {
  int index = 0;
  final HomeRepository _repository = HomeRepository();
  HomeResponseEntity? _homeResponse = HomeResponseEntity();
  final List<BannerData> _banners = [];
  final List<String> _bannerUrl = [];
  final List<HomeResponseDataDatas> _articleList = [];
  bool _isFirstLoad = true;
  late EasyRefreshController _controller;

  late ScrollController _scrollController;
  var loadState = LoadStatus.loading;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _scrollController = ScrollController();
    _getNetData();
    // NetHelper
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {
          SearchPage.push(context);
        }, icon: Icon(Icons.search))],
        title: const Text("首页"),
      ),
      body: LoadLayout(
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
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _headerItem();
                }
                return _articleItem(_articleList[index - 1], index - 1);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 1, color: Colors.black12);
              },
              itemCount: _articleList.length + 1),
        ),
        errorRetry: _getNetData,
        loadStatus: loadState,
      ),
    );
  }

  void setData(List<Object> value) {
    BannerEntity banner = value[1] as BannerEntity;
    if (mounted) {
      setState(() {
        loadState =LoadStatus.content;
        _homeResponse = value[0] as HomeResponseEntity;

        List<HomeResponseDataDatas>? homeDataResponse =
            _homeResponse?.data?.datas;

        if (homeDataResponse != null && homeDataResponse.isNotEmpty) {
          _articleList.clear();
          _articleList.addAll(homeDataResponse);
        }
        _banners.clear();
        _bannerUrl.clear();
        _banners.addAll(banner.data!);
        _isFirstLoad = false;
        for (BannerData data in _banners) {
          _bannerUrl.add(data.imagePath!);
        }
      });
    }
  }

  Widget _headerItem() {
    if (_banners.isEmpty) {
      return const SizedBox(
        height: 200,
      );
    } else {
      return Banners(
        click: (int position) {
        var bannerData =   _banners[position];
        HomeResponseDataDatas datas = HomeResponseDataDatas();
        datas.title = bannerData.title;
        datas.link = bannerData.url;
          ArticleDetailPage.push(context, datas);
        },
        tabs: _bannerUrl,
      );
    }
    return Image.network(_banners[0].imagePath!);
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

    return GestureDetector(
      onTap: () {
        ArticleDetailPage.push(context, homeItem);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  if (homeItem.collect!) {
                    _repository.cancelArticle(homeItem.id).then((value) {
                      Toast.show("取消成功");
                      setState(() {
                        _articleList[index].collect = false;
                      });
                    }).onError((error, stackTrace) {
                      Logger.e(error);
                    });
                  } else {
                    _repository.saveArticle(homeItem.id).then((value) {
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
                            style:
                                TextStyle(fontSize: 13, color: Colors.black45)),
                        TextSpan(
                            text: homeItem.shareUser ?? "",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87)),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                            text: "分类：",
                            style:
                                TextStyle(fontSize: 13, color: Colors.black45)),
                        TextSpan(
                            text: chapter,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  homeItem.title ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: "时间：",
                        style: TextStyle(fontSize: 13, color: Colors.black45)),
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
    );
  }

  Future<void> _getNetData() async {
    setState(() {
      loadState = LoadStatus.loading;
    });
    index = 0;
    Future<HomeResponseEntity> home = _repository.getHome(index);
    Future<BannerEntity> banner = _repository.geyBanner();

    Future.wait([home, banner]).then((value) {
      setData(value);
      index++;
      _controller.resetLoadState();
      _controller.finishRefresh();
    }).onError((error, stackTrace) {
      Logger.e(error);
      setState(() {
        loadState =LoadStatus.netError;
      });

      _controller.finishRefresh(success: false);
    });
  }

  Future<void> _onLoad() async {
    Future<HomeResponseEntity> home = _repository.getHome(index);

    home.then((value) {
      if (mounted) {
        setState(() {
          _articleList.addAll(value.data!.datas!);
        });
      }
      _controller.finishLoad(
          success: true, noMore: value.data!.total! <= _articleList.length);
      index++;
    }).onError((error, stackTrace) {
      Logger.e(error);
      _controller.finishLoad(success: false);
    });
  }
}
