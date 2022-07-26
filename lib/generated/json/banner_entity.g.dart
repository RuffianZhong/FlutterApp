import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/home/model/banner_entity.dart';

BannerEntity $BannerEntityFromJson(Map<String, dynamic> json) {
	final BannerEntity bannerEntity = BannerEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		bannerEntity.id = id;
	}
	final String? imagePath = jsonConvert.convert<String>(json['imagePath']);
	if (imagePath != null) {
		bannerEntity.imagePath = imagePath;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		bannerEntity.title = title;
	}
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		bannerEntity.url = url;
	}
	return bannerEntity;
}

Map<String, dynamic> $BannerEntityToJson(BannerEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['imagePath'] = entity.imagePath;
	data['title'] = entity.title;
	data['url'] = entity.url;
	return data;
}