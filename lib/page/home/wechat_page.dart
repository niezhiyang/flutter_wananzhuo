import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/constans/easy_listview.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/model/wx_offical_entity.dart';
import 'package:flutter_wananzhuo/page/repository/home_repository.dart';
import 'package:flutter_wananzhuo/page/repository/wechat_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';
import 'package:provider/src/provider.dart';

import '../../wan_kit.dart';
import '../article_details.dart';

class WechatAritclePage extends StatefulWidget {
  const WechatAritclePage({Key? key}) : super(key: key);

  @override
  _WechatAritclePageState createState() => _WechatAritclePageState();
}

class _WechatAritclePageState extends State<WechatAritclePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final repository = Wechatepository();
  var loadState = LoadStatus.loading;

  @override
  bool get wantKeepAlive => true;
  final List<Tab> _tabs = [];
  List<WxOfficalData> _articList = [];
  TabController? _tabController;

  @override
  void initState() {
    getWxOff();
    super.initState();
  }

  void getWxOff() {
    repository.getWxtOfficial().then((wxArticle) {
      if (wxArticle != null) {
        setState(() {
          loadState = LoadStatus.content;
          _articList = wxArticle;
          _tabs.addAll(_articList
              .map((e) => Tab(
                    text: e.name,
                  ))
              .toList());
          _tabController = TabController(vsync: this, length: _tabs.length);
        });
      }
    }).catchError((e, s) {
      setState(() {
        loadState = LoadStatus.netError;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadLayout(
      Scaffold(
        body: _getTabView(),
        appBar: AppBar(
          // 如果没有设置这项， 二级页面 会默认是返回箭头  ， 有侧边栏的页面默认有图标（用来打开侧边栏）
          automaticallyImplyLeading: true,
          // 如果有 leading  这个不会管用 ； 如果没有leading ，当有侧边栏的时候， false：不会显示默认的图片，true 会显示 默认图片，并响应打开侧边栏的事件
          title: const Text("公众号"),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          // 标题是否在居中
          bottom: _getTabBar(),
        ),
      ),
      loadStatus: loadState,
      errorRetry: getWxOff,
    );
  }

  TabBar? _getTabBar() {
    if (_tabs.isEmpty) {
      return null;
    }
    return TabBar(
      isScrollable: true,
      labelColor: Colors.redAccent,
      // 选中的Widget颜色
      indicatorColor: Colors.white,
      // 选中的指示器颜色
      labelStyle: const TextStyle(fontSize: 18.0),
      // 必须设置，设置 color 没用的，因为 labelColor 已经设置了
      unselectedLabelColor: Colors.white,
      unselectedLabelStyle: TextStyle(fontSize: 16.0),
      // 设置 color 没用的，因为unselectedLabelColor已经设置了
      controller: _tabController,
      // tabbar 必须设置 controller 否则报错
      indicatorSize: TabBarIndicatorSize.label,
      // 有 tab 和 label 两种
      tabs: _tabs,
    );
  }

  TabBarView? _getTabView() {
    if (_tabs.isEmpty) {
      return null;
    }
    return TabBarView(
      controller: _tabController,
      children: _articList.map((WxOfficalData articWx) {
        return TabViewItem(articWx.id!);
      }).toList(),
    );
  }
}

class TabViewItem extends StatefulWidget {
  final int id;

  TabViewItem(this.id, {Key? key}) : super(key: key);

  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {
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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))), //设置圆角
      elevation: 2,
      child: InkWell(
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
                      const SizedBox(
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
