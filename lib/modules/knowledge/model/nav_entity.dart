import 'dart:convert';

import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/nav_entity.g.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';

///导航实体类
@JsonSerializable()
class NavEntity {
  ///导航列表（文章列表）
  late List<ArticleEntity> articles;

  ///导航ID
  late int cid;

  ///导航名称
  late String name;

  NavEntity();

  factory NavEntity.fromJson(Map<String, dynamic> json) =>
      $NavEntityFromJson(json);

  Map<String, dynamic> toJson() => $NavEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
