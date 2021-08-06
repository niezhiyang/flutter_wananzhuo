import 'package:flutter_wananzhuo/utils/screen_util.dart';

extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}


extension SizeFit on int {
  double get w {
    return SizeUtil.setW(toDouble());
  }

  double get h {
    return SizeUtil.setH(toDouble());
  }

  double get px {
    return SizeUtil.setPx(toDouble());
  }
}
