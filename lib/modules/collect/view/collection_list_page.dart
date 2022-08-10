import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/account/view/login_page.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:flutter_wan_android/modules/collect/model/collect_model.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:flutter_wan_android/widget/loading_dialog_helper.dart';
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

class _CollectionListPageState extends State<CollectionListPage>
    with Lifecycle, LifecycleObserver {
  late BuildContext _buildContext;
  late HttpCanceler httpCanceler;

  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CollectionListViewModel())
      ],
      builder: (context, child) {
        _buildContext = context;
        return Scaffold(
          body: bodyContent(context),
          appBar: appBar(context),
        );
      },
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
    return Consumer<CollectionListViewModel>(
      builder: (context, viewModel, child) {
        return EasyRefresh(
          controller: _controller,
          onRefresh: () async {
            await getContentList(context, viewModel, true);

            _controller.finishRefresh();
            _controller.resetFooter();
          },
          onLoad: () async {
            HttpResult<ArticleEntity> result =
                await getContentList(context, viewModel, false);

            bool noMore = false;
            if (result.list != null && result.list!.isEmpty) {
              noMore = true;
            }

            _controller.finishLoad(
                noMore ? IndicatorResult.noMore : IndicatorResult.success);
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
    );
  }

  ///收藏/取消收藏 动作
  void actionCollect(int index, CollectionListViewModel viewModel) async {
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
  void collectLogic(int index, CollectionListViewModel viewModel) async {
    LoadingDialogHelper.showLoading(context);

    ArticleEntity article = viewModel.articleList[index];

    ///当前收藏状态
    bool collected = article.collect != null && article.collect!;

    CollectModel()
        .collectOrCancelArticle(article.id, !collected)
        .then((result) {
      if (result.success) {
        article.collect = !collected;
        //viewModel.articleList[index] = article;
        ///收藏页面需要移除数据
        viewModel.articleList.removeAt(index);
        viewModel.articleList = viewModel.articleList;
      }
    }).whenComplete(() => LoadingDialogHelper.dismissLoading(context));
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getContentList(BuildContext context,
      CollectionListViewModel viewModel, bool refresh) async {
    HttpResult<ArticleEntity> result =
        await viewModel.getArticleList(refresh, httpCanceler);

    ///意思是页面还没有销毁时才可以使用context
    if (mounted) {
      if (!result.success) {
        ///未登录
        if (result.code == -1001) {
          RouterHelper.push(context, const LoginPage(), fullscreenDialog: true);
        }
      }
    }
    return result;
  }

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onInit) {
      httpCanceler = HttpCanceler(owner);
    } else if (state == LifecycleState.onStart) {
      getContentList(
          _buildContext, _buildContext.read<CollectionListViewModel>(), true);
    } else if (state == LifecycleState.onDestroy) {
      _controller.dispose();
    }
  }
}
