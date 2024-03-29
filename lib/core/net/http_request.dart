import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_wan_android/helper/cookie_helper.dart';

import '../../utils/log_util.dart';
import '../net/http_config.dart';
import '../net/observer/http_lifecycle_observer.dart';
import 'cancel/zt_http_cancel.dart';

class HttpRequest {
  /// 全局请求配置
  /// URL/超时时间/headers...
  static final BaseOptions baseOptions = BaseOptions(
      baseUrl: HttpConfig.baseUrl, connectTimeout: HttpConfig.timeout);

  ///dio实例
  static final Dio dio = Dio(baseOptions);

  /// http取消管理类
  static final HttpCancelManager httpCancelManager = HttpCancelManager();

  /// GET
  static Future<T> get<T>(
    String url, {
    HttpCanceler? canceler,
    data,
    Map<String, dynamic>? params,
    Interceptor? inter,
    ProgressCallback? sendProgress,
    ProgressCallback? receiveProgress,
  }) async {
    /// 检查是否需要生命周期感知
    checkLifecycleAware(canceler);

    return await request<T>(url,
        method: "get",
        data: data,
        params: params,
        inter: inter,
        token: canceler?.cancelToken,
        sendProgress: sendProgress,
        receiveProgress: receiveProgress);
  }

  /// POST
  static Future<T> post<T>(
    String url, {
    HttpCanceler? canceler,
    data,
    Map<String, dynamic>? params,
    Interceptor? inter,
    ProgressCallback? sendProgress,
    ProgressCallback? receiveProgress,
  }) async {
    /// 检查是否需要生命周期感知
    checkLifecycleAware(canceler);

    return request<T>(url,
        method: "post",
        data: data,
        params: params,
        inter: inter,
        token: canceler?.cancelToken,
        sendProgress: sendProgress,
        receiveProgress: receiveProgress);
  }

  /// 网络请求最终实现
  static Future<T> request<T>(
    String url, {
    String method = "get",
    data,
    Map<String, dynamic>? params,
    Interceptor? inter,
    CancelToken? token,
    ProgressCallback? sendProgress,
    ProgressCallback? receiveProgress,
  }) async {
    // 1.请求的单独配置
    final options = Options(method: method);

    // 2.添加拦截器：添加日志，处理响应数据等
    Interceptor dInter = InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      Logger.log("Request:");
      Logger.log("url = ${options.baseUrl}${options.path}");
      Logger.log("params = ${json.encode(options.queryParameters)}");
      //这里处理请求拦截器，默认直接next
      handler.next(options);
    }, onResponse: (Response e, ResponseInterceptorHandler handler) {
      Logger.log("Response:");
      Logger.log(json.encode(e.data));
      //这里处理结果拦截
      handler.next(e);
    }, onError: (DioError e, ErrorInterceptorHandler handler) {
      //这里处理错误拦截
      handler.next(e);
    });

    List<Interceptor> inters = [dInter];
    if (inter != null) {
      inters.add(inter);
    }

    /// 此处不能无限叠加拦截器
    dio.interceptors.clear();
    dio.interceptors.addAll(inters);

    ///添加cookie
    dio.interceptors.add(CookieManager(await CookieHelper.cookieJar));

    // 3.发送网络请求
    try {
      Response response = await dio.request<T>(url,
          queryParameters: params,
          data: data,
          options: options,
          cancelToken: token,
          onSendProgress: sendProgress,
          onReceiveProgress: receiveProgress);
      return response.data;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  /// 检查是否需要生命周期感知
  /// 存在标识需要管理生命周期，在 页面销毁时/指定生命周期中 取消网络请求
  static void checkLifecycleAware(HttpCanceler? canceler) {
    /// 需要管理生命周期
    if (canceler != null) {
      httpCancelManager.bindCancel(canceler.lifecycleOwner, canceler);
      canceler.lifecycleOwner
          .getLifecycle()
          .addObserver(HttpLifecycleObserver(httpCancelManager, canceler));
    }
  }
}
