import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/banner_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class BannerEntity {

	late int id;
	late String imagePath;
	late String title;
	late String url;
  
  BannerEntity();

  factory BannerEntity.fromJson(Map<String, dynamic> json) => $BannerEntityFromJson(json);

  Map<String, dynamic> toJson() => $BannerEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}