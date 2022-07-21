import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';
import '../../../core/net/http_result.dart';
import 'book_entity.dart';

class BookModel {
  ///教程列表
  final String bookListApi = "chapter/547/sublist/json";

  ///获取教程列表f
  Future<HttpResult<BookEntity>> getBookList(HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(bookListApi, canceler: canceler);

    ///解析
    HttpResult<BookEntity> result = HttpResult<BookEntity>().convert(json);

    return result;
  }
}
