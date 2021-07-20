import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_wananzhuo/banner/round.dart';
import 'package:flutter_wananzhuo/net/repository/user_repository.dart';

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
              "登录",
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
              onPressed: () {
                _userRep.login("nzyandroid","nzyandroid");
              },
              child: const Text("登录"),
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
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
