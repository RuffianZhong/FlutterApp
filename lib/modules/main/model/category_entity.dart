import 'dart:convert';

import 'package:flutter_wan_android/generated/json/base/json_field.dart';

import '../../../generated/json/category_entity.g.dart';

///类别实体
@JsonSerializable()
class CategoryEntity {
  ///一级分类ID
  late int id;
  late String name;

  ///二级分类列表
  @JSONField(name: 'children')
  List<CategoryEntity>? childList;

  CategoryEntity();

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      $CategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => $CategoryEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
