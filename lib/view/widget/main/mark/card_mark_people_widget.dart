import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';

class CardMarkPeopleWidget extends StatelessWidget {
  const CardMarkPeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: Row(
        children: [
          // Profile
          secondProfileWithStoryUtils(size: 36, emptyStory: true),
          const SizedBox(width: 8),
          // User name || Name
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "@Amirah William",
                style: semiBold14(colorThird),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.clear,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
