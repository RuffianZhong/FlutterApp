import 'package:flutter_wan_android/generated/json/base/json_field.dart';
import 'package:flutter_wan_android/generated/json/user_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserEntity {
  int? uid = 0;
  String? nickname = "";

  ///积分
  int? coinCount = 0;
  String? icon = "";

  UserEntity({this.uid, this.nickname});

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      $UserEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
