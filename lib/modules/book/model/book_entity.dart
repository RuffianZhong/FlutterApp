import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/book_entity.g.dart';
import 'dart:convert';

///教程实体类
@JsonSerializable()
class BookEntity {
/*
  {
  "author": "阮一峰",
  "cover": "https://www.wanandroid.com/blogimgs/f1cb8d34-82c1-46f7-80fe-b899f56b69c1.png",
  "desc": "C 语言入门教程。",
  "id": 548,
  "lisense": "知识共享 署名-相同方式共享 3.0协议",
  "lisenseLink": "https://creativecommons.org/licenses/by-sa/3.0/deed.zh",
  "name": "C 语言入门教程_阮一峰"
  }*/

	late String author;
	late String cover;
	late String desc;
	late int id;
	late String lisense;
	late String lisenseLink;
	late String name;
  
  BookEntity();

  factory BookEntity.fromJson(Map<String, dynamic> json) => $BookEntityFromJson(json);

  Map<String, dynamic> toJson() => $BookEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}