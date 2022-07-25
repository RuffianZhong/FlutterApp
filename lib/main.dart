import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/modules/main/view/main_home.dart';
import 'package:flutter_wan_android/modules/main/view_model/locale_view_model.dart';
import 'package:flutter_wan_android/modules/main/view_model/me_view_model.dart';
import 'package:flutter_wan_android/modules/main/view_model/theme_view_model.dart';
import 'package:provider/provider.dart';

import 'config/router_config.dart';
import 'core/lifecycle/zt_lifecycle.dart';
import 'generated/l10n.dart';
import 'modules/main/view/main_knowledge.dart';
import 'modules/main/view/main_me.dart';
import 'modules/main/view/main_project.dart';
import 'modules/main/view/main_square.dart';
import 'modules/main/view_model/home_view_model.dart';
import 'modules/main/view_model/knowledge_view_model.dart';
import 'modules/main/view_model/project_view_model.dart';
import 'modules/main/view_model/square_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeViewModel())
      ],
      child: Consumer2<ThemeViewModel, LocaleViewModel>(
        builder: (context, themeModel, localModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            /// widget本地化代理设置
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              S.delegate //自定义国际化
            ],

            ///指定语言
            locale: localModel.locale,

            /// widget本地化支持语言
            supportedLocales: S.delegate.supportedLocales,

            /// 生命周期感知
            navigatorObservers: [WidgetRouteObserver.routeObserver],

            ///路由表配置
            routes: RouterConfig.routes,

            title: 'WanAndroid',
            theme: themeModel.themeData,
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navBarIndex = 0;
  final PageController _pageController = PageController();

  MainHomePage? _homePage;
  MainProjectPage? _projectPage;
  MainSquarePage? _squarePage;
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
          ChangeNotifierProvider(create: (context) => SquareViewModel()),
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
            return _squarePage ??= const MainSquarePage();
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
        _bottomNavigationBarItem(S.of(context).tab_square, "ic_tab_square.png"),
        _bottomNavigationBarItem(
            S.of(context).tab_knowledge, "ic_tab_wechat.png"),
        _bottomNavigationBarItem(S.of(context).tab_me, "ic_tab_me.png"),
      ],
      // selectedItemColor:Theme.of(context).primaryColor,
      currentIndex: _navBarIndex,
      backgroundColor: Colors.white,
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
