import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadUtil {
  // static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  //     GlobalKey<ScaffoldMessengerState>();
  // static final BuildContext? context = _scaffoldMessengerKey.currentContext;

  static late BuildContext _context;
  static bool _isShow = false;
  static OverlayEntry? overlayEntry;

  static void init(BuildContext context) {
    _context = context;
  }

  static void show() {
    OverlayState? overlayState = Overlay.of(_context);
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.black38,
          child: const SpinKitCircle(
            color: Colors.white,
            size: 50,
          ),
        ),
      );
    });
    if (!_isShow) {
      overlayState!.insert(overlayEntry!);
      _isShow = true;
    }
  }

  static void close() {
    if (_isShow) {
      overlayEntry?.remove();
    }
  }
}
