import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wananzhuo/net/interceptor/cookie_interceptor.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';
import 'package:provider/src/provider.dart';

import '../router.dart';
import '../setting.dart';
import 'splash.dart';

class WanApp extends StatelessWidget {
  const WanApp({Key? key}) : super(key: key);
  // GlobalKey<>
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () {
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
            home: const SplashPage());
      },
      designSize: const Size(360, 690),
    );
  }

  _getTheme(BuildContext context) {
   return  ThemeData(
      primaryColor: ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].primaryColor,
      primaryColorLight:
      ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].primaryColorLight,
      primaryColorDark:
      ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].primaryColorDark,
      accentColor: ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].accentColor,
      bottomAppBarColor:
      ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].bottomAppBarColor,
    );
  }
}
