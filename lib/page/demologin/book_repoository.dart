import 'book_model.dart';

class BookRepository {
  var count = 0;
  Future<BookModel> getData() async {
    await Future.delayed(const Duration(seconds: 2));
    BookModel model = BookModel();
    count++;
    if (count.isOdd) {
      throw Exception("网络错误");
    } else {
      model.name = "Flutter$count";
      model.author = "google$count";
    }

    return model;
  }
}
