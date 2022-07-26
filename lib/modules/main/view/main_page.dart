import 'package:flutter/material.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/modules/book/view/main_book.dart';
import 'package:flutter_wan_android/modules/book/view_model/book_view_model.dart';
import 'package:flutter_wan_android/modules/home/view/main_home.dart';
import 'package:flutter_wan_android/modules/home/view_model/home_view_model.dart';
import 'package:flutter_wan_android/modules/knowledge/view/main_knowledge.dart';
import 'package:flutter_wan_android/modules/knowledge/view_model/knowledge_view_model.dart';
import 'package:flutter_wan_android/modules/me/view/main_me.dart';
import 'package:flutter_wan_android/modules/me/view_model/me_view_model.dart';
import 'package:flutter_wan_android/modules/project/view/main_project.dart';
import 'package:flutter_wan_android/modules/project/view_model/project_view_model.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _navBarIndex = 0;
  final PageController _pageController = PageController();

  MainHomePage? _homePage;
  MainProjectPage? _projectPage;
  MainBookPage? _bookPage;
  MainKnowledgePage? _knowledgePage;
  MainMePage? _mePage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MeViewModel()),
          ChangeNotifierProvider(create: (context) => ProjectViewModel()),
          ChangeNotifierProvider(create: (context) => KnowledgeViewModel()),
          ChangeNotifierProvider(create: (context) => BookViewModel()),
          ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ],
        child: Scaffold(
          body: _bodyContent(),
          bottomNavigationBar: _bottomNavigationBar(),
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _bodyContent() {
    return PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _homePage ??= const MainHomePage();
          }
          if (index == 1) {
            return _projectPage ??= const MainProjectPage();
          }
          if (index == 2) {
            return _bookPage ??= const MainBookPage();
          }
          if (index == 3) {
            return _knowledgePage ??= const MainKnowledgePage();
          }
          if (index == 4) {
            return _mePage ??= const MainMePage();
          }
          return Container();
        });
  }

  /// 底部导航栏bar
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        _bottomNavigationBarItem(S.of(context).tab_home, "ic_tab_home.png"),
        _bottomNavigationBarItem(
            S.of(context).tab_project, "ic_tab_project.png"),
        _bottomNavigationBarItem(S.of(context).tab_book, "ic_tab_square.png"),
        _bottomNavigationBarItem(
            S.of(context).tab_knowledge, "ic_tab_wechat.png"),
        _bottomNavigationBarItem(S.of(context).tab_me, "ic_tab_me.png"),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: _navBarIndex,
      // backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _navBarIndex = index;
          _pageController.jumpToPage(index);
        });
      },
    );
  }

  ///home menu_book perm_identity
  /// 底部导航栏按钮
  BottomNavigationBarItem _bottomNavigationBarItem(String label, String icon) {
    return BottomNavigationBarItem(
      icon: Image.asset(ImageHelper.wrapAssets(icon),
          height: 24, width: 24, color: Colors.grey),
      activeIcon: Image.asset(ImageHelper.wrapAssets(icon),
          height: 24, width: 24, color: Theme.of(context).primaryColor),
      label: label,
    );
  }
}
