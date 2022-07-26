import 'package:flutter/material.dart';

import '../../../core/lifecycle/widget_lifecycle_owner.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../../book/model/book_entity.dart';
import '../../book/model/book_model.dart';

class BookViewModel extends ChangeNotifier {
  BookModel model = BookModel();

  ///教程列表
  List<BookEntity> _dataArray = [];

  List<BookEntity> get dataArray => _dataArray;

  set dataArray(List<BookEntity> value) {
    _dataArray = value;
    notifyListeners();
  }

  ///获取教程列表
  void getBookList(WidgetLifecycleOwner owner) {
    model.getBookList(HttpCanceler(owner)).then((value) {
      if (value.success) {
        dataArray = value.list!;
      }
    });
  }
}
