import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:flutter_wan_android/modules/project/view_model/project_item_view_model.dart';
import 'package:flutter_wan_android/modules/project/view_model/project_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';

class MainProjectPage extends StatefulWidget {
  const MainProjectPage({Key? key}) : super(key: key);

  @override
  State<MainProjectPage> createState() => _MainProjectPageState();
}

class _MainProjectPageState extends ZTLifecycleState<MainProjectPage>
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

    return Consumer<ProjectViewModel>(builder: (context, viewModel, child) {
      _buildContext = context;
      return DefaultTabController(
        length: viewModel.projectList.length,
        child: Scaffold(
          body: bodyContent(context, viewModel),
          appBar: appBar(context, viewModel),
        ),
      );
    });
  }

  AppBar appBar(BuildContext context, ProjectViewModel viewModel) {
    return AppBar(
      title: TabBar(
        isScrollable: true,
        tabs: List.generate(viewModel.projectList.length, (index) {
          return Tab(child: Text(viewModel.projectList[index].name));
        }),
      ),
    );
  }

  Widget bodyContent(BuildContext context, ProjectViewModel viewModel) {
    return TabBarView(
        children: List.generate(viewModel.projectList.length, (index) {
      return TabBarViewItemPage(viewModel.projectList[index].id);
    }));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      _buildContext.read<ProjectViewModel>().getProjectTree(this);
    }
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
