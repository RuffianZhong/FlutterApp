import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'package:flutter_wan_android/generated/l10n.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:flutter_wan_android/modules/collect/model/collect_model.dart';
import 'package:flutter_wan_android/modules/project/view_model/project_item_view_model.dart';
import 'package:flutter_wan_android/modules/project/view_model/project_view_model.dart';
import 'package:flutter_wan_android/widget/loading_dialog_helper.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';

class MainProjectPage extends StatefulWidget {
  const MainProjectPage({Key? key}) : super(key: key);

  @override
  State<MainProjectPage> createState() => _MainProjectPageState();
}

class _MainProjectPageState extends State<MainProjectPage>
    with Lifecycle, AutomaticKeepAliveClientMixin {
  ProjectViewModel projectViewModel = ProjectViewModel();

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(projectViewModel);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => projectViewModel)
      ],
      builder: (context, child) {
        return Consumer<ProjectViewModel>(builder: (context, viewModel, child) {
          return DefaultTabController(
            length: viewModel.projectList.length,
            child: Scaffold(
              body: bodyContent(context, viewModel),
              appBar: appBar(context, viewModel),
            ),
          );
        });
      },
    );
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
}

class TabBarViewItemPage extends StatefulWidget {
  ///项目分类ID
  final int projectId;

  const TabBarViewItemPage(this.projectId, {Key? key}) : super(key: key);

  @override
  State<TabBarViewItemPage> createState() => _TabBarViewItemPageState();
}

class _TabBarViewItemPageState extends State<TabBarViewItemPage>
    with AutomaticKeepAliveClientMixin, Lifecycle, LifecycleObserver {
  late BuildContext _buildContext;

  late HttpCanceler httpCanceler;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectItemViewModel())
      ],
      child: Consumer<ProjectItemViewModel>(
        builder: (context, viewModel, child) {
          _buildContext = context;
          return EasyRefresh(
            onRefresh: () async {
              await getContentList(context, viewModel, true);
            },
            onLoad: () async {
              await getContentList(context, viewModel, false);
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ItemArticleWidget(
                  article: viewModel.articleList[index],
                  onTapCollect: () => actionCollect(index, viewModel),
                );
              },
              itemCount: viewModel.articleList.length,
            ),
          );
        },
      ),
    );
  }

  ///收藏/取消收藏 动作
  void actionCollect(int index, ProjectItemViewModel viewModel) async {
    ArticleEntity article = viewModel.articleList[index];

    ///当前收藏状态
    bool collected = article.collect != null && article.collect!;

    if (collected) {
      //取消收藏
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).tips_msg),
              content: Text(S.of(context).collect_content),
              actions: [
                TextButton(
                    onPressed: () => RouterHelper.pop(context, 0),
                    child: Text(S.of(context).cancel)),
                TextButton(
                    onPressed: () => RouterHelper.pop(context, 1),
                    child: Text(S.of(context).confirm))
              ],
            );
          }).then((value) {
        if (value == 1) {
          collectLogic(index, viewModel);
        }
      });
    } else {
      //收藏
      collectLogic(index, viewModel);
    }
  }

  ///收藏/取消收藏 逻辑
  void collectLogic(int index, ProjectItemViewModel viewModel) async {
    LoadingDialogHelper.showLoading(context);

    ArticleEntity article = viewModel.articleList[index];

    ///当前收藏状态
    bool collected = article.collect != null && article.collect!;

    CollectModel()
        .collectOrCancelArticle(article.id, !collected)
        .then((result) {
      if (result.success) {
        article.collect = !collected;
        viewModel.articleList[index] = article;
        viewModel.articleList = viewModel.articleList;
      }
    }).whenComplete(() => LoadingDialogHelper.dismissLoading(context));
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getContentList(BuildContext context,
      ProjectItemViewModel viewModel, bool refresh) async {
    return await viewModel.getArticleList(
        widget.projectId, refresh, httpCanceler);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onInit) {
      httpCanceler = HttpCanceler(owner);
    } else if (state == LifecycleState.onCreate) {
      getContentList(
          _buildContext, _buildContext.read<ProjectItemViewModel>(), true);
    }
  }
}
