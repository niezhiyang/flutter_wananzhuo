import 'package:flutter/material.dart';

import 'page/article_details.dart';
import 'page/home/home.dart';
import 'page/splash.dart';

class RouterInit {
  static const splash = "splash";
  static const home = "home";
  static const article = "article";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return Right2LeftRouter(child: const SplashPage(),settings:settings);

      case home:
        return Right2LeftRouter(child: const HomePage(),settings:settings);

      case article:

        return Right2LeftRouter(child: ArticleDetailPage(),settings:settings);
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(settings.name!),
            ),
            body: Center(
              child: Text("找不到${settings.name}的导航"),
            ),
          );
        });
    }
  }
}

class Left2RightRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  late List<int> mapper;

  Left2RightRouter(
      {required this.child,
      this.durationMs = 500,
      this.curve = Curves.fastOutSlowIn})
      : assert(true),
        super(
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (ctx, a1, a2) {
              return child;
            },
            transitionsBuilder: (
              ctx,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-1.0, 0.0),
                    end: Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });
}

//右--->左
class Right2LeftRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Right2LeftRouter({
    required this.child,
    this.durationMs = 500,
    this.curve = Curves.fastOutSlowIn,
    RouteSettings? settings,
  }) : super(
           settings: settings,
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (ctx, a1, a2) => child,
            transitionsBuilder: (ctx, a1, a2, child,) =>
                SlideTransition(
                  child: child,
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                ));
}
