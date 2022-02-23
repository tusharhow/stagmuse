import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';

class TopBarHashtagWidget extends StatelessWidget {
  const TopBarHashtagWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(margin, 8, margin, 8),
      child: Row(
        children: [
          // Image
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: colorPrimary),
            child: Center(
              child: Text(
                "#",
                style: bold64(colorThird),
              ),
            ),
          ),
          const SizedBox(width: margin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "500+ ",
                    style: bold18(colorThird),
                    children: [
                      TextSpan(text: "posts", style: regular18(colorThird)),
                    ],
                  ),
                ),
                flatOutlineTextButton(
                  onPress: () {},
                  text: "Follow",
                  textColor: colorPrimary,
                  borderColor: colorPrimary,
                  leftMargin: 0,
                  rightMargin: 0,
                  topMargin: 4,
                  bottomMargin: 0,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
