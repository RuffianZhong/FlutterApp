import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';

import '../cancel/http_cancel_manager.dart';
import '../cancel/http_canceler.dart';

class HttpLifecycleObserver implements LifecycleObserver {
  /// http取消管理类
  final HttpCancelManager httpCancelManager;

  /// http 取消器
  /// 可以从 HttpCancelManager 中获取，此处认为 onStateChanged 回调频繁，通过成员变量的方式更优
  final HttpCanceler httpCanceler;

  HttpLifecycleObserver(this.httpCancelManager, this.httpCanceler);

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    /// 目标组件，目标生命周期状态：取消网络请求
    if (httpCanceler.lifecycleOwner == owner &&
        httpCanceler.lifecycleState == state) {
      httpCancelManager.cancel(owner);
    }
  }
}
