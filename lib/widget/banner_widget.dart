import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:provider/provider.dart';

import '../helper/image_helper.dart';
import '../res/color_res.dart';
import '../utils/log_util.dart';

///Banner控件
class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ZTLifecycleState<BannerWidget> {
  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(BannerViewModel());
  }

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
          color: viewModel.index == i ? ColorRes.themeMain : Colors.grey,
        ),
      ));
    }
    return children;
  }

  ///pageView
  Widget pageView() {
    return Consumer<BannerViewModel>(builder: (context, viewModel, child) {
      return PageView.builder(
        controller: viewModel.controller,
        itemBuilder: (BuildContext context, int index) {
          Logger.log("itemBuilder--index:$index");

          if (viewModel.dataArray.isNotEmpty) {
            Logger.log("---------viewModel.index:${viewModel.index}");
            return ImageHelper.load(
                viewModel.dataArray[index % viewModel.dataArray.length],
                fit: BoxFit.fitWidth);
          } else {
            return Container();
          }
        },
        onPageChanged: (int index) {
          Logger.log("onPageChanged--index:$index");
          viewModel.onPageChanged(index);
        },
        itemCount: viewModel.itemCount,
      );
    });
  }
}

///BannerViewModel
class BannerViewModel extends ChangeNotifier with WidgetLifecycleObserver {
  ///循环数量
  final int _loopCount = 10;

  ///循环下标
  int _loopIndex = 0;

  ///切换时间
  final Duration _duration = const Duration(milliseconds: 1500);

  ///banner数据列表
  List _dataArray = [];

  List get dataArray => _dataArray;

  set dataArray(List value) {
    _dataArray = value;
    _loopIndex = _resumeMidIndex();
    startLoop();
    notifyListeners();
  }

  ///控制器
  PageController controller = PageController();

  ///Timer
  Timer? _timer;

  ///开始定时器
  void startLoop() {
    _timer ??= Timer.periodic(_duration, (timer) {
      ///下一页
      controller.nextPage(duration: _duration, curve: Curves.linear);
      //controller.jumpToPage(_loopIndex++);
      //_setLoopIndex(_loopIndex++);
    });
  }

  ///取消定时器
  void stopLoop() {
    _timer?.cancel();
  }

  ///设置loop下标
  void _setLoopIndex(int index) {
    ///到达第一个数据
    if (index == 0) index = _resumeMidIndex();

    ///到达最后一个数据
    if (index == _loopCount - 1) index = _resumeMidIndex(end: true);

    _loopIndex = index;
    controller.jumpToPage(_loopIndex);
    notifyListeners();
  }

  ///恢复到中间下标
  ///依据条件数据 开始/结束 处
  ///默认恢复到数据开始下标
  int _resumeMidIndex({bool end = false}) {
    ///除后取整
    int minIndex = _loopCount ~/ 2;

    ///余数
    int remainder = minIndex % _dataArray.length;

    ///1.恢复到开始：减去余数
    if (!end) {
      minIndex = minIndex - remainder;
    }

    ///2.恢复到结束：减去余数 - 1（再往前一个）
    if (end) {
      minIndex = minIndex - remainder - 1;
    }
    return minIndex;
  }

  ///销毁/释放资源
  void destroy() {
    controller.dispose();
    stopLoop();
  }

  ///PageView页面更新
  void onPageChanged(int index) {
    _setLoopIndex(index);
  }

  ///实际下标值
  int get index => _dataArray.isEmpty ? 0 : _loopIndex % _dataArray.length;

  ///item数量
  int get itemCount => _loopCount;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onStop) {
      destroy();
    }
  }
}
