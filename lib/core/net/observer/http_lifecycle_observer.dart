import '../cancel/http_canceler.dart';
import '../cancel/http_cancel_manager.dart';
import '../../lifecycle/zt_lifecycle.dart';

class HttpLifecycleObserver implements WidgetLifecycleObserver {
  /// http取消管理类
  final HttpCancelManager httpCancelManager;

  /// http 取消器
  /// 可以从 HttpCancelManager 中获取，此处认为 onStateChanged 回调频繁，通过成员变量的方式更优
  final HttpCanceler httpCanceler;

  HttpLifecycleObserver(this.httpCancelManager, this.httpCanceler);

  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    print("---test-----come:$state----owner:$owner");

    /// 目标组件，目标生命周期状态：取消网络请求
    if (httpCanceler.lifecycleOwner == owner &&
        httpCanceler.lifecycleState == state) {
      httpCancelManager.cancel(owner);
    }
  }
}
