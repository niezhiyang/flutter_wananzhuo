import 'package:flutter/cupertino.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';

import '../../router.dart';

class BaseLoginWidget extends StatelessWidget {
  final Widget child;

  const BaseLoginWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Wankit.isLogin) {
      Navigator.of(context).pushReplacementNamed(RouterInit.login);
    }

    return child;
  }
}
