import 'dart:async';

import 'package:flutter/material.dart';

//有参数的   先定义一个函数类型
typedef ClickCallBack = Function(int position);

class Banners extends StatefulWidget {
  final List<String> tabs;
  final ClickCallBack click;

  const Banners({
    Key? key,
    required this.tabs,
    required this.click,
  }) : super(key: key);

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banners> with SingleTickerProviderStateMixin {
  late TabController _tabConTroller;
  int second = 0;
  late Timer timer;

  @override
  void initState() {
    _tabConTroller = TabController(vsync: this, length: widget.tabs.length, );
    const timeout = const Duration(seconds: 2);
    timer = Timer.periodic(timeout, (timer) {
      second++;
      _tabConTroller.animateTo(second % widget.tabs.length,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabConTroller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _buildTableBarView(),
              Positioned(top: 165, child: _buildTabPageSelector()),
            ],
          ),
        ));
  }

  Widget _buildTableBarView() {
    return SizedBox(
      height: 200,
      child: TabBarView(controller: _tabConTroller, children: _getChilder()),
    );
  }

  Widget _buildTabPageSelector() {
    return TabPageSelector(
      controller: _tabConTroller,
      color: Colors.white,
      indicatorSize: 10,
      selectedColor: Colors.red,
    );
  }

  List<Widget> _getChilder() {
    List<Widget> children = [];
    for (int i = 0; i < widget.tabs.length; i++) {
      children.add(GestureDetector(
        child: Image.network(widget.tabs[i], height: 200, fit: BoxFit.fill),
        onTapUp: (detai) {
          widget.click(i);
        },
      ));
    }
    return children;
  }
}
