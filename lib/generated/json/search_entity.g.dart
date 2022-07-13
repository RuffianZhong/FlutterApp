import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/search/model/search_entity.dart';

SearchEntity $SearchEntityFromJson(Map<String, dynamic> json) {
	final SearchEntity searchEntity = SearchEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		searchEntity.id = id;
	}
	final String? value = jsonConvert.convert<String>(json['name']);
	if (value != null) {
		searchEntity.value = value;
	}
	final int? time = jsonConvert.convert<int>(json['time']);
	if (time != null) {
		searchEntity.time = time;
	}
	return searchEntity;
}

Map<String, dynamic> $SearchEntityToJson(SearchEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.value;
	data['time'] = entity.time;
	return data;
}