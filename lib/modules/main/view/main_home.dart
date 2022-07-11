import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/route_config.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/main/view/item_content_widget.dart';
import 'package:flutter_wan_android/modules/search/view/search_page.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/lifecycle/zt_lifecycle.dart';
import '../../../utils/screen_util.dart';
import 'banner_widget.dart';

List<String> imageUrl = [
  "https://img2.baidu.com/it/u=1994380678,3283034272&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=d57830e0ca280cc0f87fdbf10b25305b",
  "https://img2.baidu.com/it/u=2860188096,638334621&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=cc435e450717a2beb0623dd45752f75f",
  "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=1d3fe5d6db1996aa3b45c8636347869d",
  "https://img2.baidu.com/it/u=4244269751,4000533845&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=9e3bbec87e572ee9bf269a018c71e0ac",
  "https://img1.baidu.com/it/u=2029513305,2137933177&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=fc9d00fc14a8feeb19be958ba428ecba",
];

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends ZTLifecycleState<MainHomePage>
    with WidgetLifecycleObserver, AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    getLifecycle().addObserver(this);
    scrollController.addListener(() {
      context.read<HomeViewModel>().quickToTop =
          scrollController.offset >= ScreenUtil.get().screenHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: bodyContent(),
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget bodyContent() {
    EasyRefreshController controller = EasyRefreshController();

    return EasyRefresh(
      child: CustomScrollView(
        slivers: [
          SliverAppBarWidget(),
          SliverListWidget(),
        ],
        controller: scrollController,
      ),
      controller: controller,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2), () {
          //controller.callRefresh();
          // controller.finishRefresh();
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2), () {
          //   controller.callLoad();
          //  controller.finishLoad();
        });
      },
    );
  }

  Widget floatingActionButton() {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      return FloatingActionButton(
          child: Icon(viewModel.quickToTop ? Icons.arrow_upward : Icons.search),
          onPressed: () {
            if (viewModel.quickToTop) {
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceIn);
            } else {
              Fluttertoast.showToast(msg: "搜索");
              nav2SearchPage();
            }
          });
    });
  }

  void nav2SearchPage() {
 /*   RouterHelper.pushNamed(context, RouteConfig.searchPage,
        arguments: {"name": "测试名称"});*/
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchPage();
    }));
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    Logger.log("onStateChanged:$state");
    if (state == WidgetLifecycleState.onCreate) {
      /// 首帧绘制完成
      /// 初始化数据
      BannerViewModel viewModel = context.read<BannerViewModel>();
      viewModel.dataArray = imageUrl;
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
          title: shrinkAnimatedOpacity(const Text("Flutter")),
          background: bannerWidget(),
        );
      }),

      ///搜索按钮
      actions: [
        shrinkAnimatedOpacity(
            IconButton(icon: const Icon(Icons.search), onPressed: () {})),
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

  Widget bannerWidget() {
    return const BannerWidget();
  }
}

///SliverListWidget
class SliverListWidget extends StatefulWidget {
  const SliverListWidget({Key? key}) : super(key: key);

  @override
  State<SliverListWidget> createState() => _SliverListWidgetState();
}

class _SliverListWidgetState extends State<SliverListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return ItemContentWidget(index: index);
      }, childCount: 10),
    );
  }
}

class HomeViewModel extends ChangeNotifier {
  ///快速回到顶部
  bool _quickToTop = false;

  bool get quickToTop => _quickToTop;

  set quickToTop(bool value) {
    _quickToTop = value;
    notifyListeners();
  }
}
