import 'package:dio/dio.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'canceler.dart';

/// Http 消除器/取消管理者
class HttpCanceler implements Canceler {
  final LifecycleOwner lifecycleOwner; //生命周期感知对象
  final CancelToken cancelToken; //dio 取消Token
  final LifecycleState lifecycleState; //widget生命周期状态

  HttpCanceler(this.lifecycleOwner,
      {CancelToken? cancelToken, LifecycleState? lifecycleState})
      : cancelToken = cancelToken ?? CancelToken(),
        lifecycleState = lifecycleState ?? LifecycleState.onDestroy;

  @override
  void cancel({reason}) {
    cancelToken.cancel(reason);
  }
}
