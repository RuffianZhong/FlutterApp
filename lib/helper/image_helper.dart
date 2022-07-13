import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///Image辅助类
class ImageHelper {
  ///测试用的图片链接
  static List<String> imageUrl = [
    "https://img2.baidu.com/it/u=1994380678,3283034272&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=d57830e0ca280cc0f87fdbf10b25305b",
    "https://img2.baidu.com/it/u=2860188096,638334621&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=cc435e450717a2beb0623dd45752f75f",
    "https://img1.baidu.com/it/u=592570905,1313515675&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=1d3fe5d6db1996aa3b45c8636347869d",
    "https://img2.baidu.com/it/u=4244269751,4000533845&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=9e3bbec87e572ee9bf269a018c71e0ac",
    "https://img1.baidu.com/it/u=2029513305,2137933177&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657213200&t=fc9d00fc14a8feeb19be958ba428ecba",
    "https://img0.baidu.com/it/u=1694074520,2517635995&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1657472400&t=3b8cee3f0f6a844e69f3b43dff3d8465"
  ];

  ///随机URL
  static String randomUrl() {
    return imageUrl[Random().nextInt(imageUrl.length)];
  }

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
