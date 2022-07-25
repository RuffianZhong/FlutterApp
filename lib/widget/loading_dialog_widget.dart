import 'package:flutter/material.dart';

import '../res/color_res.dart';

///Loading弹窗
///网络请求等场景使用
class LoadingDialogWidget extends StatelessWidget {
  bool dismissible = false;

  LoadingDialogWidget({Key? key, required this.dismissible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ///拦截返回导航
        WillPopScope(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[200]),
              padding: const EdgeInsets.all(20),
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey[300],
              ),
            ),

            ///拦截返回按钮：false = 不允许通过返回按钮关闭弹窗
            onWillPop: () => Future.value(dismissible))
      ],
    );
  }
}
