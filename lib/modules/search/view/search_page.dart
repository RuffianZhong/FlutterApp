import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/article/widget/item_article_widget.dart';
import 'package:flutter_wan_android/modules/search/model/search_entity.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../view_model/search_view_model.dart';

///搜索页面
///通过sqlite存储搜索历史
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ZTLifecycleState<SearchPage>
    with WidgetLifecycleObserver {
  ///输入框Controller
  TextEditingController editingController = TextEditingController();

  late BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(SearchViewModel());
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SearchViewModel())
        ],
        child: Consumer<SearchViewModel>(builder: (context, viewModel, child) {
          _buildContext = context;
          return Scaffold(
              appBar: appBar(context, viewModel),
              body: viewModel.showSearchUI
                  ? searchWidget(context, viewModel)
                  : resultWidget(context, viewModel));
        }));
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      ///初始化本地数据
      _buildContext.read<SearchViewModel>().getSearchKeyFromLocal();

      ///初始化服务器数据
      _buildContext.read<SearchViewModel>().getHotKeyFromServer();
    }
  }

  ///执行搜索逻辑
  /// label != "" 来自标签
  void actionSearch(
      BuildContext context, SearchViewModel viewModel, String label,
      {int? id}) {
    if (label.isNotEmpty) {
      setState(() {
        editingController.text = label;
        editingController.selection =
            TextSelection.collapsed(offset: label.length);
      });
    }

    String submitValue = editingController.text;
    if (submitValue.isNotEmpty) {
      viewModel.showSearchUI = false;

      ///本地数据更新
      viewModel.model.insertOrUpdateLocalData(submitValue, id: id);
      viewModel.getSearchKeyFromLocal();

      ///网络数据请求
      viewModel.getContentFromServer(submitValue, this);
    }
  }

  ///执行返回逻辑
  void actionBack(BuildContext context, SearchViewModel viewModel) {
    if (!viewModel.showSearchUI) {
      viewModel.showSearchUI = true;
    } else {
      RouterHelper.pop(context);
    }
  }

  ///执行删除
  ///id为空删除全部
  void actionDelete(SearchViewModel viewModel, {int? id}) {
    ///清除全部，修改编辑状态
    if (id == null) {
      viewModel.editingData = false;
    }
    viewModel.model.deleteLocalData(id: id);
    viewModel.getSearchKeyFromLocal();
  }

  ///导航栏
  AppBar appBar(BuildContext context, SearchViewModel viewModel) {
    return AppBar(
      titleSpacing: 0.0,

      ///返回按钮
      leading: GestureDetector(
          onTap: () => actionBack(context, viewModel),
          child: const Icon(Icons.arrow_back)),

      ///搜索框
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50)),
        child: TextFormField(
          controller: editingController,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            //包裹自身
            isCollapsed: true,
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: S.of(context).search_hint,
            hintStyle:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
            //后缀图标
            suffix: GestureDetector(
                onTap: () {
                  editingController.clear();
                  viewModel.showSearchUI = true;
                },
                child: const Icon(CupertinoIcons.clear, size: 20)),
          ),
        ),
      ),

      ///搜索按钮
      actions: [
        GestureDetector(
            onTap: () => actionSearch(context, viewModel, ""),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: NavigationToolbar.kMiddleSpacing),
              child: const Icon((Icons.search)),
            ))
      ],
    );
  }

  ///结果界面
  Widget resultWidget(BuildContext context, SearchViewModel viewModel) {
    EasyRefreshController controller = EasyRefreshController();

    return EasyRefresh(
      controller: controller,
      footer: ClassicFooter(),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2), () {
          //controller.callRefresh();
          // controller.finishRefresh();
          return IndicatorResult.success;
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2), () {
          //   controller.callLoad();
          //  controller.finishLoad();
          return IndicatorResult.noMore;
        });
      },

      ///return IndicatorResult.success;
      child: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                RouterHelper.pushNamed(context, RouterConfig.articleDetailsPage,
                    arguments: viewModel.articleList[index]);
              },
              child: ItemArticleWidget(article: viewModel.articleList[index]));
        },
        itemCount: viewModel.articleList.length,
      ),
    );
  }

  ///搜索界面
  Widget searchWidget(BuildContext context, SearchViewModel viewModel) {
    bool offstageLocal =
        viewModel.localLabels == null || viewModel.localLabels!.isEmpty;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              searchItemWidget(context, S.of(context).search_hot_title,
                  viewModel.serverLabels, 1, viewModel),
              Offstage(
                  offstage: offstageLocal,
                  child: searchItemWidget(
                      context,
                      S.of(context).search_local_title,
                      viewModel.localLabels,
                      2,
                      viewModel))
            ],
          ),
        )
      ],
    );
  }

  ///itemWidget
  ///style：1:服务器数据 2:本地数据
  Widget searchItemWidget(BuildContext context, String title,
      List<SearchEntity>? labels, int style, SearchViewModel viewModel) {
    ///本读数据 & 编辑数据模式
    bool deleteStyle = style == 2 && viewModel.editingData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///标题
        Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            //  color: Colors.grey[100],
            child: Row(
              children: [
                ///固定标题
                Expanded(
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor))),

                ///清除全部数据
                Offstage(
                    offstage: !deleteStyle,
                    child: TextButton(
                      child: Text(S.of(context).clean_all,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 16)),
                      onPressed: () => actionDelete(viewModel),
                    )),

                ///编辑按钮
                Offstage(
                    offstage: style != 2,
                    child: TextButton(
                      child: Text(
                          viewModel.editingData
                              ? S.of(context).done
                              : S.of(context).edit,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 16)),
                      onPressed: () {
                        viewModel.editingData = !viewModel.editingData;
                      },
                    )),
              ],
            )),

        ///标签内容
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 6,
              runSpacing: -5,
              children:
                  List.generate(labels == null ? 0 : labels.length, (index) {
                int? id = labels![index].id;
                String? value = labels[index].value;

                return InputChip(
                  label: Text(
                    value ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: deleteStyle
                      ? null
                      : () => actionSearch(context, viewModel, value ?? "",
                          id: style == 1 ? null : id),
                  onDeleted: !deleteStyle
                      ? null
                      : () => actionDelete(viewModel, id: id),
                );
              }),
            )),
      ],
    );
  }
}
