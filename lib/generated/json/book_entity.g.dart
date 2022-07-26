import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/book/model/book_entity.dart';

BookEntity $BookEntityFromJson(Map<String, dynamic> json) {
	final BookEntity bookEntity = BookEntity();
	final String? author = jsonConvert.convert<String>(json['author']);
	if (author != null) {
		bookEntity.author = author;
	}
	final String? cover = jsonConvert.convert<String>(json['cover']);
	if (cover != null) {
		bookEntity.cover = cover;
	}
	final String? desc = jsonConvert.convert<String>(json['desc']);
	if (desc != null) {
		bookEntity.desc = desc;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		bookEntity.id = id;
	}
	final String? lisense = jsonConvert.convert<String>(json['lisense']);
	if (lisense != null) {
		bookEntity.lisense = lisense;
	}
	final String? lisenseLink = jsonConvert.convert<String>(json['lisenseLink']);
	if (lisenseLink != null) {
		bookEntity.lisenseLink = lisenseLink;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		bookEntity.name = name;
	}
	return bookEntity;
}

Map<String, dynamic> $BookEntityToJson(BookEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['author'] = entity.author;
	data['cover'] = entity.cover;
	data['desc'] = entity.desc;
	data['id'] = entity.id;
	data['lisense'] = entity.lisense;
	data['lisenseLink'] = entity.lisenseLink;
	data['name'] = entity.name;
	return data;
}