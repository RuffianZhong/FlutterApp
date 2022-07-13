import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/article_entity.g.dart';
import 'dart:convert';

import 'package:flutter_wan_android/helper/image_helper.dart';

import '../../../generated/json/base/json_convert_content.dart';

@JsonSerializable()
class ArticleEntity {
  late int id;
  @JSONField(name: "shareUser")
  String? userName;
  String? userIcon;
  String? link;
  String? title;
  @JSONField(name: "niceDate")
  String? date;

  ///主分类
  String? superChapterName;

  ///副级分类
  String? chapterName;
  String? desc;

  ///封面
  String? cover;

  ///是否置顶
  bool? isTop;

  ArticleEntity();

  factory ArticleEntity.fromJson(Map<String, dynamic> json) {
    ArticleEntity entity = $ArticleEntityFromJson(json);
    entity.userIcon = ImageHelper.randomUrl();
    if (entity.userName == null || entity.userName == "") {
      entity.userName = jsonConvert.convert<String>(json['author']);
    }
    return entity;
  }

  Map<String, dynamic> toJson() => $ArticleEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
