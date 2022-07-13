import 'package:flutter_wan_android/generated/json/base/json_convert_content.dart';
import 'package:flutter_wan_android/modules/main/model/article_rsp_entity.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';


ArticleRspEntity $ArticleRspEntityFromJson(Map<String, dynamic> json) {
	final ArticleRspEntity articleRspEntity = ArticleRspEntity();
	final int? curPage = jsonConvert.convert<int>(json['curPage']);
	if (curPage != null) {
		articleRspEntity.curPage = curPage;
	}
	final List<ArticleEntity>? datas = jsonConvert.convertListNotNull<ArticleEntity>(json['datas']);
	if (datas != null) {
		articleRspEntity.datas = datas;
	}
	final int? offset = jsonConvert.convert<int>(json['offset']);
	if (offset != null) {
		articleRspEntity.offset = offset;
	}
	final bool? over = jsonConvert.convert<bool>(json['over']);
	if (over != null) {
		articleRspEntity.over = over;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		articleRspEntity.pageCount = pageCount;
	}
	final int? size = jsonConvert.convert<int>(json['size']);
	if (size != null) {
		articleRspEntity.size = size;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		articleRspEntity.total = total;
	}
	return articleRspEntity;
}

Map<String, dynamic> $ArticleRspEntityToJson(ArticleRspEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['curPage'] = entity.curPage;
	data['datas'] =  entity.datas.map((v) => v.toJson()).toList();
	data['offset'] = entity.offset;
	data['over'] = entity.over;
	data['pageCount'] = entity.pageCount;
	data['size'] = entity.size;
	data['total'] = entity.total;
	return data;
}