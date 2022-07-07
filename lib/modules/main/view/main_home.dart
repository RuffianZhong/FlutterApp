import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:provider/provider.dart';

import '../../../core/lifecycle/zt_lifecycle.dart';
import '../../../generated/l10n.dart';
import '../../../res/color_res.dart';
import '../../../utils/screen_util.dart';

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
  @override
  initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: bodyContent(),
    );
  }

  Widget bodyContent() {
    EasyRefreshController? controller = EasyRefreshController();
    return EasyRefresh(
      controller: controller,
      child: CustomScrollView(
        slivers: [
          SliverAppBarWidget(),
          SliverListWidget(),
        ],
      ),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              controller.finishRefresh();
            });
          }
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              controller.finishLoad();
            });
          }
        });
      },
    );
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
  bool get wantKeepAlive => false;
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
          /* background: ImageHelper.load(imageUrl[0], fit: BoxFit.fitWidth),*/

          background: banner(),
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

  Widget banner() {
    return BannerWidget();
  }
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return bannerWidget();
  }

  Widget bannerWidget() {
    return Stack(
      children: [
        ///banner
        Positioned(child: pageView()),

        ///指示器
        Align(alignment: Alignment.bottomCenter, child: indicator())
      ],
    );
  }

  ///pageView
  Widget pageView() {
    return Consumer<BannerViewModel>(builder: (context, viewModel, child) {
      int dataSize = viewModel.dataArray.length;

      return PageView.builder(
        controller: viewModel.controller,
        itemBuilder: (BuildContext context, int index) {
          // Logger.log("----index:$index====:${viewModel.dataArray.length}");

          if (dataSize > 0) {
            int newIndex = index % dataSize;

            return ImageHelper.load(viewModel.dataArray[newIndex],
                fit: BoxFit.fitWidth);
          } else {
            return Container();
          }
        },
        onPageChanged: (int index) {
          Logger.log("----index:$index====:${viewModel.dataArray.length}");

          if (dataSize > 0) {
            int newIndex = index % dataSize;
            viewModel.indicatorValue = newIndex;
          }

          if (index == 0 || index == viewModel.loopCount - 1) {
            viewModel.resetLoop();
          }
        },
        // itemCount: viewModel.dataArray.length,
        itemCount: viewModel.loopCount,
      );
    });
  }

  ///指示器
  Widget indicator() {
    return Consumer<BannerViewModel>(builder: (context, viewModel, child) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: indicatorChild(viewModel));
    });
  }

  ///指示器子控件
  List<Widget> indicatorChild(BannerViewModel viewModel) {
    List<Widget> children = [];

    for (int i = 0; i < viewModel.dataArray.length; i++) {
      children.add(Container(
        padding: const EdgeInsets.all(1),
        child: Icon(
          Icons.circle,
          size: 10,
          color:
              viewModel.indicatorValue == i ? ColorRes.themeMain : Colors.grey,
        ),
      ));
    }
    return children;
  }
}

///BannerViewModel
class BannerViewModel extends ChangeNotifier {
  ///循环数量
  final int loopCount = 10;

  ///指示器下标
  int _indicatorValue = 0;

  ///banner数据列表
  List _dataArray = [];

  ///控制器
  PageController controller = PageController();

  int get indicatorValue => _indicatorValue;

  set indicatorValue(int value) {
    _indicatorValue = value;
    notifyListeners();
  }

  List get dataArray => _dataArray;

  set dataArray(List value) {
    _dataArray = value;
    resetLoop();
    notifyListeners();
  }

  void resetLoop() {
    //取整
    int minIndex = loopCount ~/ 2;
    //减去不能整除的差值
    minIndex = minIndex - minIndex % _dataArray.length;
    //定位到中间
    controller.jumpToPage(minIndex);
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
        return itemWidget(context, index);
      }, childCount: 50),
    );
  }

  Widget itemWidget(BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            ///顶部信息
            itemHeaderWidget(context, index),

            const SizedBox(height: 6),

            ///内容
            itemContentWidget(context, index),

            const SizedBox(height: 4),

            ///底部信息
            itemFooterWidget(context, index),

            ///分割线
            itemSeparatorWidget(),
          ],
        ));
  }

  Widget itemHeaderWidget(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //作者头像
        ClipOval(
          child: ImageHelper.load(imageUrl[index % 5], height: 45, width: 45),
        ),
        const SizedBox(width: 4),
        //作者昵称
        Expanded(
            child: Text(
          "作者名",
          maxLines: 1,
          style: TextStyle(fontSize: 14, color: ColorRes.tContentSub),
        )),
        const SizedBox(width: 4),
        //时间
        Text(
          "2022-20-20 12:22:22",
          style: TextStyle(fontSize: 14, color: ColorRes.tContentSub),
        ),
      ],
    );
  }

  Widget itemContentWidget(BuildContext context, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///标题
            Text(
              "",
              style: TextStyle(fontSize: 18, color: ColorRes.tContentMain),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            ///副标题
            Offstage(
                offstage: index % 5 == 2,
                child: Text(
                  "",
                  style: TextStyle(fontSize: 15, color: ColorRes.tContentSub),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        )),

        const SizedBox(width: 6),

        ///条件性展示控件
        Offstage(
            offstage: index % 5 == 2,
            child: ImageHelper.load(imageUrl[index % 5],
                height: 100, width: 70, fit: BoxFit.cover)),
      ],
    );
  }

  ///底部内容控件
  Widget itemFooterWidget(BuildContext context, int index) {
    return Row(
      children: [
        ///置顶标识
        Offstage(
            offstage: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                S.of(context).topping,
                style: TextStyle(fontSize: 12, color: ColorRes.themeMain),
              ),
              decoration:
                  BoxDecoration(border: Border.all(color: ColorRes.themeMain)),
            )),

        const SizedBox(width: 6),

        ///标签
        Expanded(
            child: Text(
          S.of(context).label_group("", ""),
          style: const TextStyle(fontSize: 14, color: ColorRes.tContentMain),
        )),

        ///收藏
        GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.favorite_border,
              color: Colors.red,
            )),
      ],
    );
  }

  ///item分割线
  Widget itemSeparatorWidget() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(top: 10),
      color: Colors.grey[300],
    );
  }
}
