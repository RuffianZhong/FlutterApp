import 'package:dio/dio.dart';
import 'canceler.dart';
import '../../lifecycle/zt_lifecycle.dart';

/// Http 消除器/取消管理者
class HttpCanceler implements Canceler {
  final WidgetLifecycleOwner lifecycleOwner; //生命周期感知对象
  final CancelToken cancelToken; //dio 取消Token
  final WidgetLifecycleState lifecycleState; //widget生命周期状态

  HttpCanceler(this.lifecycleOwner,
      {CancelToken? cancelToken, WidgetLifecycleState? lifecycleState})
      : cancelToken = cancelToken ?? CancelToken(),
        lifecycleState = lifecycleState ?? WidgetLifecycleState.onDestroy;
}
