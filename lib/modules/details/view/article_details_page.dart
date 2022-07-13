import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/details/view_model/article_details_view_model.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';
import 'package:flutter_wan_android/utils/string_util.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../res/color_res.dart';

///文章详情页面
class ArticleDetailsPage extends StatefulWidget {
  const ArticleDetailsPage({Key? key}) : super(key: key);

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends ZTLifecycleState<ArticleDetailsPage>
    with WidgetLifecycleObserver {
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

  ///导航栏
  AppBar appBar(BuildContext context, ArticleDetailsViewModel viewModel) {
    return AppBar(
      titleSpacing: 0.0,

      ///返回按钮
      leading: GestureDetector(
          onTap: () => RouterHelper.pop(context),
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
          color: ColorRes.themeMain,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 20, width: double.infinity),
        Text(
          S.of(context).loading_content,
          style: const TextStyle(fontSize: 16, color: ColorRes.themeMain),
        )
      ],
    );
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      ///获取参数
      ArticleEntity? entity = RouterHelper.argumentsT<ArticleEntity>(context);

      _buildContext.read<ArticleDetailsViewModel>().articleEntity =
          entity ?? ArticleEntity();
    }
  }
}
