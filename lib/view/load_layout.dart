import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const loadingStr = "加载中...";
const loadErrorStr = "加载失败，点我重试";
const loadEmptyStr = "暂无数据，请稍后重试";

typedef OnRetryClick = void Function();
enum LoadStatus {
  loading,
  netError,
  content,
  empty,
}

class LoadLayout extends StatefulWidget {
  final Widget child;
  LoadStatus? loadStatus;
  final OnRetryClick errorRetry; //错误事件处理
  LoadLayout(this.child, {
    Key? key,
    this.loadStatus,
    required this.errorRetry,
  }) : super(key: key);

  @override
  _LoadLayoutState createState() => _LoadLayoutState();
}

class _LoadLayoutState extends State<LoadLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IndexedStack(
          alignment: AlignmentDirectional.center,
          index: _getLoadState(),
          children: [
            Container(
              width: 100,
              height: 100,
              // color: Colors.black38,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular((10.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SpinKitCircle(
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    loadingStr,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            widget.child,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "assets/img/net_error.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: 35,
                    child: MaterialButton(
                      elevation: 3,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      color: Colors.lightBlueAccent,
                      minWidth: 60,
                      onPressed: () {
                        setState(() {
                          widget.loadStatus = LoadStatus.loading;
                        });
                        widget.errorRetry.call();
                      },
                      child: const Text(loadErrorStr,
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    )),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/net_empty.png", width: 100,
                  height: 100,),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  loadEmptyStr,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getLoadState() {
    int index = 0;
    if (widget.loadStatus != null) {
      switch (widget.loadStatus) {
        case LoadStatus.loading:
          index = 0;
          break;
        case LoadStatus.netError:
          index = 2;
          break;
        case LoadStatus.content:
          index = 1;
          break;
        case LoadStatus.empty:
          index = 3;
          break;
      }
    }

    return index;
  }
}
