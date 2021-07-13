

import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/net/Repository/home_repository.dart';
import 'package:flutter_wananzhuo/net/Repository/home_response_entity.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:provider/provider.dart';

import '../setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  final tabIcon = [Icons.home, Icons.search, Icons.image];

  late PageController _pageController;

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    // return Provider<ThemeState>(
    //     create: (_) => ThemeState(1, ThemeData.dark()),
    //     // we use `builder` to obtain a new `BuildContext` that has access to the provider
    //     builder: (context, widget) {
    //       return _getHome(context.read<ThemeState>());
    //     });
    // return _getHome(context.watch<ThemeState>());
    return _getHome();
  }

  Widget _getHome() {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:
            ThemeConstans.themeColorMap[context.watch<ThemeState>().color],
        primaryColorLight:
            ThemeConstans.themeColorMap[context.watch<ThemeState>().color],
      ),
      home: Scaffold(
          appBar: AppBar(title: const Text("Github")),
          drawer: _drawer(),
          bottomNavigationBar: _bottomNavigationBar(),
          body: PageView(
            controller: _pageController,
            onPageChanged: _pageChaged,
            children: _buildPageChild(),
          )),
    );
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

  Drawer _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircleAvatar(
                  child: Text('头像'),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Item 1'),
            leading: const CircleAvatar(
              child: Icon(Icons.school),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            leading: const CircleAvatar(
              child: Text('B2'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 3'),
            leading: const CircleAvatar(
              child: Icon(Icons.list),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
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

          HomeRepository repository = HomeRepository();
          var a = repository.getHome(1);
          a.then((value) {
            Toast.show(value.data?.datas?[0].chapterName);
            setState(() {
              home = value;
            });


          });


          // print(document.toString());
          // print("------------------------------------");
          // print(document.toXmlString(pretty: true, indent: '\t'));

          // Logger.v("你好呀");
          // Logger.i("你好呀");
          // Logger.d("你好呀");
          // Logger.w("你好呀");
          Logger.e("bookshelfXml2");

          context.read<ThemeState>().changeThemeData(color);
        },
      );
      array.add(item);
    }
    return array;
  }
}