import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_wananzhuo/model/user_entity.dart';
import 'package:flutter_wananzhuo/net/repository/user_repository.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:flutter_wananzhuo/view/loading_dialog.dart';
import 'package:flutter_wananzhuo/view/round.dart';
import 'package:flutter_wananzhuo/wan_kit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constans.dart';
import '../setting.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? controllerName;
  UserRepository _userRep = UserRepository();
  var name = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${context.watch<User>().username ?? "请登录"}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/img/login.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              textEditingController: controllerName,
              hintText: "用户名",
              cursorColor: Colors.black,
              editTextBackgroundColor: Colors.grey[200],
              iconColor: Colors.black,
              onChanged: (value) {
                name = value;
              },
            ),
            RoundedInputField(
              textEditingController: controllerName,
              hintText: "密码",
              icon: Icons.password,
              editTextBackgroundColor: Colors.grey[200],
              onChanged: (value) {
                name = value;
              },
            ),
            MaterialButton(
              shape: const StadiumBorder(
                side: BorderSide(
                    color: Colors.red, width: 2, style: BorderStyle.solid),
              ),
              onPressed: login,
              child: const Text("登录"),
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }

  void login() {
    LoadUtil.show();
    _userRep.login("nzyandroid", "nzyandroid").then((userStr) {
      Map<String, dynamic> userMap = json.decode(userStr);
      UserBase userBase = UserBase().fromJson(userMap);
      User user = userBase.data!;
      context.read<User>().changeUser(user);
      Wankit.saveUser(user);
      Toast.show("登录成功");
      Navigator.of(context).pop();
    }).whenComplete(() {
      LoadUtil.close();
    });
  }
}

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/img/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/img/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    ));
  }
}
