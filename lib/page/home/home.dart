import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/model/banner_entity.dart';
import 'package:flutter_wananzhuo/net/Repository/home_repository.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/net/Repository/user_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:provider/provider.dart';

import '../../setting.dart';
import 'first_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  void _onItemTapped(int postion) {
    if (mounted) {
      setState(() {
        _pageController.animateToPage(postion,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
    _pageController = PageController(initialPage: _currentIndex);


  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  int _currentIndex = 0;

  final tabTitle = ["首页", "发现", "我的"];
  final tabIcon = [Icons.home, Icons.search, Icons.person];

  late PageController _pageController;

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    return Scaffold(
        appBar: AppBar(title: const Text("Github")),
        bottomNavigationBar: _bottomNavigationBar(),
        body: PageView(
          controller: _pageController,
          onPageChanged: _pageChaged,
          children: _buildPageChild(),
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
      fixedColor: Colors.blue,
      items: _buildItem(),
    );
  }


  List<BottomNavigationBarItem> _buildItem() {
    var array = <BottomNavigationBarItem>[];

    for (int i = 0; i < tabTitle.length; i++) {
      BottomNavigationBarItem item = BottomNavigationBarItem(
        icon: Icon(tabIcon[i]),
        label: tabTitle[i],
      );
      array.add(item);
    }
    return array;
  }

  HomeResponseEntity? home;

  List<Widget> _buildPageChild() {
    var array = <Widget>[];
    for (int i = 0; i < tabTitle.length; i++) {
      TextButton item = TextButton(
        child: Container(
          color: ThemeConstans.themeColorMap[context.watch<ThemeState>().color],
          child: SizedBox(
            width: 100,
            height: 100,
            child: Text(
              "${home?.data?.datas?[0].chapterName}",
            ),
          ),
        ),
        onPressed: () {
          UserRepository userRepository = UserRepository();
          userRepository.login().then((value) => {

          });

          String color = "black";
          switch (i) {
            case 0:
              color = "deepPurple";
              break;
            case 1:
              color = "black";
              break;
            case 2:
              color = "deepOrange";
              break;
          }
          context.read<ThemeState>().changeThemeData(color);


        },
      );
      if(i==0){
        array.add(FirstPage());
      }else{
        array.add(item);
      }

    }
    return array;
  }

  @override
  bool get wantKeepAlive => true;


}
