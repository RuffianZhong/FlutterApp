import 'canceler.dart';

/// 取消管理类
abstract class CancelManager {
  /// 添加/绑定取消器
  void bindCancel(Object object, Canceler canceler);

  /// 取消/移除cancel
  void cancel(Object object, [dynamic reason]);

  /// 取消/移除全部cancel
  void cancelAll();

  /// 是否已经取消
  bool isCanceled(Object object);

  /// 获取canceler
  Canceler? getCanceler(Object object);
}
