import '../lifecycle/widget_lifecycle_observable.dart';

/// StateLifecycleObservable 持有者
/// 生命周期被观察者对象的持有者，对外提供被观察者对象
/// State 需要继承/混入/实现
abstract class WidgetLifecycleOwner {
  WidgetLifecycleObservable getLifecycle();
}
