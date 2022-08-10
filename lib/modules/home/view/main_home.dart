import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:flutter_wan_android/modules/collect/model/collect_model.dart';
import 'package:flutter_wan_android/modules/home/view_model/home_view_model.dart';
import 'package:flutter_wan_android/modules/home/widget/banner_widget.dart';
import 'package:flutter_wan_android/widget/loading_dialog_helper.dart';
import 'package:provider/provider.dart';

import '../../../core/net/http_result.dart';
import '../../../generated/l10n.dart';
import '../../../utils/screen_util.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with Lifecycle, AutomaticKeepAliveClientMixin {
  final HomeViewModel homeViewModel = HomeViewModel();
  ScrollController scrollController = ScrollController();
  late BuildContext buildContext;
  late EasyRefreshController _controller;

  @override
  initState() {
    super.initState();
    getLifecycle().addObserver(homeViewModel);
    scrollController.addListener(() {
      buildContext.read<HomeViewModel>().quickToTop =
          scrollController.offset >= ScreenUtil.get().screenHeight;
    });
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => homeViewModel)],
      builder: (context, child) {
        buildContext = context;
        return Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              body: bodyContent(context, viewModel),
              floatingActionButton: floatingActionButton(viewModel),
            );
          },
        );
      },
    );
  }

  ///悬浮按钮事件
  void actionFloatingButton(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.quickToTop) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
    } else {
      RouterHelper.pushNamed(context, RouterConfig.searchPage);
    }
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getContentList(
      BuildContext context, HomeViewModel viewModel, bool refresh) async {
    return await viewModel.getArticleList(refresh);
  }

  ///内容控件
  Widget bodyContent(BuildContext context, HomeViewModel viewModel) {
    return EasyRefresh.builder(
      childBuilder: (context, physics) {
        return CustomScrollView(
          physics: physics,
          slivers: [
            const SliverAppBarWidget(),
            SliverListWidget(viewModel.articleTopList, true),
            SliverListWidget(viewModel.articleList, false),
          ],
          controller: scrollController,
        );
      },
      onRefresh: () async {
        await getContentList(context, viewModel, true);
      },
      onLoad: () async {
        await getContentList(context, viewModel, false);
      },
    );
  }

  ///悬浮按钮控件
  Widget floatingActionButton(HomeViewModel viewModel) {
    return FloatingActionButton(
        child: Icon(viewModel.quickToTop ? Icons.arrow_upward : Icons.search),
        onPressed: () => actionFloatingButton(context, viewModel));
  }

  @override
  bool get wantKeepAlive => true;
}

///SliverAppBarWidget
class SliverAppBarWidget extends StatefulWidget {
  const SliverAppBarWidget({Key? key}) : super(key: key);

  @override
  State<SliverAppBarWidget> createState() => _SliverAppBarWidgetState();
}

class _SliverAppBarWidgetState extends State<SliverAppBarWidget> {
  double expandedHeight = 250;

  ///是否已经折叠
  bool shrink = false;

  ///折叠的高度
  final shrinkHeight =
      ScreenUtil.get().statusBarHeight + ScreenUtil.get().appBarHeight;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      ///展开｜折叠 高度
      expandedHeight: expandedHeight,
      pinned: true,

      ///展开｜折叠 内容
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        shrink = constraints.biggest.height == shrinkHeight;

        return FlexibleSpaceBar(
          centerTitle: true,
          title: shrinkAnimatedOpacity(Text(S.of(context).tab_home)),
          background: bannerWidget(),
        );
      }),

      ///搜索按钮
      actions: [
        /*shrinkAnimatedOpacity(IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                RouterHelper.pushNamed(context, RouterConfig.searchPage))),*/
      ],
    );
  }

  ///依据收缩状态显示隐藏组件
  Widget shrinkAnimatedOpacity(Widget child) {
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: shrink ? 1.0 : 0.0,
        child: child);
  }

  ///banner
  Widget bannerWidget() {
    return const BannerWidget();
  }
}

///SliverListWidget
class SliverListWidget extends StatefulWidget {
  ///数据列表
  final List<ArticleEntity> list;

  ///是否置顶的列表
  final bool isTop;

  const SliverListWidget(this.list, this.isTop, {Key? key}) : super(key: key);

  @override
  State<SliverListWidget> createState() => _SliverListWidgetState();
}

class _SliverListWidgetState extends State<SliverListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return ItemArticleWidget(
          article: widget.list[index],
          onTapCollect: () => actionCollect(index),
        );
      }, childCount: widget.list.length),
    );
  }

  ///收藏/取消收藏 动作
  void actionCollect(int index) async {
    ArticleEntity article = widget.list[index];

    ///当前收藏状态
    bool collected = article.collect != null && article.collect!;

    if (collected) {
      //取消收藏
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).tips_msg),
              content: Text(S.of(context).collect_content),
              actions: [
                TextButton(
                    onPressed: () => RouterHelper.pop(context, 0),
                    child: Text(S.of(context).cancel)),
                TextButton(
                    onPressed: () => RouterHelper.pop(context, 1),
                    child: Text(S.of(context).confirm))
              ],
            );
          }).then((value) {
        if (value == 1) {
          collectLogic(index);
        }
      });
    } else {
      //收藏
      collectLogic(index);
    }
  }

  ///收藏/取消收藏 逻辑
  void collectLogic(int index) async {
    LoadingDialogHelper.showLoading(context);

    ArticleEntity article = widget.list[index];

    ///当前收藏状态
    bool collected = article.collect != null && article.collect!;

    HomeViewModel viewModel = context.read<HomeViewModel>();

    CollectModel()
        .collectOrCancelArticle(article.id, !collected)
        .then((result) {
      if (result.success) {
        article.collect = !collected;
        widget.list[index] = article;
        if (widget.isTop) {
          viewModel.articleTopList = widget.list;
        } else {
          viewModel.articleList = widget.list;
        }
      }
    }).whenComplete(() => LoadingDialogHelper.dismissLoading(context));
  }
}
