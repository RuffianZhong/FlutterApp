import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/book/model/book_entity.dart';
import 'package:flutter_wan_android/utils/format_util.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../utils/screen_util.dart';
import '../model/study_entity.dart';
import '../view_model/book_details_view_model.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends ZTLifecycleState<BookDetailsPage>
    with WidgetLifecycleObserver {
  ///教程实体类
  late BookEntity book;
  late BuildContext _buildContext;

  @override
  initState() {
    super.initState();
    getLifecycle().addObserver(this);
    getLifecycle().addObserver(BookDetailsViewModel());
  }

  @override
  Widget build(BuildContext context) {
    book = RouterHelper.argumentsT(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookDetailsViewModel())
      ],
      child: Consumer<BookDetailsViewModel>(
        builder: (context, viewModel, child) {
          _buildContext = context;

          return Scaffold(
            body: CustomScrollView(slivers: [
              ///SliverAppBarWidget
              SliverAppBarWidget(book),

              ///SliverListWidget
              SliverListWidget(list: viewModel.articleList)
            ]),
          );
        },
      ),
    );
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      _buildContext.read<BookDetailsViewModel>().initData(book.id, owner);
    }
  }
}

///SliverAppBarWidget
class SliverAppBarWidget extends StatefulWidget {
  final BookEntity book;

  const SliverAppBarWidget(this.book, {Key? key}) : super(key: key);

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
      ///返回按钮
      leading: GestureDetector(
          onTap: () => RouterHelper.pop(context),
          child: const Icon(Icons.arrow_back)),

      ///展开｜折叠 高度
      expandedHeight: expandedHeight,
      pinned: true,

      ///展开｜折叠 内容
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        shrink = constraints.biggest.height == shrinkHeight;

        return FlexibleSpaceBar(
          centerTitle: true,
          title: shrinkAnimatedOpacity(Text(widget.book.name)),
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
                  child: ImageHelper.network(widget.book.cover,
                      height: 150, width: 110, fit: BoxFit.cover)),

              const SizedBox(width: 14),

              ///书本信息
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///名称
                  Text(
                    widget.book.name,
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
                    widget.book.author,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  ///简介
                  Text(widget.book.desc,
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

        ///底部文本:版权
        Container(
          padding: const EdgeInsets.only(top: 10, left: 40, right: 20),
          child: Text(
            widget.book.lisense,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
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
  final List<ArticleEntity> list;

  const SliverListWidget({Key? key, required this.list}) : super(key: key);

  @override
  State<SliverListWidget> createState() => _SliverListWidgetState();
}

class _SliverListWidgetState extends State<SliverListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return itemWidget(widget.list[index], index);
      }, childCount: widget.list.length),
    );
  }

  ///列表点击逻辑
  void actionItemClick(ArticleEntity article, int index) async {
    StudyEntity? study = article.study;

    BookDetailsViewModel viewModel = context.read<BookDetailsViewModel>();
    if (study == null) {
      ///未学习，插如学习进度数据
      viewModel.insertOrUpdateStudy(article.chapterId!, article.id, 0.0);
    }

    ///页面跳转返回浏览进度
    RouterHelper.pushNamed(context, RouterConfig.articleDetailsPage,
            arguments: article)
        .then((value) {
      ///页面返回逻辑
      if (value != null && value is double) {
        ///更新学习进度
        StudyEntity temp = viewModel.articleList[index].study!;
        if (value > temp.progress) {
          temp.progress = value;
        }

        ///更新数据/列表
        viewModel.insertOrUpdateStudy(
            temp.bookId, temp.articleId, temp.progress,
            id: temp.id);
      }
    });
  }

  ///章节列表
  Widget itemWidget(ArticleEntity article, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => actionItemClick(article, index),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///标题
            Text("${index + 1}.${article.title}",
                style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(width: 14),

            ///未开始学习
            Offstage(
              offstage: article.study != null,
              child: Text(S.of(context).learn_no,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14)),
            ),

            ///进度
            Offstage(
                offstage: article.study == null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///进度文本
                    Text(
                        S.of(context).learn_progress(article.study == null
                            ? 0
                            : FormatUtil.formatNumber(
                                "##", article.study!.progress * 100)),
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor)),

                    const SizedBox(width: 4),

                    ///进度条
                    Expanded(
                        child: LinearProgressIndicator(
                      value: article.study?.progress,
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Colors.grey[300],
                    )),

                    const SizedBox(width: 4),

                    ///时间
                    Text(
                        article.study == null
                            ? ""
                            : FormatUtil.formatMilliseconds(
                                    FormatUtil.ymdHms, article.study!.time)
                                .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12)),
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
      ),
    );
  }
}
