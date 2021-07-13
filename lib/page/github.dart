import 'package:flutter/material.dart';

import '../router.dart';
import 'splash.dart';

class GitHubApp extends StatelessWidget {
  const GitHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(),
        // 去除右上角的fulter 标记
        // debugShowCheckedModeBanner: false,
        // 所有的page集合
        onGenerateRoute: RouterInit.generateRoute,
        home: const SplashPage());
  }
}
