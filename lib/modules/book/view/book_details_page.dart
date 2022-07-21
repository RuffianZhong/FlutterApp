import 'package:flutter/material.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/res/color_res.dart';

import '../../../generated/l10n.dart';
import '../../../utils/screen_util.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  initState() {
    super.initState();
    //getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: CustomScrollView(slivers: [
      ///SliverAppBarWidget
      SliverAppBarWidget(),

      ///SliverListWidget
      SliverListWidget()
    ]));
  }
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
      leading: const Icon(Icons.arrow_back),

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
          background: backgroundWidget(),
        );
      }),
    );
  }

  ///依据收缩状态显示隐藏组件
  Widget shrinkAnimatedOpacity(Widget child) {
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: shrink ? 1.0 : 0.0,
        child: child);
  }

  Widget backgroundWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///顶部间距
        SizedBox(height: shrinkHeight),

        ///教程信息
        Container(
          padding: const EdgeInsets.only(left: 40, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///封面
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ImageHelper.network(
                      "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg",
                      height: 150,
                      width: 120,
                      fit: BoxFit.fill)),

              const SizedBox(width: 14),

              ///书本信息
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///标题
                  Text(
                    "行文本说明标题",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  ///作者
                  Text(
                    "作者",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  ///简介
                  Text(
                      "简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介简介",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis),
                ],
              ))
            ],
          ),
        ),

        ///底部文本
        Container(
          padding: const EdgeInsets.only(top: 10, left: 40, right: 20),
          child: Text(
            "行文本说明",
            style: TextStyle(fontSize: 14, color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
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
        return itemWidget();
      }, childCount: 30),
    );
  }

  Widget itemWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///标题
          Text("1.章节标题", style: const TextStyle(fontSize: 16)),

          const SizedBox(width: 10),

          ///未开始学习
          Offstage(
            offstage: true,
            child: Text(S.of(context).learn_no,
                style:
                    const TextStyle(fontSize: 16, color: ColorRes.tContentSub)),
          ),

          ///进度
          Offstage(
              offstage: false,
              child: Row(
                children: [
                  ///进度文本
                  Text(S.of(context).learn_progress(20),
                      style: const TextStyle(
                          fontSize: 14, color: ColorRes.themeMain)),

                  const SizedBox(width: 4),

                  ///进度条
                  Expanded(
                      child: LinearProgressIndicator(
                    value: 0.2,
                    color: ColorRes.themeMain,
                    backgroundColor: Colors.grey[300],
                  )),

                  const SizedBox(width: 4),

                  ///时间
                  Text("2022-7-2 20:20:00",
                      style: const TextStyle(
                          fontSize: 14, color: ColorRes.tContentSub)),
                ],
              )),

          ///分割线
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 10),
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }
}
