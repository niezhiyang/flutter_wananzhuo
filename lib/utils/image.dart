import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Image image(String src, {double? width, double? height, BoxFit? fit}) {
  return Image.network(src, width: width, height: height, fit: fit,
      frameBuilder: (
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (frame == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return child;
    }
  });
}

var a = Image.network(
  'https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg',
  height: 150,
  width: 150,
  fit: BoxFit.cover,
  frameBuilder: (
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (frame == null) {
      return Image.asset(
        'assets/images/place.png',
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }
    return child;
  },
);
