import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../router.dart';
import 'splash.dart';

class WanApp extends StatelessWidget {
  const WanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () {
        return MaterialApp(
            theme: ThemeData(),
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
