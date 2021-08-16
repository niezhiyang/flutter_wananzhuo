import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/model/wx_off_mode.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../router.dart';

class ArticleDetailPage extends StatefulWidget {
  ArticleDetailPage({Key? key}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();

  static void push(BuildContext context, HomeResponseDataDatas homeItem) {
    Navigator.of(context).pushNamed(RouterInit.article, arguments: homeItem);
  }
  // 因为 使用 通用 加载更多改造，mode 也改了，所以
  static void pushData(BuildContext context, Datas datas) {
    HomeResponseDataDatas homeItem = HomeResponseDataDatas();
    homeItem.title = datas.title;
    homeItem.link = datas.link;
    Navigator.of(context).pushNamed(RouterInit.article, arguments: homeItem);
  }
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  HomeResponseDataDatas? article;
  var isStart = false;
  var progress = 0.0;

  @override
  Widget build(BuildContext context) {
    article =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as HomeResponseDataDatas;
    return Scaffold(
      appBar: AppBar(title: Text(article?.title ?? "")),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: article?.link,
            onPageFinished: (url) {
              setState(() {
                isStart = false;
              });
            },
            onPageStarted: (url) {
              setState(() {
                isStart = true;
              });
            },
            onProgress: (p) {

              setState(() {
                progress = p/100;
              });
            },
          ),
          Visibility(
            child: LinearProgressIndicator(value: progress),
            visible: isStart,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }
}
