import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/base/provider_widget.dart';
import 'package:flutter_wananzhuo/model/home_response_entity.dart';
import 'package:flutter_wananzhuo/page/home/first/first_page.dart';
import 'package:flutter_wananzhuo/page/home/home/home_viewmodel.dart';
import 'package:flutter_wananzhuo/page/home/mine_page.dart';
import 'package:flutter_wananzhuo/page/home/wechat/wechat_page.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final tabTitle = ["首页", "公众号", "我的"];
  final tabIcon = [Icons.home, Icons.book, Icons.person];
  final listPage = [FirstPage(), WechatAritclePage(), MinePage()];
  HomeViewModel viewModel = HomeViewModel();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ProviderWidget<HomeViewModel>(
          model: viewModel,
          onModelInit: (model) {
            // viewModel.changeIndex(1);
          },
          builder: (BuildContext context, HomeViewModel viewModel, Widget? child) {
            return Scaffold(
                bottomNavigationBar: _bottomNavigationBar(viewModel),
                body: IndexedStack(
                  index: viewModel.currentIndex,
                  children: listPage,
                ));
          },
        ),
        onWillPop: _onPop);
  }

  BottomNavigationBar _bottomNavigationBar(HomeViewModel viewModel) {
    return BottomNavigationBar(
      // BottomNavigationBarType 中定义的类型，有 fixed 和 shifting 两种类型
      type: BottomNavigationBarType.fixed,

      // BottomNavigationBarItem 中 icon 的大小
      iconSize: 24,

      // 当前所高亮的按钮index
      currentIndex: viewModel.currentIndex,

      // 点击里面的按钮的回调函数，参数为当前点击的按钮 index
      onTap: (position) {
        viewModel.changeIndex(position);
      },

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
        label: tabTitle[i],
      );
      array.add(item);
    }
    return array;
  }

  HomeResponseEntity? home;

  @override
  bool get wantKeepAlive => true;

  var _lastQuitTime = DateTime.now();

  Future<bool> _onPop() async {
    if (DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
      Toast.show("再按一下退出");
      _lastQuitTime = DateTime.now();
      return false;
    } else {
      return true;
    }
  }


}
