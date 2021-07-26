import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/page/home/mine_page.dart';
import 'package:flutter_wananzhuo/page/home/wechat_page.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/view/loading_dialog.dart';
import 'package:provider/provider.dart';

import '../../setting.dart';
import 'first_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  void _onItemTapped(int postion) {
    if (mounted) {
      setState(() {
        // _pageController.animateToPage(postion,
        //     duration: const Duration(milliseconds: 300), curve: Curves.ease);
        _currentIndex = postion;
      });
    }
  }

  void _pageChaged(int postion) {
    if (mounted) {
      setState(() {
        _currentIndex = postion;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentIndex = 0;

  final tabTitle = ["首页", "发现", "我的"];
  final tabIcon = [Icons.home, Icons.book, Icons.person];
  final listPage = [FirstPage(), WechatAritclePage(), MinePage()];

  @override
  Widget build(BuildContext context) {
    initUtil();
    return Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: IndexedStack(
          index: _currentIndex,
          children: listPage,
        ));
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
        // BottomNavigationBarType 中定义的类型，有 fixed 和 shifting 两种类型
        type: BottomNavigationBarType.fixed,

        // BottomNavigationBarItem 中 icon 的大小
        iconSize: 24.0,

        // 当前所高亮的按钮index
        currentIndex: _currentIndex,

        // 点击里面的按钮的回调函数，参数为当前点击的按钮 index
        onTap: _onItemTapped,

        // 如果 type 类型为 fixed，则通过 fixedColor 设置选中 item 的颜色
        items: _buildItem(),
        unselectedItemColor: Colors.grey,
      selectedItemColor: Theme.of(context).primaryColor,
    );
  }

  List<BottomNavigationBarItem> _buildItem() {
    var array = <BottomNavigationBarItem>[];

    for (int i = 0; i < tabTitle.length; i++) {
      BottomNavigationBarItem item = BottomNavigationBarItem(
          icon: Icon(
            tabIcon[i],
          ),
        label:tabTitle[i],
         );
      array.add(item);
    }
    return array;
  }

  HomeResponseEntity? home;

  @override
  bool get wantKeepAlive => true;

  void initUtil() {
    Toast.init(context);
    LoadUtil.init(context);
  }
}
