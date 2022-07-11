import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../res/color_res.dart';
import '../../../utils/log_util.dart';
import '../../main/view/item_content_widget.dart';

///搜索页面
///通过sqlite存储搜索历史
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SearchViewModel())
        ],
        child: Consumer<SearchViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
              appBar: appBar(context, viewModel),
              body: viewModel.showSearchUI
                  ? searchWidget(context, viewModel)
                  : resultWidget(context, viewModel));
        }));
  }

  TextEditingController editingController = TextEditingController();

  AppBar appBar(BuildContext context, SearchViewModel viewModel) {
    return AppBar(
      titleSpacing: 0.0,
      leading: GestureDetector(
          onTap: () => actionBack(context, viewModel),
          child: const Icon(Icons.arrow_back)),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: ColorRes.theme[900]?.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50)),
        child: TextFormField(
          controller: editingController,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            //包裹自身
            isCollapsed: true,
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: "用空格分隔多个关键词",
            hintStyle:
                const TextStyle(fontSize: 15, color: ColorRes.tContentSub),
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

  ///执行搜索逻辑
  /// label != 来自标签
  void actionSearch(
      BuildContext context, SearchViewModel viewModel, String label) {
    Logger.log("-----actionSearch");
    if (label.isNotEmpty) {
      setState(() {
        editingController.text = label;
        editingController.selection =
            TextSelection.collapsed(offset: label.length);
      });
    }
    Logger.log("-----actionSearch:${editingController.text}");
    if (editingController.text.isNotEmpty) {
      viewModel.showSearchUI = false;
      //发起网络请求
    }
  }

  void actionBack(BuildContext context, SearchViewModel viewModel) {
    Logger.log("-----actionBack:${viewModel.showSearchUI}");
    if (!viewModel.showSearchUI) {
      viewModel.showSearchUI = true;
    } else {
      RouterHelper.pop(context);
    }
  }

  ///结果界面
  Widget resultWidget(BuildContext context, SearchViewModel viewModel) {
    EasyRefreshController controller = EasyRefreshController();

    return EasyRefresh(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ItemContentWidget(index: index);
        },
        itemCount: 10,
      ),
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
    );
  }

  ///搜索界面
  Widget searchWidget(BuildContext context, SearchViewModel viewModel) {
    List<String> labels = [
      "机或轮",
      "机轮",
      "机机或机机或轮机或轮或轮轮或轮",
      "机机或轮机或轮或轮",
      "或轮或轮",
      "机或机",
      "或轮轮"
    ];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              itemWidget(context, "服务器数据", labels, 1, viewModel),
              itemWidget(context, "服务器数据", labels, 2, viewModel),
            ],
          ),
        )
      ],
    );
  }

  ///itemWidget
  ///style：1:服务器数据 2:本地数据
  Widget itemWidget(BuildContext context, String title, List<String>? labels,
      int style, SearchViewModel viewModel) {
    ///本读数据 & 编辑数据模式
    bool deleteStyle = style == 2 && viewModel.editingData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///标题
        Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey[100],
            child: Row(
              children: [
                ///固定标题
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 16, color: ColorRes.themeMain))),

                ///清除全部数据
                Offstage(
                    offstage: !deleteStyle,
                    child: TextButton(
                      child: Text("清除",
                          style: const TextStyle(
                              fontSize: 16, color: ColorRes.tContentMain)),
                      onPressed: () {},
                    )),

                ///编辑按钮
                Offstage(
                    offstage: style != 2,
                    child: TextButton(
                      child: Text(viewModel.editingData ? "完成" : "编辑",
                          style: const TextStyle(
                              fontSize: 16, color: ColorRes.tContentMain)),
                      onPressed: () {
                        /*context.read<SearchViewModel>().editingData =
                            !viewModel.editingData;*/
                        viewModel.editingData = !viewModel.editingData;
                      },
                    )),
              ],
            )),

        ///标签内容
        Container(
            //color: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 6,
              runSpacing: -5,
              children:
                  List.generate(labels == null ? 0 : labels.length, (index) {
                return InputChip(
                  label: Text(
                    labels![index],
                    style: const TextStyle(
                        fontSize: 16, color: ColorRes.tContentSub),
                  ),
                  onPressed: deleteStyle
                      ? null
                      : () => actionSearch(context, viewModel, labels[index]),
                  onDeleted: !deleteStyle ? null : () {},
                );
              }),
            )),
      ],
    );
  }

  ///content样式1：服务器数据
  Widget itemStyle1Widget(BuildContext context, List<String>? labels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///标题
        Container(
            margin: EdgeInsets.all(10),
            child: Text(S.of(context).login,
                style:
                    const TextStyle(fontSize: 16, color: ColorRes.themeMain))),

        ///标签内容
        Wrap(
          spacing: 6,
          runSpacing: -5,
          children: List.generate(labels == null ? 0 : labels.length, (index) {
            return ActionChip(
                label: Text(
                  labels![index],
                  style: const TextStyle(
                      fontSize: 14, color: ColorRes.tContentSub),
                ),
                onPressed: () {});
          }),
        )
      ],
    );
  }

  ///content样式2：本地数据
  Widget itemStyle2Widget(BuildContext context, List<String>? labels) {
    return Column(
      children: [
        ///标题
        Text(S.of(context).login,
            style: const TextStyle(fontSize: 16, color: ColorRes.tContentMain)),

        ///标签内容
        Wrap(
          spacing: 6,
          runSpacing: -5,
          children: List.generate(labels == null ? 0 : labels.length, (index) {
            return InputChip(
              label: Text(
                labels![index],
                style:
                    const TextStyle(fontSize: 14, color: ColorRes.tContentSub),
              ),
              onPressed: () {},
              onDeleted: null,
            );
          }),
        )
      ],
    );
  }
}

class SearchViewModel extends ChangeNotifier {
  ///编辑数据模式
  bool _editingData = false;

  bool get editingData => _editingData;

  set editingData(bool value) {
    _editingData = value;
    notifyListeners();
  }

  ///服务器标签
  List<String> _serverLabels = [];

  List<String> get serverLabels => _serverLabels;

  set serverLabels(List<String> value) {
    _serverLabels = value;
    notifyListeners();
  }

  ///本地标签
  List<String> _localLabels = [];

  List<String> get localLabels => _localLabels;

  set localLabels(List<String> value) {
    _localLabels = value;
    notifyListeners();
  }

  ///展示搜索相关界面
  bool _showSearchUI = true;

  bool get showSearchUI => _showSearchUI;

  set showSearchUI(bool value) {
    _showSearchUI = value;
    notifyListeners();
  }
}
