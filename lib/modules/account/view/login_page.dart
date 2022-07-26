import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/config/router_config.dart';
import 'package:flutter_wan_android/core/lifecycle/zt_lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/helper/router_helper.dart';
import 'package:flutter_wan_android/modules/account/view_model/login_view_model.dart';
import 'package:flutter_wan_android/utils/screen_util.dart';
import 'package:flutter_wan_android/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../generated/l10n.dart';
import '../../../utils/log_util.dart';
import '../../../widget/loading_dialog_helper.dart';
import '../widget/login_button.dart';
import '../widget/login_text_field.dart';

///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ZTLifecycleState<LoginPage>
    with WidgetLifecycleObserver {
  late BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    getLifecycle().addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginViewModel())
        ],
        child: Consumer<LoginViewModel>(builder: (context, viewModel, child) {
          _buildContext = context;
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
      ToastUtil.showToast(msg: S.of(context).account_empty_tip);
      return;
    }
    if (psw.isEmpty) {
      ToastUtil.showToast(msg: S.of(context).psw_empty_tip);
    }

    LoadingDialogHelper.showLoading(context);

    ///登录
    viewModel.model
        .login(account, psw, HttpCanceler(this))
        .then((result) {
          if (result.success) {
            ToastUtil.showToast(msg: S.of(context).login_success);

            viewModel.model.saveUser(result.data!);

            actionBack(context, true);
          } else {
            ToastUtil.showToast(msg: result.msg ?? "");
          }
        })
        .onError((error, stackTrace) =>
            ToastUtil.showToast(msg: S.of(context).net_error))
        .whenComplete(() => LoadingDialogHelper.dismissLoading(context));
  }

  ///注册
  void actionRegister(BuildContext context) {
    RouterHelper.pushNamed(context, RouterConfig.registerPage).then((value) {
      Logger.log("-----pushNamed----$value");
      if (value != null) {
        initData(context, account: value);
      }
    });
  }

  ///返回操作
  void actionBack(BuildContext context1, bool isLogin) {
    RouterHelper.pop<bool>(context, isLogin);
  }

  ///输入框值改变
  void onTextChange(LoginViewModel viewModel) {
    String account = _accountController.text;
    String psw = _pswController.text;

    viewModel.canLogin = account.isNotEmpty && psw.isNotEmpty;
  }

  ///初始化数据
  void initData(BuildContext context, {String? account}) async {
    account ??= (await context.read<LoginViewModel>().model.getUser()).nickname;

    if (account != null && account.isNotEmpty) {
      _accountController.text = account;
      _accountController.selection =
          TextSelection.collapsed(offset: account.length);
    }
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
      color: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 10.0)
          ]),
      child: Column(
        children: [
          ///账号
          LoginTextField(
              hintText: S.of(context).user_name,
              prefixIcon: Icons.perm_identity,
              suffixIcon: CupertinoIcons.clear,
              obscureText: false,
              controller: _accountController,
              textInputAction: TextInputAction.next,
              onSuffixPressed: () => _accountController.clear(),
              onSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(_pswNode),
              onChanged: (_) => onTextChange(viewModel)),

          ///密码
          LoginTextField(
              hintText: S.of(context).user_psw,
              prefixIcon: Icons.lock_outline,
              suffixIcon: viewModel.obscureText
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash_fill,
              obscureText: viewModel.obscureText,
              controller: _pswController,
              textInputAction: TextInputAction.done,
              onSuffixPressed: () =>
                  viewModel.obscureText = !viewModel.obscureText,
              focusNode: _pswNode,
              onChanged: (_) => onTextChange(viewModel)),

          const SizedBox(height: 40),

          ///登录
          LoginButton(
              text: S.of(context).login,
              canSubmit: viewModel.canLogin,
              onPressed: () => actionLogin(context, viewModel)),
        ],
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
              style: TextStyle(color: Theme.of(context).primaryColor))
        ])),
      ),
    );
  }

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onCreate) {
      initData(_buildContext);
    }
  }
}
