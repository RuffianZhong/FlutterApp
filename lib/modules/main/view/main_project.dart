import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

class MainProjectPage extends StatefulWidget {
  const MainProjectPage({Key? key}) : super(key: key);

  @override
  State<MainProjectPage> createState() => _MainProjectPageState();
}

class _MainProjectPageState extends State<MainProjectPage> {
  @override
  Widget build(BuildContext context) {
    Logger.log("project----build");
    return Container(
      child: Text("project"),
    );
  }
}
