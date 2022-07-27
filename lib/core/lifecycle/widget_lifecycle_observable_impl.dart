import '../../utils/log_util.dart';
import '../lifecycle/widget_lifecycle_observable.dart';
import '../lifecycle/widget_lifecycle_observer.dart';
import '../lifecycle/widget_lifecycle_owner.dart';
import '../lifecycle/widget_lifecycle_state.dart';

/// State 生命周期可观察对象（被观察者）实现类
/// 管理观察者对象
/// 添加观察者：添加需要生命周期感知的对象
/// 移除观察者：移除不再需要通知的对象
class WidgetLifecycleObservableImpl implements WidgetLifecycleObservable {
  /// 带状态的观察者集合
  /// 理想状态下 set 集合即可满足存储，由于观察者注册时机不确定/不一致，所以需要保存观察者对应的生命周期（可能与widget生命周期不一致）
  final Map<WidgetLifecycleObserver, LifecycleObserverDispatcher> _observerMap =
      {};

  /// 组件当前生命周期状态
  WidgetLifecycleState _widgetLifecycleState = WidgetLifecycleState.onInit;

  /// 具备生命周期感知对象
  final WidgetLifecycleOwner _owner;

  WidgetLifecycleObservableImpl(this._owner);

  /// 添加观察者的时期由开发者控制，有可能不能完整触发整个生命周期，此处需要特殊处理
  /// 添加完成之后需要补充前面已经过去的生命周期（用户在哪里添加观察者无法得知）
  @override
  void addObserver(WidgetLifecycleObserver observer) {
    LifecycleObserverDispatcher observerDispatcher =
        LifecycleObserverDispatcher(_owner, observer);

    _observerMap.putIfAbsent(observer, () => observerDispatcher);

    /// 延迟/补充生命周期分发，如果需要的话
    observerDispatcher.dispatchStateIfNeed(_widgetLifecycleState);
  }

  @override
  void removeObserver(WidgetLifecycleObserver observer) {
    _observerMap.remove(observer);
  }

  /// 设置当前 widget 生命周期
  void setCurrentState(WidgetLifecycleState state) async {
    _widgetLifecycleState = state;
    Logger.log("===set==${_observerMap.length}");
    Logger.log("");
    _dispatchState(state);
  }

  /// 分发当前 widget 生命周期，通知所有被观察者
  void _dispatchState(WidgetLifecycleState state) {
    ///copy方式解决并发修改Map
    Map<WidgetLifecycleObserver, LifecycleObserverDispatcher> map =
        Map.from(_observerMap);

    if (map.isEmpty) return;

    map.forEach((key, value) {
      Logger.log("===for==$_owner--::${key.toString()}--::$state");
      value.dispatchState(state);

      ///分发完onDestroy之后移除对象
      if (state == WidgetLifecycleState.onDestroy) {
        removeObserver(key);
      }
    });
    Logger.log("");
  }
}

/// 观察者分发器
/// 观察者自身生命周期分发类：包括常规分发 和 延迟分发
/// 延迟分发：如果 观察者 在 widget 初始化时注册，那么两者生命周期一直保持同步；如果 观察者 在 widget 生周期中后期才注册，则会丢失已经过去的前期生命周期回调，需要补上
class LifecycleObserverDispatcher {
  /// 观察者
  final WidgetLifecycleObserver observer;

  /// 生命周期感知对象
  final WidgetLifecycleOwner owner;

  LifecycleObserverDispatcher(this.owner, this.observer);

  /// 常规分发：观察者生命周期事件分发
  void dispatchState(WidgetLifecycleState state) {
    /// 生命周期改变回调
    observer.onStateChanged(owner, state);
  }

  /// 延迟分发：如果 观察者 在 widget 初始化时注册，那么两者生命周期一直保持同步；如果 观察者 在 widget 生周期中后期才注册，则会丢失已经过去的前期生命周期回调，需要补上
  /// 延迟/补充的生命周期分发
  /// 如果用户 #addObserver 时机较晚，会导致前期对应的生命周期丢失，这里延迟分发
  void dispatchStateIfNeed(WidgetLifecycleState state) {
    int stateIndex = state.index;

    if (stateIndex >= WidgetLifecycleState.onInit.index) {
      dispatchState(WidgetLifecycleState.onInit);
    }

    if (stateIndex >= WidgetLifecycleState.onCreate.index) {
      dispatchState(WidgetLifecycleState.onCreate);
    }

    if (stateIndex >= WidgetLifecycleState.onStart.index) {
      dispatchState(WidgetLifecycleState.onStart);
    }

    if (stateIndex >= WidgetLifecycleState.onResume.index) {
      dispatchState(WidgetLifecycleState.onResume);
    }

    /// 以下条件几乎不会触发
    if (stateIndex >= WidgetLifecycleState.onPause.index) {
      dispatchState(WidgetLifecycleState.onPause);
    }

    if (stateIndex >= WidgetLifecycleState.onStop.index) {
      dispatchState(WidgetLifecycleState.onStop);
    }

    if (stateIndex >= WidgetLifecycleState.onDestroy.index) {
      dispatchState(WidgetLifecycleState.onDestroy);
    }
  }
}
