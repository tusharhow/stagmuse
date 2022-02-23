import 'package:flutter/material.dart';

Widget textFormFieldFill({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required TextStyle style,
  required String hintText,
  required Function? onTap,
  required Color fillColor,
  required Icon? prefix,
  Widget? suffix,
  required double leftMargin,
  required double topMargin,
  required double rightMargin,
  required double bottomMargin,
  bool? obscure,
  Function? onChanged,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      leftMargin,
      topMargin,
      rightMargin,
      bottomMargin,
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: style,
      onTap: () => (onTap == null) ? null : onTap(),
      onChanged: (_) => (onChanged == null) ? null : onChanged(),
      obscureText: (obscure == null) ? false : obscure,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefix,
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: style,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

Widget underlineTextField({
  required TextEditingController controller,
  required bool enabled,
  required TextInputType keyboardType,
  required TextStyle style,
  required String labelText,
  required TextStyle labelStyle,
  required Color colorUnderline,
  required double leftMargin,
  required double topMargin,
  required double rightMargin,
  required double bottomMargin,
  Function? onTap,
  Widget? suffix,
  bool? obscure,
  int? maxLength,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      leftMargin,
      topMargin,
      rightMargin,
      bottomMargin,
    ),
    child: TextField(
      maxLength: maxLength,
      maxLines: null,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      style: style,
      onTap: () => (onTap == null) ? null : onTap(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        labelText: labelText,
        labelStyle: labelStyle,
        suffix: suffix,
        counterStyle: labelStyle,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorUnderline),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorUnderline),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorUnderline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorUnderline),
        ),
      ),
    ),
  );
}
