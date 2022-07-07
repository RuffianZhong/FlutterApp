import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/generated/l10n.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';
import 'package:flutter_wan_android/modules/main/view_model/me_view_model.dart';
import 'package:provider/provider.dart';

import '../../../res/color_res.dart';

class MainMePage extends StatefulWidget {
  const MainMePage({Key? key}) : super(key: key);

  @override
  State<MainMePage> createState() => _MainMePageState();
}

class _MainMePageState extends ZTLifecycleState<MainMePage>
    with AutomaticKeepAliveClientMixin, WidgetLifecycleObserver {
  final String iconUrl =
      "https://img2.baidu.com/it/u=1994380678,3283034272&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657040400&t=4cc7ef8232b3a054dbac4544187c0a05";

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _bodyContent(context);
  }

  Widget _bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [_headerContent(context), _centerContent(context)],
      ),
    );
  }

  /// 头部内容
  Widget _headerContent(BuildContext context) {
    return Container(
      color: ColorRes.themeMain,
      width: double.infinity,
      child: Consumer<MeViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              ///用户信息
              Center(
                  child: Column(
                children: [
                  const SizedBox(height: 50),

                  ///圆形头像
                  ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: CachedNetworkImage(
                      imageUrl: iconUrl,
                      height: 90,
                      width: 90,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ///昵称
                  Text(
                      viewModel.userEntity.nickname ??
                          S.of(context).placeholder,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  ///积分
                  Text(
                      S.of(context).integral(viewModel.userEntity.uid ??
                          S.of(context).placeholder),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline)),

                  const SizedBox(height: 30),
                ],
              )),

              /// 退出登录
              Positioned(
                  right: 20,
                  top: 40,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  /// 中间列表内容
  Widget _centerContent(BuildContext context) {
    return Column(
      children: [
        ///收藏
        _itemWidgetDefault(context, () {}, Icons.favorite_border,
            S.of(context).collect, Icons.chevron_right),

        ///暗黑模式
        _itemWidgetSwitch(
            context,
            (value) {},
            Theme.of(context).brightness == Brightness.light
                ? Icons.brightness_5
                : Icons.brightness_2,
            S.of(context).dark_style,
            Theme.of(context).brightness == Brightness.dark),

        ///彩色主题
        _itemWidgetSettingTheme(context, () {}),

        ///设置
        _itemWidgetDefault(context, () {}, Icons.settings,
            S.of(context).settings, Icons.chevron_right),
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
              Expanded(child: Text(title)),
              Icon(rightIcon),
            ],
          ),
        ));
  }

  /// 列表item：默认样式
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
              Expanded(child: Text(title)),

              ///iOS风格开关
              CupertinoSwitch(onChanged: onChanged, value: switchValue),
            ],
          ),
        ));
  }

  /// 列表item：设置主题
  Widget _itemWidgetSettingTheme(
      BuildContext context, GestureTapCallback onTap) {
    ///向下扩展/收缩布局
    return ExpansionTile(
      title: Text(S.of(context).color_theme),
      leading: const Icon(Icons.color_lens),
      children: [
        ///内间距
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),

          ///流式布局
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              /// ... 适配类型？？
              ...Colors.primaries.map((color) {
                ///指定形状
                return Material(
                  color: color,
                  child: InkWell(
                    onTap: onTap,
                    child: const SizedBox(height: 40, width: 40),
                  ),
                );
              }).toList()
            ],
          ),
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
      viewModel.userEntity = UserEntity(uid: 0, nickname: S.of(context).login);
    }
  }
}
