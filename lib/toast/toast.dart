import 'package:flutter/material.dart';

import '../wan_kit.dart';

class Toast {
  // static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  //     GlobalKey<ScaffoldMessengerState>();
  // static final BuildContext? context = _scaffoldMessengerKey.currentContext;

  static bool _isShow = false;

  Toast._();

  static void show(String? text) async {
    if(text==null){
      return;
    }
    if (text.isNotEmpty) {

      OverlayState? overlayState = Wankit.navigatorKey.currentState?.overlay;
      OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black54),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      });
      if (!_isShow) {
        overlayState!.insert(overlayEntry);
        _isShow = true;
        await Future.delayed(const Duration(seconds: 1));
        overlayEntry.remove();
        _isShow = false;
      }
    }
  }
}


