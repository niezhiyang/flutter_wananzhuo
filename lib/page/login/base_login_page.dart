import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';

import '../../router.dart';

class BaseLoginWidget extends StatefulWidget {
  final Widget child;

  const BaseLoginWidget({Key? key, required this.child}) : super(key: key);

  @override
  _BaseLoginWidgetState createState() => _BaseLoginWidgetState();
}

class _BaseLoginWidgetState extends State<BaseLoginWidget> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((callback) {
      if (!Wankit.isLogin) {
        Navigator.of(context).pushReplacementNamed(RouterInit.login);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger.e("ddddd ${Wankit.isLogin}");
    if (!Wankit.isLogin) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return widget.child;
  }
}
