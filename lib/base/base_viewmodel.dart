import 'package:flutter/material.dart';

class BaseViewModel<T> extends ValueNotifier<T> {
  bool _dispose = false;

  BaseViewModel(T value) : super(value);

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }
  @override
  void notifyListeners() {
    if(!_dispose){
      super.notifyListeners();
    }
  }
}
