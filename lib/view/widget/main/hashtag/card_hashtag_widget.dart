import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';

class CardHashtagWidget extends StatelessWidget {
  const CardHashtagWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 8),
          // Profile
          Text(
            "#",
            style: bold36(colorThird),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 8),
          // User name || Name
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "Hairstyle",
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
