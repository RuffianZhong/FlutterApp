import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/article_rsp_entity.g.dart';
import 'dart:convert';

import 'package:flutter_wan_android/modules/main/model/article_entity.dart';

@JsonSerializable()
class ArticleRspEntity {
  late int curPage;
  late List<ArticleEntity> datas;
  late int offset;
  late bool over;
  late int pageCount;
  late int size;
  late int total;

  ArticleRspEntity();

  factory ArticleRspEntity.fromJson(Map<String, dynamic> json) =>
      $ArticleRspEntityFromJson(json);

  Map<String, dynamic> toJson() => $ArticleRspEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
