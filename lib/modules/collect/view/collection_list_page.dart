import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
import '../../../generated/l10n.dart';
import '../view_model/collection_list_view_model.dart';

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
        ChangeNotifierProvider(create: (context) => CollectionListViewModel())
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

    return Consumer<CollectionListViewModel>(
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
    );
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getContentList(BuildContext context,
      CollectionListViewModel viewModel, bool refresh) async {
    return await viewModel.getArticleList(refresh, HttpCanceler(this));
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      getContentList(
          _buildContext, _buildContext.read<CollectionListViewModel>(), true);
    }
  }
}
