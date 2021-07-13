import 'package:flutter/material.dart';

class Toast {
  // static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  //     GlobalKey<ScaffoldMessengerState>();
  // static final BuildContext? context = _scaffoldMessengerKey.currentContext;

  static late BuildContext _context;
  static bool isShow = false;

  static void init(BuildContext context) {
    _context = context;
  }

  static void show(String? text) async {
    if(text==null){
      return;
    }
    if (text.isNotEmpty) {
      OverlayState? overlayState = Overlay.of(_context);
      OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black54),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      });
      if (!isShow) {
        overlayState!.insert(overlayEntry);
        isShow = true;
        await Future.delayed(const Duration(seconds: 1));
        overlayEntry.remove();
        isShow = false;
      }
    }
  }
}


class Adsda extends StatefulWidget {
  const Adsda({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Adsda> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

