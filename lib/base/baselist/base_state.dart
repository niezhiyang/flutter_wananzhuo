import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wananzhuo/base/baselist/base_list_model.dart';
import 'package:flutter_wananzhuo/base/provider_widget.dart';
import 'package:flutter_wananzhuo/constans/easy_listview.dart';
import 'package:flutter_wananzhuo/view/load_layout.dart';
import 'package:flutter_wananzhuo/view/wan_refresh.dart';

import 'base_list_viewmodel.dart';

// class BaseState extends StatefulWidget {
//   BaseState({Key? key}) : super(key: key);
//   @override
//   BaseListState<BaseState> createState() => BaseListState<BaseState>();
// }
///  VM 是 ViewModel ， M 是 model，也就是数据
abstract class BaseListState<T extends StatefulWidget,
    VM extends BaseListViewModel<M, BaseListMode<M>>, M> extends State<T> with AutomaticKeepAliveClientMixin{
  bool loadMore = true;
  bool refresh = true;

  //真实获取数据的仓库
  late VM _viewModel;

  VM get viewModel{
    return _viewModel;
  }
  set viewModel(VM model){
    _viewModel = model;
  }

  /// 初始化ViewModel
  VM initViewModel();


  Widget getChild();

  /// 初始化一些东西，比如是否支持下拉数显
  void init();

  @override
  void initState() {
    _viewModel = initViewModel();
    super.initState();
    init();


  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<VM>(
      model: viewModel,
      onModelInit: (viewModel) {
        viewModel.refresh();
      },
      builder: (context, VM viewmodel, child) {
        Logger.e("ProviderWidget", tag: "BaseListState");
        return LoadLayout(
          EasyRefresh(
            controller: viewModel.controller,
            onRefresh: () async {
              viewModel.refresh();
            },
            onLoad: viewModel.onLoad,
            header: loadMore
                ? ClassicalHeader(
                    refreshText: ConstansListView.pullToRefresh,
                    refreshReadyText: ConstansListView.releaseToRefresh,
                    refreshingText: ConstansListView.refreshing,
                    refreshedText: ConstansListView.refreshed,
                    refreshFailedText: ConstansListView.refreshFailed,
                    noMoreText: ConstansListView.noMore,
                    infoText: ConstansListView.updateAt,
                  )
                : null,
            footer: refresh
                ? ClassicalFooter(
                    loadText: ConstansListView.pushToLoad,
                    loadReadyText: ConstansListView.releaseToLoad,
                    loadingText: ConstansListView.loading,
                    loadedText: ConstansListView.loaded,
                    loadFailedText: ConstansListView.loadFailed,
                    noMoreText: ConstansListView.noMore,
                    infoText: ConstansListView.updateAt,
                  )
                : null,
            child: getChild(),
          ),
          errorRetry: viewModel.retry,
          loadStatus: viewModel.viewState,
        );
      },
    );
  }
  @override
  bool get wantKeepAlive => true;
}
