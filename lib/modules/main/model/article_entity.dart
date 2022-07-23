import 'dart:convert';

import 'package:flutter_wan_android/generated/json/article_entity.g.dart';
import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';

import '../../../generated/json/base/json_convert_content.dart';
import '../../book/model/study_entity.dart';

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

  ///文章可能是在多级，此字段是文章所属的直系分类ID
  int? chapterId;

  ///简介，副标题
  String? desc;

  ///封面
  @JSONField(name: "envelopePic")
  String? cover;

  ///是否置顶
  bool? isTop = false;

  ///是否收藏
  bool? collect = false;

  ///学习进度：不参与自动解析
  @JSONField(name: "", deserialize: false, serialize: false)
  StudyEntity? study;

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
