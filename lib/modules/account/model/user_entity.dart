import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/user_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserEntity {

	late int uid;
	late String nickname;
  
  UserEntity();

  factory UserEntity.fromJson(Map<String, dynamic> json) => $UserEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}