import 'package:flutter/material.dart';

Widget confirmationDialog({
  required Widget content,
  required List<Widget> actions,
}) {
  return AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: content,
    actions: actions,
  );
}

Widget generalDialog(Widget content) {
  return Dialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    child: content,
  );
}
