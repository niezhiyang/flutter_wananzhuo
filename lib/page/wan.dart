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

  @override
  Widget build(BuildContext context) {
    Wankit.init(context);
    return ScreenUtilInit(
      builder: () {
        return MaterialApp(
            theme: ThemeData(
              primaryColor: ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].primaryColor,
              primaryColorLight:
                  ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].primaryColorLight,
              primaryColorDark:
                  ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].primaryColorDark,
              accentColor: ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].accentColor,
              bottomAppBarColor:
                  ThemeConstans.themeList[ context.watch<ThemeState>().colorIndex].bottomAppBarColor,
            ),
            // 去除右上角的fulter 标记
            debugShowCheckedModeBanner: false,
            // 所有的page集合
            onGenerateRoute: RouterInit.generateRoute,
            home: const SplashPage());
      },
      designSize: const Size(360, 690),
    );
  }
}
