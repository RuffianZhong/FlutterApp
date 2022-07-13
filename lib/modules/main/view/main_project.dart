import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:provider/provider.dart';

import '../model/article_entity.dart';
import 'item_content_widget.dart';

class MainProjectPage extends StatefulWidget {
  const MainProjectPage({Key? key}) : super(key: key);

  @override
  State<MainProjectPage> createState() => _MainProjectPageState();
}

class _MainProjectPageState extends State<MainProjectPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProjectViewModel>(builder: (
      BuildContext context,
      viewModel,
      Widget? child,
    ) {
      return DefaultTabController(
          length: viewModel.tabTitleArray.length,
          child: Scaffold(
            body: bodyContent(viewModel),
            appBar: AppBar(
              title: TabBar(
                isScrollable: true,
                tabs: List.generate(viewModel.tabTitleArray.length, (index) {
                  return Tab(child: Text(viewModel.tabTitleArray[index]));
                }),
              ),
            ),
          ));
    });
  }

  Widget bodyContent(ProjectViewModel viewModel) {
    return TabBarView(
        children: List.generate(viewModel.tabTitleArray.length, (index) {
      return TabBarViewItemPage();
    }));
  }

  @override
  bool get wantKeepAlive => true;
}

class TabBarViewItemPage extends StatefulWidget {
  const TabBarViewItemPage({Key? key}) : super(key: key);

  @override
  State<TabBarViewItemPage> createState() => _TabBarViewItemPageState();
}

class _TabBarViewItemPageState extends State<TabBarViewItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    EasyRefreshController controller = EasyRefreshController();

    return EasyRefresh(
      controller: controller,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2), () {
          //controller.callRefresh();
          // controller.finishRefresh();
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2), () {
          //   controller.callLoad();
          //  controller.finishLoad();
        });
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ItemContentWidget(article: ArticleEntity());
        },
        itemCount: 10,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProjectViewModel extends ChangeNotifier {
  List<String> _tabTitleArray = [
    "虽败",
    "来个长点的标题",
    "随便来点",
    "什么",
    "都可以的",
    "再来一个长点的标题",
    "虽败",
  ];

  List<String> get tabTitleArray => _tabTitleArray;

  set tabTitleArray(List<String> value) {
    _tabTitleArray = value;
    notifyListeners();
  }
}
