import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/router.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';
import 'package:provider/provider.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    String? name = context.watch<User>().username;
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            primary: true,
            forceElevated: false,
            automaticallyImplyLeading: true,
            expandedHeight: 200.0,
            snap: true,
            //与floating结合使用
            floating: true,
//            title: _title(),
            pinned: true,
            //是否固定在顶部,往上滑，导航栏可以隐藏
            flexibleSpace: FlexibleSpaceBar(
                //可以展开区域，通常是一个FlexibleSpaceBar
                centerTitle: true,
                title: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/img/avatar.webp",
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      ),
                      Text(
                        name ?? "请登录",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (Wankit.isLogin) {
                      Toast.show("去个人详情页面了");
                    } else {
                      Navigator.of(context).pushNamed(RouterInit.login);
                    }
                  },
                ),
                background:
                    Image.asset("assets/img/blue.webp", fit: BoxFit.cover)),
          ),
        ];
      },
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem(index);
        },
        itemCount: title.length + 1,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 1, color: Colors.black26);
        },
      ),
    ));
  }

  final title = ["应用设置", "我的收藏", "我的分享", "关于应用"];
  final icon = [Icons.settings, Icons.favorite, Icons.share, Icons.pan_tool];
  final page = [RouterInit.setting, RouterInit.collect, "Icons.share", "Icons.pan_tool"];

  Widget _buildListItem(int index) {
    if (index == 4) {
      return Container(
          margin: const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 0),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
            elevation: 3,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            color: Colors.blue,
            minWidth: 60,
            onPressed: _loginOut,
            child: const Text("退出登录",
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ));
    }
    return _buildItem(icon[index], title[index], page[index]);
  }

  void _loginOut() {
    Wankit.loginOut();
  }



  Widget _buildItem(IconData icon, String title, String pageTo) => ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        trailing:
            Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
        onTap: () {
          if (pageTo.isNotEmpty) {
            Navigator.of(context).pushNamed(pageTo);
          }
        },
      );
}
