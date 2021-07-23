import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../router.dart';

class ArticleDetailPage extends StatefulWidget {
  ArticleDetailPage({Key? key}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();

  static void push(BuildContext context, HomeResponseDataDatas homeItem) {
    Navigator.of(context).pushNamed(RouterInit.article, arguments: homeItem);

  }
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  HomeResponseDataDatas? article;
  var isStart = false;

  @override
  Widget build(BuildContext context) {
    article =
        ModalRoute.of(context)?.settings.arguments as HomeResponseDataDatas;
    return Scaffold(
      appBar: AppBar(title: Text(article?.title ?? "")),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: article?.link,
            onPageFinished: (url) {
              // setState(() {
              //   isStart = false;
              // });
            },
            onPageStarted: (url) {
              // setState(() {
              //   isStart = true;
              // });
            },
          ),
          Visibility(
            child: Center(child: CircularProgressIndicator()),
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
