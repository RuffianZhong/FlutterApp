import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';


ArticleEntity $ArticleEntityFromJson(Map<String, dynamic> json) {
	final ArticleEntity articleEntity = ArticleEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		articleEntity.id = id;
	}
	final String? userName = jsonConvert.convert<String>(json['shareUser']);
	if (userName != null) {
		articleEntity.userName = userName;
	}
	final String? userIcon = jsonConvert.convert<String>(json['userIcon']);
	if (userIcon != null) {
		articleEntity.userIcon = userIcon;
	}
	final String? link = jsonConvert.convert<String>(json['link']);
	if (link != null) {
		articleEntity.link = link;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		articleEntity.title = title;
	}
	final String? date = jsonConvert.convert<String>(json['niceDate']);
	if (date != null) {
		articleEntity.date = date;
	}
	final String? superChapterName = jsonConvert.convert<String>(json['superChapterName']);
	if (superChapterName != null) {
		articleEntity.superChapterName = superChapterName;
	}
	final String? chapterName = jsonConvert.convert<String>(json['chapterName']);
	if (chapterName != null) {
		articleEntity.chapterName = chapterName;
	}
	final String? desc = jsonConvert.convert<String>(json['desc']);
	if (desc != null) {
		articleEntity.desc = desc;
	}
	final String? cover = jsonConvert.convert<String>(json['cover']);
	if (cover != null) {
		articleEntity.cover = cover;
	}
	final bool? isTop = jsonConvert.convert<bool>(json['isTop']);
	if (isTop != null) {
		articleEntity.isTop = isTop;
	}
	return articleEntity;
}

Map<String, dynamic> $ArticleEntityToJson(ArticleEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['shareUser'] = entity.userName;
	data['userIcon'] = entity.userIcon;
	data['link'] = entity.link;
	data['title'] = entity.title;
	data['niceDate'] = entity.date;
	data['superChapterName'] = entity.superChapterName;
	data['chapterName'] = entity.chapterName;
	data['desc'] = entity.desc;
	data['cover'] = entity.cover;
	data['isTop'] = entity.isTop;
	return data;
}