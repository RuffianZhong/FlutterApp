import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/account/view_model/login_view_model.dart';
import 'package:flutter_wan_android/utils/screen_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../generated/l10n.dart';
import '../../../res/color_res.dart';

///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ZTLifecycleState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginViewModel())
        ],
        child: Consumer<LoginViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
            body: _bodyContent(context, viewModel),
          );
        }));
  }

  ///登录
  void actionLogin(BuildContext context, LoginViewModel viewModel) {
    String account = _accountController.text;
    String psw = _pswController.text;
    if (account.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).account_empty_tip);
      return;
    }
    if (psw.isEmpty) {
      Fluttertoast.showToast(msg: S.of(context).psw_empty_tip);
    }
    viewModel.model.login(account, psw, HttpCanceler(this)).then((value) {
      viewModel.loginSuccess(value);
      Fluttertoast.showToast(msg: "登录成功");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "登录失败");
    });
  }

  ///注册
  void actionRegister(BuildContext context) {
    RouterHelper.pushNamed(context, RouterConfig.registerPage);
  }

  ///返回操作
  void actionBack(BuildContext context, bool isLogin) {
    RouterHelper.pop<bool>(context, isLogin);
  }

  ///输入框值改变
  void onTextChange(LoginViewModel viewModel) {
    String account = _accountController.text;
    String psw = _pswController.text;

    viewModel.canLogin = account.isNotEmpty && psw.isNotEmpty;
  }

  Widget _bodyContent(BuildContext context, LoginViewModel viewModel) {
    ///CustomScrollView 包裹内容可滚动，避免键盘弹出时页面内容超出范围
    return CustomScrollView(
      slivers: [
        ///使用 SliverToBoxAdapter 将普通组件适配成为sliver可用的内容
        SliverToBoxAdapter(
          child: Stack(
            children: [
              ///logo
              _logoWidget(),

              ///登录表单
              _loginFromWidget(context, viewModel),

              ///注册
              _registerWidget(context),

              ///关闭页面
              _closeWidget()
            ],
          ),
        )
      ],
    );
  }

  ///关闭页面
  Widget _closeWidget() {
    return Positioned(
        left: 20,
        top: ScreenUtil.get().appBarHeight,
        child: GestureDetector(
          onTap: () => actionBack(context, false),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
        ));
  }

  ///logo组件
  Widget _logoWidget() {
    return Container(
      alignment: Alignment.center,
      height: 300,
      color: ColorRes.themeMain,
      child: ImageHelper.assets("ic_logo.png", width: 150, color: Colors.white),
    );
  }

  ///账号Controller
  final TextEditingController _accountController = TextEditingController();

  ///密码Controller
  final TextEditingController _pswController = TextEditingController();

  ///密码焦点
  final _pswNode = FocusNode();

  ///登录表单组件
  Widget _loginFromWidget(BuildContext context, LoginViewModel viewModel) {
    return Container(
      height: 300,
      margin: const EdgeInsets.fromLTRB(30, 250, 30, 0),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      //表单框装饰
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
                color: ColorRes.themeMain.withOpacity(0.3), blurRadius: 10.0)
          ]),
      child: Column(
        children: [
          ///账号
          _textFieldWidget(
              context,
              S.of(context).user_name,
              Icons.perm_identity,
              CupertinoIcons.clear,
              false,
              _accountController,
              TextInputAction.next,
              () => _accountController.clear(),
              onSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(_pswNode),
              onChanged: (_) => onTextChange(viewModel)),

          ///密码
          _textFieldWidget(
              context,
              S.of(context).user_psw,
              Icons.lock_outline,
              viewModel.obscureText
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash_fill,
              viewModel.obscureText,
              _pswController,
              TextInputAction.done,
              () => viewModel.obscureText = !viewModel.obscureText,
              focusNode: _pswNode,
              onChanged: (_) => onTextChange(viewModel)),

          const SizedBox(height: 40),

          ///登录
          _loginButtonWidget(context, viewModel)
        ],
      ),
    );
  }

  ///登录按钮组件
  Widget _loginButtonWidget(BuildContext context, LoginViewModel viewModel) {
    return TextButton(
      onPressed:
          !viewModel.canLogin ? null : () => actionLogin(context, viewModel),
      style: ButtonStyle(
        ///背景
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //不可用状态
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey[400];
          }

          //默认状态
          return ColorRes.themeMain;
        }),

        ///前景：字体
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          //默认状态
          return Colors.white;
        }),

        ///形状
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),

        ///宽高：double.infinity填充父布局
        minimumSize:
            MaterialStateProperty.all(const Size(double.infinity, 50.0)),
      ),
      child: Text(S.of(context).login),
    );
  }

  ///输入框组件
  Widget _textFieldWidget(
      BuildContext context,
      String hintText,
      IconData prefixIcon,
      IconData suffixIcon,
      bool obscureText,
      TextEditingController? controller,
      TextInputAction? textInputAction,
      VoidCallback onSuffixPressed,
      {FocusNode? focusNode,
      ValueChanged<String>? onSubmitted,
      ValueChanged<String>? onChanged}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,

        ///输入框装饰器
        decoration: InputDecoration(
          hintText: hintText,
          //前缀图标
          prefixIcon: Icon(
            prefixIcon,
            size: 28,
            color: ColorRes.themeMain,
          ),
          //后缀图标
          suffix: IconButton(
            onPressed: onSuffixPressed,
            icon: Icon(suffixIcon, size: 24),
          ),
          //默认边框装饰
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!)),
          //获取焦点边框装饰
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorRes.themeMain)),
        ),
        cursorColor: ColorRes.themeMain,
        //密码模式
        obscureText: obscureText,
        //键盘完成按钮样式
        textInputAction: textInputAction,
        //完成按钮事件
        onSubmitted: onSubmitted,
        focusNode: focusNode,
      ),
    );
  }

  ///注册组件
  Widget _registerWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 600),
      child: GestureDetector(
        onTap: () => actionRegister(context),
        child: Text.rich(TextSpan(children: [
          TextSpan(
              text: S.of(context).no_account,
              style: const TextStyle(color: Colors.black)),
          TextSpan(
              text: S.of(context).register_now,
              style: const TextStyle(color: ColorRes.themeMain))
        ])),
      ),
    );
  }
}
