///教程学习进度
class StudyEntity {
  ///表ID
  int? id;

  ///教程ID
  late int bookId;

  ///文章ID：章节ID
  late int articleId;

  ///学习进度
  late double progress;

  ///学习时间
  late int time;

  StudyEntity(
      {this.id,
      required this.bookId,
      required this.articleId,
      required this.progress,
      required this.time});
}
