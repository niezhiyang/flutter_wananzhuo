import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';
import 'package:flutter_wananzhuo/utils/screen_util.dart';
import 'package:provider/provider.dart';

import 'page/wan.dart';
import 'setting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SizeUtil.initialize();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(providers: [
    // 更改主题颜色的
    ChangeNotifierProvider(create: (_) => ThemeState()),
    ChangeNotifierProvider(create: (_) => User()),
  ], child:  WanApp()));
}



// ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// I/flutter (24046): E/[extension_util.dart, 77] :  │ physicalWidth 1080.0 ---- physicalHeight 2210.0
// I/flutter (24046): E/[extension_util.dart, 77] :  └────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
// I/flutter (24046): E/[extension_util.dart, 78] :  ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// I/flutter (24046): E/[extension_util.dart, 78] :  │ dpi 2.75

// 没 bar physicalWidth 1080.0 ---- physicalHeight 2340.0