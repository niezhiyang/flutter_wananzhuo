import 'package:flutter_wananzhuo/base/base_change_notifier.dart';

class HomeViewModel extends BaseChangeNotifier {
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
