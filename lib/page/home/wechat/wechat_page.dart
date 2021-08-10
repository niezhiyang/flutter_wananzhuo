import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/wx_offical_entity.dart';
import 'package:flutter_wananzhuo/page/home/wechat/wechat_repository.dart';
import 'package:flutter_wananzhuo/page/home/wechat/wx_tab_item_page.dart';
import 'package:flutter_wananzhuo/page/search_page.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';
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
    // 像这种可以存到sp或者数据库里面
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
          actions: [IconButton(onPressed: () {
            SearchPage.push(context);
          }, icon: Icon(Icons.search))],
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

