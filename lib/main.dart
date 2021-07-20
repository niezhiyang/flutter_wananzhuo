import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:provider/provider.dart';

import 'page/wan.dart';
import 'setting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(providers: [
    // 更改主题颜色的
    ChangeNotifierProvider(create: (_) => ThemeState()),
    ChangeNotifierProvider(create: (_) => User()),
  ], child: const WanApp()));
}
