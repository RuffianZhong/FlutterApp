import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wan_android/modules/main/view_model/locale_view_model.dart';
import 'package:flutter_wan_android/modules/main/view_model/theme_view_model.dart';
import 'package:provider/provider.dart';

import 'config/router_config.dart';
import 'core/lifecycle/zt_lifecycle.dart';
import 'generated/l10n.dart';
import 'modules/main/view/main_page.dart';

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

            ///主题
            theme: themeModel.themeData,

            ///暗黑主题
            darkTheme: themeModel.themeData,
            home: const MainPage(),
          );
        },
      ),
    );
  }
}
