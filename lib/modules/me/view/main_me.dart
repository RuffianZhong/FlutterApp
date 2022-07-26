import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/generated/l10n.dart';
import 'package:flutter_wan_android/helper/cookie_helper.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';
import 'package:flutter_wan_android/modules/account/view/login_page.dart';
import 'package:flutter_wan_android/modules/main/view/preview_page.dart';
import 'package:flutter_wan_android/modules/main/view_model/locale_view_model.dart';
import 'package:flutter_wan_android/modules/main/view_model/theme_view_model.dart';
import 'package:flutter_wan_android/modules/me/view_model/me_view_model.dart';
import 'package:flutter_wan_android/utils/screen_util.dart';
import 'package:flutter_wan_android/utils/toast_util.dart';
import 'package:flutter_wan_android/widget/loading_dialog_helper.dart';
import 'package:provider/provider.dart';

import '../../../config/hero_config.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../../../utils/log_util.dart';

class MainMePage extends StatefulWidget {
  const MainMePage({Key? key}) : super(key: key);

  @override
  State<MainMePage> createState() => _MainMePageState();
}

class _MainMePageState extends ZTLifecycleState<MainMePage>
    with AutomaticKeepAliveClientMixin, WidgetLifecycleObserver {
  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(body: Consumer<MeViewModel>(
      builder: (context, viewModel, child) {
        return _bodyContent(context, viewModel);
      },
    ));
  }

  ///退出登录
  void actionLogout(BuildContext context, MeViewModel viewModel) {
    LoadingDialogHelper.showLoading(context);
    viewModel.model
        .logout(HttpCanceler(this))
        .then((value) {
          if (value.success) {
            viewModel.isLogin = false;
            viewModel.model.saveUser(UserEntity());
          }
        })
        .onError((error, stackTrace) =>
            ToastUtil.showToast(msg: S.of(context).net_error))
        .whenComplete(() => LoadingDialogHelper.dismissLoading(context));
  }

  ///用户头像事件
  void actionUserIcon(BuildContext context, MeViewModel viewModel) {
    if (viewModel.isLogin) {
      ///放大
      RouterHelper.push(context, PreviewPage(viewModel.userEntity.icon ?? ""),
          fullscreenDialog: true);
    } else {
      ///去登录
      RouterHelper.push(context, const LoginPage(), fullscreenDialog: true)
          .then((value) {
        Logger.log("---------me-------------$value");

        ///刷新用户数据
        refreshUserData(viewModel);
      });
    }
  }

  ///刷新用户数据
  void refreshUserData(MeViewModel viewModel) async {
    viewModel.isLogin = await viewModel.model.isLogin();

    if (viewModel.isLogin) {
      viewModel.userEntity = await viewModel.model.getUser();
    }
  }

  Widget _bodyContent(BuildContext context, MeViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerContent(context, viewModel),
          _centerContent(context, viewModel)
        ],
      ),
    );
  }

  /// 头部内容
  Widget _headerContent(BuildContext context, MeViewModel viewModel) {
    double topBarHeight =
        ScreenUtil.get().appBarHeight + ScreenUtil.get().statusBarHeight;

    return Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      child: Consumer<MeViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              ///用户信息
              Center(
                  child: Column(
                children: [
                  ///模拟头部appBar
                  SizedBox(height: topBarHeight),

                  ///圆形头像
                  GestureDetector(
                    onTap: () => actionUserIcon(context, viewModel),
                    child: Hero(
                      tag: HeroConfig.tagPreview,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: viewModel.isLogin
                            ? ImageHelper.network(
                                viewModel.userEntity.icon ?? "",
                                height: 90,
                                width: 90)
                            : const Icon(
                                Icons.account_circle,
                                size: 90,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ///昵称
                  Text(
                      viewModel.isLogin
                          ? viewModel.userEntity.nickname ??
                              S.of(context).placeholder
                          : S.of(context).login,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  ///积分
                  Visibility(
                    visible: viewModel.isLogin,
                    child: Text(
                        S.of(context).integral(viewModel.userEntity.coinCount ??
                            S.of(context).placeholder),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.underline)),
                  ),

                  const SizedBox(height: 30),
                ],
              )),

              /// 退出登录
              Positioned(
                right: 20,
                top: topBarHeight - ScreenUtil.get().appBarHeight / 2 - 12,
                child: Offstage(
                  offstage: !viewModel.isLogin,
                  child: GestureDetector(
                      onTap: () => actionLogout(context, viewModel),
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 24,
                      )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 中间列表内容
  Widget _centerContent(BuildContext context, MeViewModel viewModel) {
    return Column(
      children: [
        ///收藏
        _itemWidgetDefault(
            context,
            () => RouterHelper.pushNamed(context, RouterConfig.collectListPage),
            Icons.favorite_border,
            S.of(context).collect,
            Icons.chevron_right),

        ///暗黑模式
        _itemWidgetSwitch(context, (value) {
          viewModel.darkMode = value;
          context.read<ThemeViewModel>().darkMode = value;
        }, viewModel.darkMode ? Icons.brightness_2 : Icons.brightness_5,
            S.of(context).dark_style, viewModel.darkMode),

        ///彩色主题
        _itemWidgetExpansion(S.of(context).color_theme, Icons.color_lens,
            _itemChildTheme(viewModel)),

        ///多语言
        _itemWidgetExpansion(
            S.of(context).multi_language,
            Icons.language,
            _itemChildLanguage(viewModel, onChanged: (value) {
              if (value != null) {
                viewModel.localIndexValue = value;
                context.read<LocaleViewModel>().setLocalIndex(value);
              }
            })),

        ///设置
        /*_itemWidgetDefault(context, () {}, Icons.settings,
            S.of(context).settings, Icons.chevron_right),*/
      ],
    );
  }

  /// 列表item：默认样式
  Widget _itemWidgetDefault(BuildContext context, GestureTapCallback onTap,
      IconData leftIcon, String title, IconData rightIcon) {
    return InkWell(
        onTap: onTap,
        splashColor: Colors.grey[300],
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(leftIcon),
              const SizedBox(width: 20),
              Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium)),
              Icon(rightIcon),
            ],
          ),
        ));
  }

  /// 列表item：开关样式
  Widget _itemWidgetSwitch(BuildContext context, ValueChanged<bool> onChanged,
      IconData leftIcon, String title, bool switchValue) {
    return InkWell(
        onTap: () {},
        splashColor: Colors.grey[300],
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(leftIcon),
              const SizedBox(width: 20),
              Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium)),

              ///iOS风格开关
              CupertinoSwitch(onChanged: onChanged, value: switchValue),
            ],
          ),
        ));
  }

  /// 列表item：抽屉式
  Widget _itemWidgetExpansion(String title, IconData icon, Widget child) {
    ///向下扩展/收缩布局
    return ExpansionTile(
      title: Text(title),
      leading: Icon(icon),
      children: [
        ///内间距
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),

          ///子布局
          child: child,
        )
      ],
    );
  }

  ///彩色主题
  Widget _itemChildTheme(MeViewModel viewModel) {
    ///流式布局
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        /// ... 适配类型？？
        ...Colors.primaries.map((color) {
          int index = Colors.primaries.indexOf(color);

          ///指定形状
          return Material(
            color: color,
            child: InkWell(
              onTap: () {
                viewModel.themeIndex = index;
                context.read<ThemeViewModel>().setThemeIndex(index);
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: viewModel.themeIndex == index
                    ? const Icon(Icons.check)
                    : null,
              ),
            ),
          );
        }).toList()
      ],
    );
  }

  ///多语言
  Widget _itemChildLanguage(MeViewModel viewModel,
      {required ValueChanged<int?> onChanged}) {
    return Column(
      children: [
        ///中文
        Row(
          children: [
            Radio(
                value: 0,
                groupValue: viewModel.localIndexValue,
                onChanged: onChanged),
            Text(
              S.of(context).language_chinese,
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),

        ///英文
        Row(
          children: [
            Radio(
                value: 1,
                groupValue: viewModel.localIndexValue,
                onChanged: onChanged),
            Text(
              S.of(context).language_english,
              style: const TextStyle(fontSize: 14),
            )
          ],
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      /// 首帧绘制完成
      /// 初始化数据
      MeViewModel viewModel = context.read<MeViewModel>();
      viewModel.initLocalData(context);
      viewModel.initThemeData(context);
      viewModel.initUserData();
    } else if (state == WidgetLifecycleState.onResume) {
      CookieHelper.getCookie();
    }
  }
}
