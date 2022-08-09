import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../book/model/book_entity.dart';
import '../../book/model/book_model.dart';

class BookViewModel extends ChangeNotifier with LifecycleObserver {
  late HttpCanceler httpCanceler;
  BookModel model = BookModel();

  ///教程列表
  List<BookEntity> _dataArray = [];

  List<BookEntity> get dataArray => _dataArray;

  set dataArray(List<BookEntity> value) {
    _dataArray = value;
    notifyListeners();
  }

  ///获取教程列表
  void getBookList() {
    model.getBookList(httpCanceler).then((value) {
      if (value.success) {
        dataArray = value.list!;
      }
    });
  }

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onInit) {
      httpCanceler = HttpCanceler(owner);
    } else if (state == LifecycleState.onCreate) {
      getBookList();
    }
  }
}
