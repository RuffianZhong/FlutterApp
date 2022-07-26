import 'package:flutter/material.dart';

///登录输入框
class LoginTextField extends StatefulWidget {
  String hintText;
  IconData prefixIcon;
  IconData suffixIcon;
  bool obscureText;
  TextEditingController controller;
  TextInputAction textInputAction;
  VoidCallback onSuffixPressed;

  FocusNode? focusNode;
  ValueChanged<String>? onSubmitted;
  ValueChanged<String>? onChanged;

  LoginTextField(
      {Key? key,
      required this.hintText,
      required this.prefixIcon,
      required this.suffixIcon,
      required this.obscureText,
      required this.controller,
      required this.textInputAction,
      required this.onSuffixPressed,
      this.focusNode,
      this.onSubmitted,
      this.onChanged})
      : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextField(
        style: TextStyle(fontSize: 16, color: Colors.grey[900]),
        controller: widget.controller,
        onChanged: widget.onChanged,

        ///输入框装饰器
        decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          hintText: widget.hintText,
          //前缀图标
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 28,
            color: Theme.of(context).primaryColor,
          ),
          //后缀图标
          suffix: IconButton(
            onPressed: widget.onSuffixPressed,
            icon: Icon(widget.suffixIcon, size: 24),
          ),
          //默认边框装饰
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!)),
          //获取焦点边框装饰
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        ),
        cursorColor: Theme.of(context).primaryColor,
        //密码模式
        obscureText: widget.obscureText,
        //键盘完成按钮样式
        textInputAction: widget.textInputAction,
        //完成按钮事件
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
      ),
    );
  }
}
