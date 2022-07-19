import 'package:flutter/material.dart';
import 'package:flutter_wan_android/widget/loading_dialog_widget.dart';

class LoadingDialogHelper {
  ///展示loading弹窗
  static void showLoading(BuildContext context, {bool dismissible = false}) {
    showDialog(
        barrierDismissible: dismissible,
        context: context,
        builder: (context) {
          return LoadingDialogWidget(
            dismissible: dismissible,
          );
        });
  }

  ///关闭弹窗
  static void dismissLoading(BuildContext context) {
    Navigator.pop(context);
  }
}
