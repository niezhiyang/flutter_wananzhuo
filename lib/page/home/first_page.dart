import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/banner/banner.dart';
import 'package:flutter_wananzhuo/constans.dart';
import 'package:flutter_wananzhuo/constans/easy_listview.dart';
import 'package:flutter_wananzhuo/model/banner_entity.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/net/Repository/home_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';

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
  List<BannerData> _banners = [];
  List<String> _bannerUrl = [];
  List<HomeResponseDataDatas> _homeDataResponse = [];
  bool _isFirstLoad = true;
  late EasyRefreshController _controller;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _scrollController = ScrollController();
    _getNetData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
              child: const CircularProgressIndicator(), visible: _isFirstLoad),
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
                  return _articleItem(_homeDataResponse[index - 1]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 1, color: Colors.black12);
                },
                itemCount: _homeDataResponse.length + 1),
          )
        ],
      ),
    );
  }

  void setData(List<Object> value) {
    BannerEntity banner = value[1] as BannerEntity;
    if (mounted) {
      setState(() {
        _homeResponse = value[0] as HomeResponseEntity;

        List<HomeResponseDataDatas>? homeDataResponse =
            _homeResponse?.data?.datas;

        if (homeDataResponse != null && homeDataResponse.isNotEmpty) {
          _homeDataResponse.clear();
          _homeDataResponse.addAll(homeDataResponse);
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
          Toast.show(_banners[position].title);
        },
        tabs: _bannerUrl,
      );
    }
    return Image.network(_banners[0].imagePath!);
  }

  Widget _articleItem(HomeResponseDataDatas homeItem) {
    String? chapter = homeItem.superChapterName;
    if (homeItem.chapterName != null) {
      chapter = "$chapter/${homeItem.chapterName}";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Icon(homeItem.collect! ? Icons.favorite : Icons.favorite_border),
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
                          style:
                              const TextStyle(fontSize: 14, color: Colors.black87)),
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
                      style:
                      TextStyle(fontSize: 13, color: Colors.black45)),
                  TextSpan(
                      text: homeItem.niceDate ?? "",
                      style:
                      const TextStyle(fontSize: 14, color: Colors.black87)),
                ]),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Future<void> _getNetData() async {
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
      _controller.finishRefresh(success: false);
    });
  }

  Future<void> _onLoad() async {
    Future<HomeResponseEntity> home = _repository.getHome(index);

    home.then((value) {
      if (mounted) {
        setState(() {
          _homeDataResponse.addAll(value.data!.datas!);
        });
      }
      _controller.finishLoad(
          success: true, noMore: value.data!.total! < _banners.length);
      index++;
    }).onError((error, stackTrace) {
      Logger.e(error);
      _controller.finishLoad(success: false);
    });
  }
}
