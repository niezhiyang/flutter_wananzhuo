import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';
import 'package:provider/src/provider.dart';

import '../router.dart';
import '../setting.dart';
import 'splash.dart';

class WanApp extends StatelessWidget {
  WanApp({Key? key}) : super(key: key);
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  // GlobalKey<>
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: Wankit.navigatorKey,
        theme: _getTheme(context),
        // 去除右上角的fulter 标记
        debugShowCheckedModeBanner: false,
        // 所有的page集合
        onGenerateRoute: RouterInit.generateRoute,
        // routes: {
        //   // 这个 / 不能和 home 同时存在，都是主页面而已
        //   "/": (_) {
        //     return Center();
        //   },
        //   "/page": (_) {
        //     return Center();
        //   },
        // },
        locale: DevicePreview.locale(context), // Add the locale here
        builder: DevicePreview.appBuilder,

        home: const SplashPage());
  }

  _getTheme(BuildContext context) {
    return ThemeData(
      primaryColor: ThemeConstans
          .themeList[context.watch<ThemeState>().colorIndex].primaryColor,
      primaryColorLight: ThemeConstans
          .themeList[context.watch<ThemeState>().colorIndex].primaryColorLight,
      primaryColorDark: ThemeConstans
          .themeList[context.watch<ThemeState>().colorIndex].primaryColorDark,
      accentColor: ThemeConstans
          .themeList[context.watch<ThemeState>().colorIndex].accentColor,
      bottomAppBarColor: ThemeConstans
          .themeList[context.watch<ThemeState>().colorIndex].bottomAppBarColor,
    );
  }


}



