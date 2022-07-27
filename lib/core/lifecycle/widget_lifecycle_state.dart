/// widget 生命周期状态
enum WidgetLifecycleState {
  ///初始化，触发一次
  /// onInit：初始化状态，单场景调用
  ///         BuildContext 在初始化时期不可用
  onInit,

  ///创建，触发一次
  /// onCreate：widget 完成创建，完成首帧绘制，单场景调用
  onCreate,

  ///开始执行，可能触发多次
  /// onStart：widget 开始执行，多场景调用， 与 #onStop 成对
  onStart,

  ///恢复执行，重新回到可执行状态，可能触发多次
  /// onResume：widget 恢复执行，在widget重新回到用户视野/回到前台获取焦点时调用，多场景调用，与 #onPause 成对
  onResume,

  ///挂起执行，暂停执行，可能执行多次
  /// onPause：widget 挂起执行，在widget失去焦点/进入后台/被系统或自定义的非全屏弹窗遮挡时调用，多场景调用，与 #onResume 成对
  onPause,

  ///停止执行，可能执行多次
  /// onStop：widget 停止执行，在widget完全离开用户视野/进入后台/被系统或自定义的全屏弹窗遮挡时调用，多场景调用，与 #onStart 成对
  onStop,

  ///销毁，执行一次
  /// onDestroy：widget 销毁，页面销毁/退出程序时调用，单场景调用
  onDestroy;
}
