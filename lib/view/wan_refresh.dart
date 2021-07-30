import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/constans/easy_listview.dart';

class WanRefresh extends EasyRefresh {
  WanRefresh({
    Key? key,
    EasyRefreshController? controller,
    OnRefreshCallback? onRefresh,
    OnLoadCallback? onLoad,
    ScrollController? scrollController,
    required Widget child,
  }) : super(
            key: key,
            controller: controller,
            onRefresh: onRefresh,
            onLoad: onLoad,
            scrollController: scrollController,
            header: ClassicalHeader(
              refreshText: ConstansListView.pullToRefresh,
              refreshReadyText: ConstansListView.releaseToRefresh,
              refreshingText: ConstansListView.refreshing,
              refreshedText: ConstansListView.refreshed,
              refreshFailedText: ConstansListView.refreshFailed,
              noMoreText: ConstansListView.noMore,
              infoText: ConstansListView.updateAt,
            ),
            footer: ClassicalFooter(
              loadText: ConstansListView.pushToLoad,
              loadReadyText: ConstansListView.releaseToLoad,
              loadingText: ConstansListView.loading,
              loadedText: ConstansListView.loaded,
              loadFailedText: ConstansListView.loadFailed,
              noMoreText: ConstansListView.noMore,
              infoText: ConstansListView.updateAt,
            ),
            child: child);
}
