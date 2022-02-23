import 'package:flutter/material.dart';

Widget flatTextButton({
  required Function onPress,
  required String text,
  required Color textColor,
  required Color buttonColor,
  required double leftMargin,
  required double rightMargin,
  required double topMargin,
  required double bottomMargin,
  double? height,
  required double? width,
  double? radius,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      leftMargin,
      topMargin,
      rightMargin,
      bottomMargin,
    ),
    child: ElevatedButton(
      onPressed: () => onPress(),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        primary: buttonColor,
        onPrimary: textColor,
        minimumSize: (width == null && height == null)
            ? null
            : Size((width == null) ? double.infinity : width,
                (height == null) ? 55 : height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              (radius == null) ? 7 : radius,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget flatOutlineTextButton({
  required Function onPress,
  required String text,
  required Color textColor,
  required Color borderColor,
  required double leftMargin,
  required double rightMargin,
  required double topMargin,
  required double bottomMargin,
  double? height,
  required double? width,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      leftMargin,
      topMargin,
      rightMargin,
      bottomMargin,
    ),
    child: ElevatedButton(
      onPressed: () => onPress(),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        primary: Colors.transparent,
        onPrimary: textColor,
        minimumSize: (width == null && height == null)
            ? null
            : Size((width == null) ? double.infinity : width,
                (height == null) ? 48 : height),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          side: BorderSide(color: borderColor),
        ),
      ),
    ),
  );
}

Widget flatOutlineIconButton({
  required Function onPress,
  required IconData icon,
  required Color iconColor,
  required double iconSize,
  required Color borderColor,
  required double leftMargin,
  required double rightMargin,
  required double topMargin,
  required double bottomMargin,
  double? height,
  required double? width,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      leftMargin,
      topMargin,
      rightMargin,
      bottomMargin,
    ),
    child: ElevatedButton(
      onPressed: () => onPress(),
      child: Icon(icon, size: iconSize),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        primary: Colors.transparent,
        onPrimary: iconColor,
        minimumSize: (width == null && height == null)
            ? null
            : Size((width == null) ? double.infinity : width,
                (height == null) ? 48 : height),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          side: BorderSide(color: borderColor),
        ),
      ),
    ),
  );
}
