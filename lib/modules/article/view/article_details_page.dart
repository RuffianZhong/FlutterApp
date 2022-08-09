import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_lifecycle_aware/lifecycle.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/article/view_model/article_details_view_model.dart';
import 'package:flutter_wan_android/utils/string_util.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';

///文章详情页面
class ArticleDetailsPage extends StatefulWidget {
  const ArticleDetailsPage({Key? key}) : super(key: key);

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage>
    with Lifecycle, LifecycleObserver {
  ///滚动进度
  double scrollProgress = 0.0;

  ///页面可滚动内容高度
  double scrollHeight = 0.0;
  final GlobalKey _globalKeyWebView = GlobalKey();
  late BuildContext _buildContext;

  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ArticleDetailsViewModel())
        ],
        child: Consumer<ArticleDetailsViewModel>(
            builder: (context, viewModel, child) {
          _buildContext = context;
          return Scaffold(
              appBar: appBar(context, viewModel),
              body: bodyContent(context, viewModel));
        }));
  }

  ///通过浏览器打开
  void actionBrowse(BuildContext context, ArticleDetailsViewModel viewModel) {}

  ///收藏
  void actionCollect(BuildContext context, ArticleDetailsViewModel viewModel) {}

  ///返回
  void actionBack(BuildContext context) {
    RouterHelper.pop(context, scrollProgress);
  }

  ///导航栏
  AppBar appBar(BuildContext context, ArticleDetailsViewModel viewModel) {
    return AppBar(
      titleSpacing: 0.0,

      ///返回按钮
      leading: GestureDetector(
          onTap: () => actionBack(context),
          child: const Icon(Icons.arrow_back)),

      ///标题
      title: Text(
          StringUtil.removeHtmlLabel(viewModel.articleEntity?.title ?? ""),
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),

      ///菜单按钮
      actions: [
        ///打开浏览器
        GestureDetector(
            onTap: () => actionBrowse(context, viewModel),
            child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: NavigationToolbar.kMiddleSpacing),
                child: const Icon(Icons.language))),

        ///收藏
        GestureDetector(
            onTap: () => actionCollect(context, viewModel),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: NavigationToolbar.kMiddleSpacing),
              child: const Icon(Icons.favorite),
            )),
      ],
    );
  }

  ///基本配置
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
  );

  ///内容WebView
  Widget bodyContent(BuildContext context, ArticleDetailsViewModel viewModel) {
    return Stack(children: [
      ///webView
      webContent(context, viewModel),

      ///加载进度
      Offstage(
          offstage: viewModel.loadProgress == 1.0,
          child: placeholderContent(context, viewModel))
    ]);
  }

  ///WebView
  Widget webContent(BuildContext context, ArticleDetailsViewModel viewModel) {
    return InAppWebView(
      key: _globalKeyWebView,
      initialOptions: options,
      /*initialUrlRequest:
          URLRequest(url: Uri.parse(viewModel.articleEntity?.link ?? "")),*/

      ///加载进度
      onProgressChanged: (InAppWebViewController controller, int progress) {
        viewModel.loadProgress = progress / 100.0;
      },
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
        String url = viewModel.articleEntity?.link ?? "";
        if (url.isNotEmpty) {
          _webViewController.loadUrl(
              urlRequest: URLRequest(url: Uri.parse(url)));
        }
      },

      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        int contentHeight = await controller.getContentHeight() ?? 0;
        double widgetHeight =
            _globalKeyWebView.currentContext?.size?.height ?? 0;
        scrollHeight = contentHeight - widgetHeight;
      },

      ///滚动监听
      onScrollChanged: (InAppWebViewController controller, int x, int y) {
        if (scrollHeight > 0) {
          scrollProgress = y / scrollHeight;
        }
      },
    );
  }

  ///加载中
  Widget placeholderContent(
      BuildContext context, ArticleDetailsViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          value: viewModel.loadProgress,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 20, width: double.infinity),
        Text(
          S.of(context).loading_content,
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        )
      ],
    );
  }

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onCreate) {
      ///获取参数
      ArticleEntity? entity = RouterHelper.argumentsT<ArticleEntity>(context);

      _buildContext.read<ArticleDetailsViewModel>().articleEntity =
          entity ?? ArticleEntity();
    }
  }
}
