import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/generated/l10n.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/knowledge/model/knowledge_entity.dart';
import 'package:flutter_wan_android/modules/knowledge/view_model/knowledge_view_model.dart';
import 'package:flutter_wan_android/modules/project/model/category_entity.dart';
import 'package:provider/provider.dart';

class MainKnowledgePage extends StatefulWidget {
  const MainKnowledgePage({Key? key}) : super(key: key);

  @override
  State<MainKnowledgePage> createState() => _MainKnowledgePageState();
}

class _MainKnowledgePageState extends State<MainKnowledgePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> titleArray = [S.of(context).tab_tree, S.of(context).tab_nav];

    return DefaultTabController(
        length: titleArray.length,
        child: Scaffold(
          body: bodyContent(titleArray),
          appBar: AppBar(
            title: TabBar(
              isScrollable: true,
              tabs: List.generate(titleArray.length, (index) {
                return Tab(child: Text(titleArray[index]));
              }),
            ),
          ),
        ));
  }

  Widget bodyContent(List<String> titleArray) {
    return TabBarView(
        children: List.generate(titleArray.length, (index) {
      return KnowledgeItemPage(index == 0 ? system : nav);
    }));
  }

  @override
  bool get wantKeepAlive => true;
}

///类别：1：系统，2：导航F
const system = 1, nav = 2;

class KnowledgeItemPage extends StatefulWidget {
  final int type;

  const KnowledgeItemPage(this.type, {Key? key}) : super(key: key);

  @override
  State<KnowledgeItemPage> createState() => _KnowledgeItemPageState();
}

class _KnowledgeItemPageState extends ZTLifecycleState<KnowledgeItemPage>
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => KnowledgeViewModel())
      ],
      child: Consumer<KnowledgeViewModel>(
        builder: (context, viewModel, child) {
          _buildContext = context;
          return ListView.builder(
            itemBuilder: (context, index) {
              return itemWidget(viewModel.entity, index);
            },
            itemCount: widget.type == system
                ? viewModel.entity.categoryList.length
                : viewModel.entity.navList.length,
          );
        },
      ),
    );
  }

  Widget itemWidget(KnowledgeEntity entity, int itemIndex) {
    ///标题
    String title = widget.type == system
        ? entity.categoryList[itemIndex].name
        : entity.navList[itemIndex].name;

    ///标签个数
    int length = widget.type == system
        ? entity.categoryList[itemIndex].childList!.length
        : entity.navList[itemIndex].articles.length;

    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///标题
          Text(title, style: Theme.of(context).textTheme.titleMedium),

          ///标签内容
          Wrap(
            spacing: 6,
            runSpacing: -5,
            children: List.generate(length, (index) {
              return ActionChip(
                  label: Text(
                    widget.type == system
                        ? entity.categoryList[itemIndex].childList![index].name
                        : entity.navList[itemIndex].articles[index].title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 15),
                  ),
                  onPressed: () {
                    if (widget.type == system) {
                      actionCategoryChild(
                          entity.categoryList[itemIndex], index);
                    } else {
                      actionArticleDetails(
                          entity.navList[itemIndex].articles[index]);
                    }
                  });
            }),
          )
        ],
      ),
    );
  }

  void actionCategoryChild(CategoryEntity category, int index) {
    Map<String, dynamic> arguments = {
      "entity": category.toString(),
      "index": index
    };
    RouterHelper.pushNamed(context, RouterConfig.knowledgeChildPage,
        arguments: arguments);
  }

  void actionArticleDetails(ArticleEntity article) {
    RouterHelper.pushNamed(context, RouterConfig.articleDetailsPage,
        arguments: article);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      KnowledgeViewModel viewModel = _buildContext.read<KnowledgeViewModel>();
      if (widget.type == nav) {
        viewModel.getNavList(owner);
      } else {
        viewModel.getCategoryList(owner);
      }
    }
  }
}
