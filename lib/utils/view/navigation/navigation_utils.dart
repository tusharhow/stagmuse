import 'package:flutter/material.dart';

Route navigatorTo({
  required BuildContext context,
  required Widget screen,
}) {
  return MaterialPageRoute(builder: (context) {
    return screen;
  });
}
