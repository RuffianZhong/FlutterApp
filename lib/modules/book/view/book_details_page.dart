import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/book/model/book_entity.dart';
import 'package:flutter_wan_android/res/color_res.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
import '../../../generated/l10n.dart';
import '../../../utils/log_util.dart';
import '../../../utils/screen_util.dart';
import '../../main/model/article_entity.dart';
import '../model/book_model.dart';
import '../model/study_entity.dart';

class BookDetailsViewModel extends ChangeNotifier {
  BookModel model = BookModel();

  ///文章列表
  List<ArticleEntity> _articleList = [];

  List<ArticleEntity> get articleList => _articleList;

  set articleList(List<ArticleEntity> value) {
    _articleList = value;
    notifyListeners();
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getArticleList(
      int projectId, HttpCanceler canceler) async {
    HttpResult<ArticleEntity> result =
        await model.getBookArticleList(projectId, 0, canceler);
    if (result.success) {
      _articleList.addAll(result.list!);
    }
    return result;
  }

  ///学习进度列表
  List<StudyEntity> _studyList = [];

  ///获取学习列表数据：本地数据库
  Future<List<StudyEntity>> getStudyListData(int bookId) async {
    _studyList = await model.dao.query(bookId);
    return _studyList;
  }

  ///初始化数据
  void initData(int projectId, WidgetLifecycleOwner owner) {
    ///多个 future
    Iterable<Future> futures = [
      getArticleList(projectId, HttpCanceler(owner)),
      getStudyListData(projectId)
    ];

    ///等待多个 future 执行完成
    Future.wait(futures).then((value) {
      updateStudyData(_studyList, _articleList);
    });
  }

  ///更新列表学习数据
  void updateStudyData(
      List<StudyEntity> studyList, List<ArticleEntity> articleList) {
    if (studyList.isNotEmpty && articleList.isNotEmpty) {
      StudyEntity study;
      ArticleEntity article;

      ///遍历学习进度列表
      for (int i = 0; i < studyList.length; i++) {
        study = studyList[i];

        ///遍历文章（章节列表）
        for (int j = 0; j < articleList.length; j++) {
          article = articleList[j];

          ///匹配/更新学习进度
          if (article.id == study.articleId) {
            article.study = study;
            articleList[j] = article;
            break;
          }
        }
      }
    }

    ///更新viewModel数据
    this.articleList = articleList;
  }

  ///插入或者更新数据
  Future<StudyEntity> insertOrUpdateStudy(
      int bookId, int articleId, double progress,
      {int? id}) async {
    StudyEntity study =
        await model.insertOrUpdateStudy(id: id, bookId, articleId, progress);

    updateStudyData([study], _articleList);

    return study;
  }
}

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
      Logger.log("back--------$value");

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

  Widget itemWidget(ArticleEntity article, int index) {
    return GestureDetector(
      onTap: () => actionItemClick(article, index),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///标题
            Text("${index + 1}.${article.title}",
                style: const TextStyle(fontSize: 18)),

            const SizedBox(width: 14),

            ///未开始学习
            Offstage(
              offstage: article.study != null,
              child: Text(S.of(context).learn_no,
                  style: const TextStyle(
                      fontSize: 14, color: ColorRes.tContentSub)),
            ),

            ///进度
            Offstage(
                offstage: article.study == null,
                child: Row(
                  children: [
                    ///进度文本
                    Text(
                        S.of(context).learn_progress(article.study == null
                            ? 0
                            : article.study!.progress.toInt() * 100),
                        style: const TextStyle(
                            fontSize: 14, color: ColorRes.themeMain)),

                    const SizedBox(width: 4),

                    ///进度条
                    Expanded(
                        child: LinearProgressIndicator(
                      value: article.study?.progress,
                      color: ColorRes.themeMain,
                      backgroundColor: Colors.grey[300],
                    )),

                    const SizedBox(width: 4),

                    ///时间
                    Text(
                        article.study == null
                            ? ""
                            : DateTime.fromMillisecondsSinceEpoch(
                                    article.study!.time)
                                .toString(),
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
      ),
    );
    ;
  }
}
