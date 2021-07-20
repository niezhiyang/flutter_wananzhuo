import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/router.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "请登录",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouterInit.login);
                },
              ),
              background: _getChild2(),
            ),
          )
        ];
      },
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index.isOdd) return new Divider();
            return ListItem(index / 2);
          },
          itemCount: 40,
        ),
      ),
    ));
  }

  Widget ListItem(var index) {
    return ListTile(
      leading: const Icon(Icons.keyboard_arrow_right),
      title: Text(
        "条目$index",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _getChild() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/img/splash.webp",
          fit: BoxFit.fill,
        ),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 75,
            child: Image.asset(
              'assets/img/default_avatar.jpeg',
            ),
          ),
        )
      ],
    );
  }

  Widget _getChild2() {
    return Image.asset(
      "assets/img/splash.webp",
      fit: BoxFit.fill,
    );
  }
}
