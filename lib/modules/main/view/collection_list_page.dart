import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/main/model/collect_model.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
import '../../../generated/l10n.dart';
import '../model/article_entity.dart';
import 'item_content_widget.dart';

class CollectionListPage extends StatefulWidget {
  const CollectionListPage({Key? key}) : super(key: key);

  @override
  State<CollectionListPage> createState() => _CollectionListPageState();
}

class _CollectionListPageState extends ZTLifecycleState<CollectionListPage>
    with WidgetLifecycleObserver {
  late BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectItemViewModel())
      ],
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
      title: Text(S.of(context).collect),
    );
  }

  Widget bodyContent(BuildContext context) {
    EasyRefreshController controller = EasyRefreshController();

    return Consumer<ProjectItemViewModel>(
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
    );
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getContentList(BuildContext context,
      ProjectItemViewModel viewModel, bool refresh) async {
    return await viewModel.getArticleList(refresh, HttpCanceler(this));
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      getContentList(
          _buildContext, _buildContext.read<ProjectItemViewModel>(), true);
    }
  }
}

class ProjectItemViewModel extends ChangeNotifier {
  CollectModel model = CollectModel();

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
      bool refresh, HttpCanceler canceler) async {
    ///下拉刷新，下标从0开始
    if (refresh) pageIndex = 0;
    HttpResult<ArticleEntity> result =
        await model.getCollectList(pageIndex, canceler);
    if (result.success) {
      if (refresh) articleList.clear();
      articleList.addAll(result.list!);
      articleList = articleList;
      pageIndex++;
    }
    return result;
  }
}
