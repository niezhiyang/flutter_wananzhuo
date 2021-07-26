import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../setting.dart';

/**
 *  @author niezhiyang
 *  since 2021/7/23
 */
class ColorSettingPage extends StatefulWidget {
  ColorSettingPage({Key? key}) : super(key: key);

  @override
  _ColorSettingPageState createState() => _ColorSettingPageState();
}

class _ColorSettingPageState extends State<ColorSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("设置主题")),
        body: GridView.builder(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          shrinkWrap: true,
          itemCount: ThemeConstans.themeList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5),
          itemBuilder: (BuildContext context, int index) {
            return Card(child: InkWell(
              onTap: () {
                context.read<ThemeState>().changeThemeData(index);
              },
              child: Container(
                width: 100,
                height: 100,
                color: ThemeConstans.themeList[index].primaryColor,
              ),
            ),shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),);
          },
        ));
  }
}
