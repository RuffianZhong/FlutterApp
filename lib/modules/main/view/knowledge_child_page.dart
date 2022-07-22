import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/main/model/knowledge_model.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
import '../model/article_entity.dart';
import '../model/category_entity.dart';
import 'item_content_widget.dart';

class KnowledgeChildPage extends StatefulWidget {
  const KnowledgeChildPage({Key? key}) : super(key: key);

  @override
  State<KnowledgeChildPage> createState() => _KnowledgeChildPageState();
}

class _KnowledgeChildPageState extends ZTLifecycleState<KnowledgeChildPage> {
  ///一级分类信息
  late CategoryEntity category;

  ///二级分类列表
  late List<CategoryEntity> childCategoryList;

  ///默认选中下标
  late int index;

  void initData(BuildContext context) {
    Map<String, dynamic> json = RouterHelper.argumentsMap(context);
    category = CategoryEntity.fromJson(jsonDecode(json['entity']));
    index = json["index"] as int;
    childCategoryList = category.childList ?? [];
  }

  @override
  Widget build(BuildContext context) {
    initData(context);
    return DefaultTabController(
      initialIndex: index,
      length: childCategoryList.length,
      child: Scaffold(
        body: bodyContent(context),
        appBar: appBar(context),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      ///返回按钮
      leading: GestureDetector(
          onTap: () => RouterHelper.pop(context),
          child: const Icon(Icons.arrow_back)),
      title: Text(category.name),
      bottom: TabBar(
        isScrollable: true,
        tabs: List.generate(childCategoryList.length, (index) {
          return Tab(child: Text(childCategoryList[index].name));
        }),
      ),
    );
  }

  Widget bodyContent(BuildContext context) {
    return TabBarView(
        children: List.generate(childCategoryList.length, (index) {
      return TabBarViewItemPage(childCategoryList[index].id);
    }));
  }
}

class ProjectItemViewModel extends ChangeNotifier {
  KnowledgeModel model = KnowledgeModel();

  ///数据页面下标
  int pageIndex = 0;

  ///文章列表
  List<ArticleEntity> _articleList = [];

  List<ArticleEntity> get articleList => _articleList;

  set articleList(List<ArticleEntity> value) {
    _articleList = value;
    notifyListeners();
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getArticleList(
      int projectId, bool refresh, HttpCanceler canceler) async {
    ///下拉刷新，下标从0开始
    if (refresh) pageIndex = 0;
    HttpResult<ArticleEntity> result =
        await model.getCategoryArticleList(projectId, pageIndex, canceler);
    if (result.success) {
      if (refresh) articleList.clear();
      articleList.addAll(result.list!);
      articleList = articleList;
      pageIndex++;
    }
    return result;
  }
}

class TabBarViewItemPage extends StatefulWidget {
  ///项目分类ID
  final int projectId;

  const TabBarViewItemPage(this.projectId, {Key? key}) : super(key: key);

  @override
  State<TabBarViewItemPage> createState() => _TabBarViewItemPageState();
}

class _TabBarViewItemPageState extends ZTLifecycleState<TabBarViewItemPage>
    with AutomaticKeepAliveClientMixin, WidgetLifecycleObserver {
  late BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    EasyRefreshController controller = EasyRefreshController();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectItemViewModel())
      ],
      child: Consumer<ProjectItemViewModel>(
        builder: (context, viewModel, child) {
          _buildContext = context;
          return EasyRefresh(
            controller: controller,
            onRefresh: () async {
              getContentList(context, viewModel, true);
            },
            onLoad: () async {
              getContentList(context, viewModel, false);
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ItemContentWidget(article: viewModel.articleList[index]);
              },
              itemCount: viewModel.articleList.length,
            ),
          );
        },
      ),
    );
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getContentList(BuildContext context,
      ProjectItemViewModel viewModel, bool refresh) async {
    return await viewModel.getArticleList(
        widget.projectId, refresh, HttpCanceler(this));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      getContentList(
          _buildContext, _buildContext.read<ProjectItemViewModel>(), true);
    }
  }
}
