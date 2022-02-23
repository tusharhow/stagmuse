import 'package:flutter/material.dart';

import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class SetTypePostWidget extends StatelessWidget {
  const SetTypePostWidget({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Post
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: margin, vertical: 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // Navigate
            Navigator.push(
              context,
              navigatorTo(
                context: context,
                screen: MainCreatePostPage(yourId: yourId),
              ),
            );
          },
          title: Text("Add post", style: medium18(colorThird)),
          trailing: const Icon(Icons.add, color: Colors.grey),
        ),
        // Story
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: margin, vertical: 0),
          onTap: () {
            Navigator.pop(context);
            // Show Modal Bottom
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              context: context,
              builder: (context) {
                return SetStoryFileTypeWidget(yourId: yourId);
              },
            );
          },
          title: Text("Add story", style: medium18(colorThird)),
          trailing: const Icon(Icons.add, color: Colors.grey),
        ),
      ],
    );
  }
}
