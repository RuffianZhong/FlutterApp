import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../book/model/book_entity.dart';
import '../view_model/book_view_model.dart';

class MainBookPage extends StatefulWidget {
  const MainBookPage({Key? key}) : super(key: key);

  @override
  State<MainBookPage> createState() => _MainBookPageState();
}

class _MainBookPageState extends State<MainBookPage>
    with AutomaticKeepAliveClientMixin, Lifecycle {
  final BookViewModel bookViewModel = BookViewModel();

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(bookViewModel);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) => bookViewModel,
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).tab_book_course),
            ),
            body: bodyContent());
      },
    );
  }

  void actionItemClick(BookEntity book) {
    RouterHelper.pushNamed(context, RouterConfig.bookDetailsPage,
        arguments: book);
  }

  Widget bodyContent() {
    return Consumer<BookViewModel>(builder: (context, viewModel, child) {
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

  Widget itemWidget(BookEntity book) {
    return GestureDetector(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: ImageHelper.network(book.cover, fit: BoxFit.cover)),
      onTap: () => actionItemClick(book),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
