import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';

UserEntity $UserEntityFromJson(Map<String, dynamic> json) {
	final UserEntity userEntity = UserEntity();
	final int? uid = jsonConvert.convert<int>(json['uid']);
	if (uid != null) {
		userEntity.uid = uid;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		userEntity.nickname = nickname;
	}
	return userEntity;
}

Map<String, dynamic> $UserEntityToJson(UserEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['uid'] = entity.uid;
	data['nickname'] = entity.nickname;
	return data;
}