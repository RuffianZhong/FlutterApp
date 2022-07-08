import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///Image辅助类
class ImageHelper {
  ///assets路径转换
  static String wrapAssets(String url) {
    return "assets/images/$url";
  }

  /// 加载网络图片（带缓存）
  /// imageUrl：图片地址
  /// placeholder：加载中占位符
  /// errorWidget：加载失败占位符
  static Widget load(String imageUrl,
      {double? height,
      double? width,
      BoxFit? fit,
      Widget? placeholder,
      Widget? error}) {
    Widget placeholderWidget =
        placeholder ??= const CircularProgressIndicator();
    Widget errorWidget = error ??= const Icon(Icons.error);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => placeholderWidget,
      errorWidget: (context, url, error) => errorWidget,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
