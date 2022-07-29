import '../helper/db_helper.dart';

///数据库操作相关Dao抽象基类
abstract class AbsDao {
  ///数据库辅助类
  late SqliteHelper helper;

  AbsDao() {
    helper = SqliteHelper();
  }

  ///使用完一定要关闭数据库
  void close() {
    helper.close();
  }
}
