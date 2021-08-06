import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/page/demologin/book_model.dart';
import 'package:flutter_wananzhuo/page/demologin/book_viewmodel.dart';
import 'package:provider/provider.dart';

/**
 *  @author niezhiyang
 *  since 8/6/21
 */
class FlutterBook extends StatefulWidget {
  FlutterBook({Key? key}) : super(key: key);

  @override
  _FlutterBookState createState() => _FlutterBookState();
}

class _FlutterBookState extends State<FlutterBook> {
  final BookViewModel _viewModel = BookViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MVVM的demo'),
      ),
      // body: _useValueListenableBuilderBody(),
      body: _useProviderBody(),
    );
  }

  /// 使用ValueListenableBuilder
  Widget _useValueListenableBuilder() {
    return ValueListenableBuilder<BookModel>(
      valueListenable: _viewModel,
      builder: (BuildContext context, BookModel model, Widget? child) {
        return _bodyChild(model);
      },
    );
  }
  /// 使用ChangeNotifierProvider
  Widget _useProviderBody() {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      child: Consumer<BookViewModel>(
          builder: (context, BookViewModel viewModel, child) {
        BookModel model = viewModel.value;
        return _bodyChild(model);
      }),
    );
  }

  Widget _bodyChild(BookModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          child: IndexedStack(
            alignment: Alignment.center,
            index: model.loadState,
            children: [
              const CircularProgressIndicator(),
              Text(
                "名字是:${model.name ?? ""} , 作者是:${model.author ?? ""}",
              ),
              InkWell(
                child: Image.asset("assets/img/net_error.jpg"),
                onTap: _viewModel.getData,
              )
            ],
          ),
        ),
        Container(
            margin:
                const EdgeInsets.only(top: 50, left: 50, right: 50, bottom: 0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
              elevation: 3,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Theme.of(context).primaryColor,
              minWidth: 60,
              onPressed: _viewModel.getData,
              child: const Text("请求数据",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            )),
      ],
    );
  }
}
