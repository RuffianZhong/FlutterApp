import 'dart:convert';

import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/search_entity.g.dart';

@JsonSerializable()
class SearchEntity {
/*
	late int id;
	late String value;
	late int time;
  
  SearchEntity();*/

  int? id;
  @JSONField(name: "name", serialize: true, deserialize: true)
  String? value = "";
  int? time = 0;

  SearchEntity({this.id, this.value, this.time});

  factory SearchEntity.fromJson(Map<String, dynamic> json) =>
      $SearchEntityFromJson(json);

  Map<String, dynamic> toJson() => $SearchEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
