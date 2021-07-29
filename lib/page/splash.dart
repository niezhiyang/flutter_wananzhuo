import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';

import '../router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，
    // 覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    WidgetsBinding.instance?.addPostFrameCallback((callback) {
      Wankit.init();
      Future.delayed(const Duration(seconds: 1)).then((value) =>
          Navigator.of(context).pushReplacementNamed(RouterInit.home));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/img/splash.webp",
      fit: BoxFit.fill,
    );
  }
}
