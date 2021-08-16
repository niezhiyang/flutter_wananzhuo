import 'package:flutter/material.dart';
import 'package:flutter_autosize_screen/auto_size_util.dart';
import 'package:flutter_autosize_screen/binding.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/utils/screen_util.dart';
import 'package:provider/provider.dart';

import 'page/wan.dart';
import 'setting.dart';

void main() {
  // 一个极低成本的 Flutter 屏幕适配方案，直接按照设计稿写就可以了
  AutoSizeUtil.setStandard(360);
  // 替换 runApp
  runAutoApp(
    MultiProvider(providers: [
      // 更改主题颜色的
      ChangeNotifierProvider(create: (_) => ThemeState()),
      ChangeNotifierProvider(create: (_) => User()),
    ], child: WanApp())
  );
}
