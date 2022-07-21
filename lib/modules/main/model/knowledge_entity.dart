import 'category_entity.dart';
import 'nav_entity.dart';

///知识实体类
class KnowledgeEntity {
  ///分类列表
  List<CategoryEntity> categoryList = [];

  ///导航列表
  List<NavEntity> navList = [];
/*
  KnowledgeEntity(
      {List<CategoryEntity>? categoryList, List<NavEntity>? navList}) {
    this.categoryList = categoryList ?? [];
    this.navList = navList ?? [];
  }*/
}
