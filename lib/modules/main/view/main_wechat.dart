import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

class MainWeChatPage extends StatefulWidget {
  const MainWeChatPage({Key? key}) : super(key: key);

  @override
  State<MainWeChatPage> createState() => _MainWeChatPageState();
}

class _MainWeChatPageState extends State<MainWeChatPage> {
  @override
  Widget build(BuildContext context) {
    Logger.log("WeChat----build");
    return Container(
      child: Text("WeChat"),
    );
  }
}
