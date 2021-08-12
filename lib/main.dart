import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/utils/extension_util.dart';
import 'package:flutter_wananzhuo/utils/screen_util.dart';
import 'package:provider/provider.dart';

import 'page/wan.dart';
import 'setting.dart';

void main() {
  SizeUtil.initialize();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context){
      return
        MultiProvider(providers: [
          // 更改主题颜色的
          ChangeNotifierProvider(create: (_) => ThemeState()),
          ChangeNotifierProvider(create: (_) => User()),
        ], child: WanApp());
      }, // Wrap your app
    ),

    //   MultiProvider(providers: [
    //     // 更改主题颜色的
    //     ChangeNotifierProvider(create: (_) => ThemeState()),
    //     ChangeNotifierProvider(create: (_) => User()),
    //   ], child: WanApp())
  );
}
