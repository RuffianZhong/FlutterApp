import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';
import 'package:flutter_wan_android/helper/image_helper.dart';


UserEntity $UserEntityFromJson(Map<String, dynamic> json) {
	final UserEntity userEntity = UserEntity();
	final int? uid = jsonConvert.convert<int>(json['id']);
	if (uid != null) {
		userEntity.uid = uid;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		userEntity.nickname = nickname;
	}
	final int? coinCount = jsonConvert.convert<int>(json['coinCount']);
	if (coinCount != null) {
		userEntity.coinCount = coinCount;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		userEntity.icon = icon;
	}
	return userEntity;
}

Map<String, dynamic> $UserEntityToJson(UserEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.uid;
	data['nickname'] = entity.nickname;
	data['coinCount'] = entity.coinCount;
	data['icon'] = entity.icon;
	return data;
}