import '../lifecycle/widget_lifecycle_observer.dart';

/// State 生命周期可观察对象（被观察者）
/// 管理观察者对象，添加观察者，移除观察者
abstract class WidgetLifecycleObservable {
  /// 添加观察者
  /// 在 #initState() 中添加观察者
  void addObserver(WidgetLifecycleObserver observer);

  /// 移除观察者
  void removeObserver(WidgetLifecycleObserver observer);
}
