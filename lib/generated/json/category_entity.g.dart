import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/project/model/category_entity.dart';

CategoryEntity $CategoryEntityFromJson(Map<String, dynamic> json) {
	final CategoryEntity categoryEntity = CategoryEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		categoryEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		categoryEntity.name = name;
	}
	final List<CategoryEntity>? childList = jsonConvert.convertListNotNull<CategoryEntity>(json['children']);
	if (childList != null) {
		categoryEntity.childList = childList;
	}
	return categoryEntity;
}

Map<String, dynamic> $CategoryEntityToJson(CategoryEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['children'] =  entity.childList?.map((v) => v.toJson()).toList();
	return data;
}