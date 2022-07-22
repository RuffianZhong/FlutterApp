import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/net/cancel/http_canceler.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';
import 'package:flutter_wan_android/modules/main/model/collect_model.dart';
import 'package:flutter_wan_android/modules/main/view/item_content_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/lifecycle/zt_lifecycle.dart';
import '../../../core/net/http_result.dart';
import '../../../generated/l10n.dart';
import '../../../utils/log_util.dart';
import '../../../utils/screen_util.dart';
import '../view_model/home_view_model.dart';
import 'banner_widget.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends ZTLifecycleState<MainHomePage>
    with WidgetLifecycleObserver, AutomaticKeepAliveClientMixin {
  late BuildContext _buildContext;
  late HttpCanceler canceler;

  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    getLifecycle().addObserver(this);
    canceler = HttpCanceler(this);
    scrollController.addListener(() {
      context.read<HomeViewModel>().quickToTop =
          scrollController.offset >= ScreenUtil.get().screenHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        _buildContext = context;
        return Scaffold(
          body: bodyContent(context, viewModel),
          floatingActionButton: floatingActionButton(viewModel),
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
    viewModel.getArticleTopList(refresh, canceler);
    return await viewModel.getArticleList(refresh, canceler);
  }

  ///内容控件
  Widget bodyContent(BuildContext context, HomeViewModel viewModel) {
    EasyRefreshController controller = EasyRefreshController();

    return EasyRefresh(
      controller: controller,
      onRefresh: () async {
        await getContentList(context, viewModel, true);
      },
      onLoad: () async {
        await getContentList(context, viewModel, false);
      },
      child: CustomScrollView(
        slivers: [
          const SliverAppBarWidget(),
          SliverListWidget(viewModel.articleTopList, true),
          SliverListWidget(viewModel.articleList, false),
        ],
        controller: scrollController,
      ),
    );
  }

  ///悬浮按钮控件
  Widget floatingActionButton(HomeViewModel viewModel) {
    return FloatingActionButton(
        child: Icon(viewModel.quickToTop ? Icons.arrow_upward : Icons.search),
        onPressed: () => actionFloatingButton(context, viewModel));
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      /// 首帧绘制完成
      /// 初始化数据
      HomeViewModel viewModel = _buildContext.read<HomeViewModel>();
      getContentList(context, viewModel, true);
    }
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
        shrinkAnimatedOpacity(IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                RouterHelper.pushNamed(context, RouterConfig.searchPage))),
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
        return ItemContentWidget(
          article: widget.list[index],
          onTapCollect: () {
            actionCollect(index);
          },
        );
      }, childCount: widget.list.length),
    );
  }

  void actionCollect(int index) async {
    ArticleEntity article = widget.list[index];

    ///当前收藏状态
    bool collected = article.collect != null && article.collect!;

    HomeViewModel viewModel = context.read<HomeViewModel>();

    CollectModel model = CollectModel();
    HttpResult result = await (collected
        ? model.unCollectArticle(article.id)
        : model.collectArticle(article.id));

    if (result.success) {
      article.collect = !collected;
      widget.list[index] = article;
      if (widget.isTop) {
        viewModel.articleTopList = widget.list;
      } else {
        viewModel.articleList = widget.list;
      }
    }
  }
}
