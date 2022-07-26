import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:flutter_wan_android/modules/knowledge/view_model/knowledge_child_view_model.dart';
import 'package:flutter_wan_android/modules/project/model/category_entity.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
import '../../article/model/article_entity.dart';

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
        ChangeNotifierProvider(create: (context) => KnowledgeChildViewModel())
      ],
      child: Consumer<KnowledgeChildViewModel>(
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
                return ItemArticleWidget(article: viewModel.articleList[index]);
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
      KnowledgeChildViewModel viewModel, bool refresh) async {
    return await viewModel.getArticleList(
        widget.projectId, refresh, HttpCanceler(this));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      getContentList(
          _buildContext, _buildContext.read<KnowledgeChildViewModel>(), true);
    }
  }
}
