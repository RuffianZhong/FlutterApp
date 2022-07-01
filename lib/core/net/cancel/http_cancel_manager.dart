import 'cancel_manager.dart';
import 'canceler.dart';
import 'http_canceler.dart';

/// Http 取消管理类
class HttpCancelManager implements CancelManager {
  ///  http 取消器集合
  Map<Object, HttpCanceler> map = {};

  @override
  void bindCancel(Object object, Canceler canceler) {
    map[object] = canceler as HttpCanceler;
  }

  @override
  bool isCanceled(Object object) {
    if (map.isEmpty) return true;
    HttpCanceler canceler = map[object] as HttpCanceler;
    return canceler.cancelToken.isCancelled;
  }

  @override
  void cancelAll() {
    if (map.isEmpty) return;

    /// 移除所有请求
    map.forEach((key, value) {
      cancel(key);
    });
  }

  @override
  void cancel(Object object, [dynamic reason]) {
    if (map.isEmpty) return;
    if (map[object] == null) return;

    /// 取消网络请求
    HttpCanceler canceler = map[object] as HttpCanceler;
    if (!canceler.cancelToken.isCancelled) {
      ///依据生命周期取消
      canceler.cancelToken.cancel(reason ?? "canceled base on lifecycle.");
    }

    /// 移除对象
    map.remove(object);
  }

  @override
  Canceler? getCanceler(Object object) {
    return map[object] as HttpCanceler;
  }
}
