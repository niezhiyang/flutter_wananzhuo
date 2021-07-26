import 'package:flutter/material.dart';
import 'package:flutter_wananzhuo/router.dart';
import 'package:flutter_wananzhuo/setting.dart';
import 'package:flutter_wananzhuo/toast/toast.dart';
import 'package:provider/src/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();

  static void push(BuildContext context) {
    Navigator.pushNamed(context, RouterInit.search);
  }
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBarDelegate());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Center(
        child: Text("搜索"),
      ),
    );
  }
}

typedef SearchItemCall = void Function(String item);

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放清除按钮
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, "");
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //点击了搜索显示的页面
    return Center(
      child: Text('123'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    return SearchContentView();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeConstans.themeList[context.read<ThemeState>().colorIndex];
  }
}

class SearchContentView extends StatefulWidget {
  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '大家都在搜',
            style: TextStyle(fontSize: 16),
          ),
          SearchItemView(),
          Text(
            '历史记录',
            style: TextStyle(fontSize: 16),
          ),
          SearchItemView()
        ],
      ),
    );
  }
}

class SearchItemView extends StatefulWidget {
  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items = [
    'index',
    'order',
    'main',
    '123123',
    '5test',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        // runSpacing: 0,
        children: items.map((item) {
          return SearchItem(title: item);
        }).toList(),
      ),
    );
  }
}

class SearchItem extends StatefulWidget {
  final String title;

  const SearchItem({Key? key, required this.title}) : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Chip(
          label: Text(widget.title),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () {
          Toast.show(widget.title);
        },
      ),
      color: Colors.white,
    );
  }
}
