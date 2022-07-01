import 'package:flutter/cupertino.dart';
import '../lifecycle/widget_delegate_impl.dart';
import '../lifecycle/widget_lifecycle_observable.dart';
import '../lifecycle/widget_lifecycle_owner.dart';

/// 实现生命周期感知的 State
/// 继承此类，添加 observer 可以实现 observer 具备生命周期感知功能
abstract class ZTLifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetLifecycleOwner {
  ///代理实现类
  WidgetDelegateImpl? _stateDelegate;

  @override
  @protected
  @mustCallSuper
  void activate() {
    super.activate();
    // print("==activate==$this");
  }

  @override
  @protected
  @mustCallSuper
  void reassemble() {
    super.reassemble();
    // print("==reassemble==$this");
  }

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    // print("==initState==$this");
    _getDelegate().initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //  print("==didChangeDependencies==$this");
    _getDelegate().didChangeDependencies();
  }

  @override
  @mustCallSuper
  @protected
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print("==didUpdateWidget==$this");
  }

  @override
  @protected
  @mustCallSuper
  void deactivate() {
    super.deactivate();
    // print("==deactivate==$this");
    _getDelegate().deactivate();
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    //  print("==dispose==$this");
    _getDelegate().dispose();
    super.dispose();
  }

  /// 获取生命周期感知对象，用来管理观察者对象
  @override
  WidgetLifecycleObservable getLifecycle() {
    return _getDelegate().getLifecycle();
  }

  ///获取代理对象
  WidgetDelegateImpl _getDelegate() {
    return _stateDelegate ??= WidgetDelegateImpl(this, this);
  }
}
