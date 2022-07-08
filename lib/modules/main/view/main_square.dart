import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

class MainSquarePage extends StatefulWidget {
  const MainSquarePage({Key? key}) : super(key: key);

  @override
  State<MainSquarePage> createState() => _MainSquarePageState();
}

class _MainSquarePageState extends State<MainSquarePage> {
  @override
  Widget build(BuildContext context) {
    Logger.log("Square----build");
    return Container(
      child: Text("Square"),
    );
  }
}
