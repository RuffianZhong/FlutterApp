import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';

import '../../../generated/l10n.dart';
import '../../../res/color_res.dart';

///注册页面
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyContent(context),
    );
  }

  Widget _bodyContent(BuildContext context) {
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
              _registerFromWidget(context),
            ],
          ),
        )
      ],
    );
  }

  ///logo组件
  Widget _logoWidget() {
    return Container(
      alignment: Alignment.center,
      height: 300,
      color: ColorRes.themeMain,
      child: Image.asset(ImageHelper.wrapAssets("ic_logo.png"),
          width: 150, color: Colors.white),
    );
  }

  ///注册表单组件
  Widget _registerFromWidget(BuildContext context) {
    final pswNode = FocusNode();
    final pswConfirmNode = FocusNode();
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
              null,
              TextInputAction.next,
              null,
              (value) {},
              (value) {
                FocusScope.of(context).requestFocus(pswNode);
              },
              () {},
              (value) {
                if (value != null) {
                  return value.trim().isNotEmpty ? null : "字段不能为空";
                }
              }),

          ///密码
          _textFieldWidget(
              context,
              S.of(context).user_psw,
              Icons.lock_outline,
              CupertinoIcons.eye,
              true,
              pswNode,
              TextInputAction.next,
              null,
              (value) {}, (value) {
            FocusScope.of(context).requestFocus(pswConfirmNode);
          }, () {}, null),

          ///确认密码
          _textFieldWidget(
              context,
              S.of(context).user_psw_confirm,
              Icons.lock_outline,
              CupertinoIcons.eye,
              true,
              pswConfirmNode,
              TextInputAction.done,
              null,
              (value) {},
              (value) {},
              () {},
              null),

          const SizedBox(height: 40),

          ///注册
          _registerButtonWidget(context)
        ],
      ),
    );
  }

  ///注册按钮组件
  Widget _registerButtonWidget(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
      child: Text(S.of(context).register),
    );
  }

  ///输入框组件
  Widget _textFieldWidget(
      BuildContext context,
      String hintText,
      IconData prefixIcon,
      IconData suffixIcon,
      bool obscureText,
      FocusNode? focusNode,
      TextInputAction? textInputAction,
      TextEditingController? controller,
      ValueChanged<String>? onChanged,
      ValueChanged<String>? onFieldSubmitted,
      VoidCallback onSuffixPressed,
      FormFieldValidator<String>? validator) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
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
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        focusNode: focusNode,
      ),
    );
  }
}
