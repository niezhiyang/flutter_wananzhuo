import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wananzhuo/net/interceptor/cookie_interceptor.dart';
import 'package:provider/src/provider.dart';

import '../router.dart';
import '../setting.dart';
import 'splash.dart';

class WanApp extends StatelessWidget {
  const WanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initSomething();
    return ScreenUtilInit(
      builder: () {
        return MaterialApp(
            theme: ThemeData(
                primaryColor: ThemeConstans
                    .themeColorMap[context.watch<ThemeState>().color],
                primaryColorLight: ThemeConstans
                    .themeColorMap[context.watch<ThemeState>().color]),
            // 去除右上角的fulter 标记
            debugShowCheckedModeBanner: false,
            // 所有的page集合
            onGenerateRoute: RouterInit.generateRoute,
            home: const SplashPage());
      },
      designSize: const Size(360, 690),
    );
  }

  void initSomething() {
    // 初始化路径和cook
    CookieManager.initPath().then((cookieJar) {
      CookieManager.cookieJar = cookieJar;
    });
  }
}
