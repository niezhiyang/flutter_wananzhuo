// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_wananzhuo/main.dart';

void getNet() {
  print("sssssss");
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    Paint2 paint2 = const Paint2(1);
    paint2.swim();
    Paint2 paint3 = const Paint2(1);
    print(paint2.hashCode == paint3.hashCode);
    String sssss = "ssss";
  });
}

typedef CallBack = Function(int postion);

typedef void F(int a, String b);

void getMoney(int pstion) {}

int getMoney2(int pstion) {
  return 2;
}

class Man {
  void log(CallBack callBack, Function(int postion) money) {}
}

void getMo([int i = 0, int j = 1, String name = ""]) {}

void getMo2({int i = 0, int j = 1, String name = ""}) {}

class Paint {
  int? x;
  int? y;

  // 普通构造方法
  Paint(this.x, this.y);

  // 命名构造
  Paint.name(this.y) {
    print(y);
  }

  Paint.name2(this.x);

  // 参数列表初始化
  Paint.fromMap(Map map)
      : x = map["x"],
        y = map["y"];

  // 重定向构造
  Paint.chong() : this(0, 0);

  // 重定向构造
  Paint.chong2() : this.fromMap(Map());

  factory Paint.of() => Paint(1, 2);

  // 工厂构造方法
  factory Paint.from() {
    // 这里也可以返回子类
    return Paint(1, 2);
  }

  // 可以重载操作符号
  String operator +(Paint other) {
    // + 号前面的可以使用当前的属性， 后面的是 第二个
    return "$x${other.x}";
  }
}

mixin Swimming {
  // 不能有构造方法
  void swim() {}
}

class Paint2 with Swimming {
  final int? x;

  // 如果传递的参数一样表示 同一个对象
  const Paint2(this.x);

  void getHash() {
    Paint2 a = const Paint2(1);
    Paint2 b = const Paint2(1);
    a == b; // 是同一个对象

    Paint aaa = Paint(1, 2);
    Paint bbb = Paint(1, 2);
    var c = aaa + bbb;
  }

  @override
  void swim() {

  }
}
