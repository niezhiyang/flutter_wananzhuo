import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/page/article_details.dart';
import 'package:flutter_wananzhuo/view/banner.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';
import 'package:flutter_wananzhuo/view/wan_refresh.dart';
import 'package:provider/provider.dart';

import '../../search_page.dart';
import 'first_mode.dart';
import 'first_viewmodel.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPagePageState createState() {
    return FirstPagePageState();
  }
}

class FirstPagePageState extends State<FirstPage> {
  late EasyRefreshController _controller;

  late ScrollController _scrollController;
  late FirstViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _controller = EasyRefreshController();
    _scrollController = ScrollController();
    _viewModel = FirstViewModel(
        easyRefreshController: _controller,
        scrollController: _scrollController);
    _viewModel.getNetData();
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
        actions: [
          IconButton(
              onPressed: () {
                SearchPage.push(context);
              },
              icon: const Icon(Icons.search))
        ],
        title: const Text("首页"),
      ),
      body: _getBodyForProvider(),
    );
  }

  Widget _headerItem(FirstModle mode) {
    if (mode.banners.isEmpty) {
      return const SizedBox(
        height: 200,
      );
    } else {
      return Banners(
        click: (int position) {
          var bannerData = mode.banners[position];
          HomeResponseDataDatas datas = HomeResponseDataDatas();
          datas.title = bannerData.title;
          datas.link = bannerData.url;
          ArticleDetailPage.push(context, datas);
        },
        tabs: mode.bannerUrl,
      );
    }
    // return Image.network(mode.banners[0].imagePath!);
  }

  Widget _articleItem(HomeResponseDataDatas homeItem, int position) {
    String? chapter = homeItem.superChapterName;
    if (homeItem.chapterName != null) {
      chapter = "$chapter/${homeItem.chapterName}";
    }

    // 这里处理登录之后 刷新即可
    // if (Wankit.isLogin) {
    //   List<int>? collectIds = context.watch<User>().collectIds;
    //   if (collectIds != null && collectIds.contains(homeItem.id)) {
    //     homeItem.collect = true;
    //   }
    // } else {
    //   homeItem.collect = false;
    // }

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
                    _viewModel.cancelArticle(homeItem.id, position);
                  } else {
                    _viewModel.saveArticle(homeItem.id, position);
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

  /// 使用 ValueListenableBuilder 实现
  Widget _getBody() {
    return ValueListenableBuilder<FirstModle>(
      valueListenable: _viewModel,
      builder: (BuildContext context, FirstModle model, Widget? child) {
        return _bodyChild(model);
      },
    );
  }

  /// 使用 ChangeNotifierProvider 实现
  Widget _getBodyForProvider() {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      child: Consumer<FirstViewModel>(
          builder: (context, FirstViewModel viewModel, child) {
        FirstModle model = viewModel.value;
        return _bodyChild(model);
      }),
    );
  }

  LoadLayout _bodyChild(FirstModle model) {
    return LoadLayout(
      WanRefresh(
        controller: _controller,
        scrollController: _scrollController,
        onRefresh: _viewModel.getNetData,
        onLoad: _viewModel.onLoad,
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _headerItem(model);
              }
              return _articleItem(model.articleList[index - 1], index - 1);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1, color: Colors.black12);
            },
            itemCount: model.articleList.length + 1),
      ),
      errorRetry: _viewModel.getNetData,
      loadStatus: model.loadStatus,
    );
  }
}
