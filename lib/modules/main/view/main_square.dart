import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../book/model/book_entity.dart';
import '../view_model/square_view_model.dart';

class MainSquarePage extends StatefulWidget {
  const MainSquarePage({Key? key}) : super(key: key);

  @override
  State<MainSquarePage> createState() => _MainSquarePageState();
}

class _MainSquarePageState extends ZTLifecycleState<MainSquarePage>
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
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).tab_book_course),
        ),
        body: bodyContent());
  }

  Widget bodyContent() {
    return Consumer<SquareViewModel>(builder: (context, viewModel, child) {
      _buildContext = context;
      return GridView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: viewModel.dataArray.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7),
          itemBuilder: (context, index) {
            return itemWidget(viewModel.dataArray[index]);
          });
    });
  }

  Widget itemWidget(BookEntity entity) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ImageHelper.network(entity.cover, fit: BoxFit.cover));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      SquareViewModel viewModel = _buildContext.read<SquareViewModel>();
      viewModel.getBookList(owner);
    }
  }
}
