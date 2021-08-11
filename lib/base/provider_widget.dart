import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  //控件对应的数据
  final T model;
  final Widget? child;

  //绑定数据的控件
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  //数据初始化方法
  final Function(T)? onModelInit;
  const ProviderWidget(
      {Key? key,
      required this.model,
      required this.builder,
      this.onModelInit,
      this.child})
      : super(key: key);

  @override
  _ProviderWidgetState createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    if (widget.onModelInit != null) {
      widget.onModelInit!(model);
    }
  }

  /// 使用 ChangeNotifierProvider 做桥梁
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => model,
      child: Consumer<T>(builder: widget.builder, child: widget.child),
    );
  }
}
