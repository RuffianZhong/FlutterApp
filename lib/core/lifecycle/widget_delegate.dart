/// 状态代理接口，对应 State 中生命周期函数
abstract class WidgetDelegate<T> {
  /// 初始化状态，只执行一次，BuildContext 不可用
  /// 类似于 Android 的 onCreate ，iOS 的 viewDidLoad
  /// 备注：此时view并没有渲染，statefulWidget 已经被加载到渲染树中
  void initState();

  /// 初始化完成之后调用，BuildContext上下文可用时期
  void didChangeDependencies();

  /// 从 Widget Tree 中移除 State 对象时会调用，一般用在 dispose 之前；
  void deactivate();

  /// Widget 被销毁时，通常会在此方法中移除监听或清理数据等，整个生命周期只会执行一次；
  void dispose();
}
