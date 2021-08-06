import 'package:flutter/cupertino.dart';
import 'package:flutter_wananzhuo/page/demologin/book_model.dart';
import 'package:flutter_wananzhuo/page/demologin/book_repoository.dart';

class BookViewModel extends ValueNotifier<BookModel> {
  BookRepository repository = BookRepository();

  BookViewModel() : super(BookModel());
  bool _dispose = false;

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }

  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }

  void getData() {
    value.loadState = 0;
    notifyListeners();
    repository.getData().then((book) {
      book.loadState = 1;
      value = book;
    }).catchError((e) {
      value.loadState = 2;
      notifyListeners();
    });
  }
}
