import 'package:flutter/material.dart';
import 'package:flutter_wan_android/res/color_res.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';

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
    return Consumer<KnowledgeViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
            length: viewModel.tabTitleArray(context).length,
            child: Scaffold(
              body: bodyContent(viewModel),
              appBar: AppBar(
                title: TabBar(
                  isScrollable: true,
                  tabs: List.generate(viewModel.tabTitleArray(context).length,
                      (index) {
                    return Tab(
                        child: Text(viewModel.tabTitleArray(context)[index]));
                  }),
                ),
              ),
            ));
      },
    );
  }

  Widget bodyContent(KnowledgeViewModel viewModel) {
    return TabBarView(
        children:
            List.generate(viewModel.tabTitleArray(context).length, (index) {
      return KnowledgeItemPage();
    }));
  }

  @override
  bool get wantKeepAlive => true;
}

class KnowledgeViewModel extends ChangeNotifier {
  ///标题列表
  List<String> tabTitleArray(BuildContext context) {
    return [S.of(context).login, S.of(context).register];
  }

  ///知识体系Map
  Map<String, List<String>> systemKnowMap = {
    "基础知识": ["机或轮", "机轮", "机机或机机或轮机或轮或轮轮或轮", "机机或轮机或轮或轮", "或轮或轮", "机或机", "或轮轮"],
    "知识": ["机或轮", "机轮", "机机或轮或轮", "机机或轮机或轮或轮", "或轮或轮", "机或机", "或轮轮"],
    "基础知": ["机或机机或轮机或轮或轮轮", "机轮", "机机或轮或轮", "机机或轮机或轮或轮", "或轮或轮", "机或机", "或轮轮"],
    "基础知识基础知识": [
      "机或轮",
      "机轮",
      "机机机机或轮机或轮或轮或轮或轮",
      "机机或轮机或轮或轮",
      "或轮或轮",
      "机或机",
      "或轮轮"
    ],
  };

  ///知识导航Map
  Map<String, List<String>> navigationKnowMap = {
    "基础知识": ["机或轮", "机轮", "机机或机机或轮机或轮或轮轮或轮", "机机或轮机或轮或轮", "或轮或轮", "机或机", "或轮轮"],
    "知识": ["机或轮", "机轮", "机机或轮或轮", "机机或轮机或轮或轮", "或轮或轮", "机或机", "或轮轮"],
    "基础知": ["机或机机或轮机或轮或轮轮", "机轮", "机机或轮或轮", "机机或轮机或轮或轮", "或轮或轮", "机或机", "或轮轮"],
    "基础知识基础知识": [
      "机或轮",
      "机轮",
      "机机机机或轮机或轮或轮或轮或轮",
      "机机或轮机或轮或轮",
      "或轮或轮",
      "机或机",
      "或轮轮"
    ],
  };
}

class KnowledgeItemPage extends StatefulWidget {
  const KnowledgeItemPage({Key? key}) : super(key: key);

  @override
  State<KnowledgeItemPage> createState() => _KnowledgeItemPageState();
}

class _KnowledgeItemPageState extends State<KnowledgeItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<KnowledgeViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            String key = viewModel.systemKnowMap.keys.toList()[index];
            return itemWidget(key, viewModel.systemKnowMap[key]);
          },
          itemCount: viewModel.systemKnowMap.length,
        );
      },
    );
  }

  Widget itemWidget(String title, List<String>? labels) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///标题
          Text(title,
              style:
                  const TextStyle(fontSize: 16, color: ColorRes.tContentMain)),

          ///标签内容
          Wrap(
            spacing: 6,
            runSpacing: -5,
            children:
                List.generate(labels == null ? 0 : labels.length, (index) {
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
