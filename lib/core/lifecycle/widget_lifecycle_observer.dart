import '../lifecycle/widget_lifecycle_state.dart';

import 'widget_lifecycle_owner.dart';

/// 生命周期观察者
/// 通过 onStateChanged 监听 Widget 生命周期变化
/// 任何对象可以通过实现此类，并将自身添加到被观察者中 StateLifecycleObservable ，实现监听 widget 生命周期变化
abstract class WidgetLifecycleObserver {
  /// widget 状态改变回调
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state);
}
