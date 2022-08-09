import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';
import 'package:flutter_wan_android/utils/toast_util.dart';
import 'package:flutter_wan_android/widget/loading_dialog_helper.dart';
import 'package:provider/provider.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../generated/l10n.dart';
import '../../../helper/router_helper.dart';
import '../../../utils/screen_util.dart';
import '../view_model/register_view_model.dart';
import '../widget/login_button.dart';
import '../widget/login_text_field.dart';

///注册页面
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with Lifecycle {
  ///账号Controller
  final TextEditingController _accountController = TextEditingController();

  ///密码Controller
  final TextEditingController _pswController = TextEditingController();

  ///确认密码Controller
  final TextEditingController _pswConfirmController = TextEditingController();

  ///密码焦点
  final _pswNode = FocusNode();

  ///确认密码焦点
  final _pswConfirmNode = FocusNode();

  ///HttpCanceler
  late HttpCanceler httpCanceler;

  @override
  void initState() {
    super.initState();
    httpCanceler = HttpCanceler(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => RegisterViewModel())
        ],
        child:
            Consumer<RegisterViewModel>(builder: (context, viewModel, child) {
          return Scaffold(
            body: _bodyContent(context, viewModel),
          );
        }));
  }

  ///登录
  void actionRegister(BuildContext context, RegisterViewModel viewModel) {
    String account = _accountController.text.trim();
    String psw = _pswController.text.trim();
    String pswConfirm = _pswConfirmController.text.trim();

    if (account.isEmpty) {
      ToastUtil.showToast(msg: S.of(context).account_empty_tip);
      return;
    }
    if (psw.isEmpty) {
      ToastUtil.showToast(msg: S.of(context).psw_empty_tip);
      return;
    }

    if (pswConfirm.isEmpty) {
      ToastUtil.showToast(msg: S.of(context).psw_confirm_empty_tip);
      return;
    }

    if (Comparable.compare(psw, pswConfirm) != 0) {
      ToastUtil.showToast(msg: S.of(context).psw_confirm_tip);
      return;
    }

    LoadingDialogHelper.showLoading(context);

    ///注册
    viewModel.model
        .register(account, psw, pswConfirm, httpCanceler)
        .then((result) {
          if (result.success) {
            ToastUtil.showToast(msg: S.of(context).register_success);
            actionBack(context, result: account); //回到登录页面
            //viewModel.model.saveUserData(result.data!);
            //RouterHelper.popUntil(context, ""); //直接回到首页
          } else {
            ToastUtil.showToast(msg: result.msg ?? "");
          }
        })
        .onError((error, stackTrace) =>
            ToastUtil.showToast(msg: S.of(context).net_error))
        .whenComplete(() => LoadingDialogHelper.dismissLoading(context));
  }

  ///返回操作
  void actionBack(BuildContext context, {String? result}) {
    RouterHelper.pop<String>(context, result);
  }

  ///输入框值改变
  void onTextChange(RegisterViewModel viewModel) {
    String account = _accountController.text.trim();
    String psw = _pswController.text.trim();
    String pswConfirm = _pswConfirmController.text.trim();

    viewModel.canRegister =
        account.isNotEmpty && psw.isNotEmpty && pswConfirm.isNotEmpty;
  }

  Widget _bodyContent(BuildContext context, RegisterViewModel viewModel) {
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
              _registerFromWidget(context, viewModel),

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
          onTap: () => actionBack(context),
          child: const Icon(
            Icons.arrow_back,
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
      child: Image.asset(ImageHelper.wrapAssets("ic_logo.png"),
          width: 150, color: Colors.white),
    );
  }

  ///注册表单组件
  Widget _registerFromWidget(
      BuildContext context, RegisterViewModel viewModel) {
    return Container(
      height: 380,
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
              suffixIcon: viewModel.secretPsw
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash_fill,
              obscureText: viewModel.secretPsw,
              controller: _pswController,
              textInputAction: TextInputAction.next,
              onSuffixPressed: () => viewModel.secretPsw = !viewModel.secretPsw,
              focusNode: _pswNode,
              onSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(_pswConfirmNode),
              onChanged: (_) => onTextChange(viewModel)),

          ///确认密码
          LoginTextField(
              hintText: S.of(context).user_psw_confirm,
              prefixIcon: Icons.lock_outline,
              suffixIcon: viewModel.secretPswConfirm
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash_fill,
              obscureText: viewModel.secretPswConfirm,
              controller: _pswConfirmController,
              textInputAction: TextInputAction.done,
              onSuffixPressed: () =>
                  viewModel.secretPswConfirm = !viewModel.secretPswConfirm,
              focusNode: _pswConfirmNode,
              onChanged: (_) => onTextChange(viewModel)),

          const SizedBox(height: 40),

          ///注册
          LoginButton(
              text: S.of(context).register,
              canSubmit: viewModel.canRegister,
              onPressed: () => actionRegister(context, viewModel)),
        ],
      ),
    );
  }
}
