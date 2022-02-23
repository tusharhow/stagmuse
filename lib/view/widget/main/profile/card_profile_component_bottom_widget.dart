import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

// Post
class CardProfileComponentBottomWidget extends StatelessWidget {
  const CardProfileComponentBottomWidget({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  final TextPost? text;
  final ImagePost? image;

  @override
  Widget build(BuildContext context) {
    return (text != null)
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                text!.status!,
                style: regular10(colorThird),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Image.network(
            image!.images![0],
            fit: BoxFit.cover,
          );
  }
}

// Live
class CardProfileComponentLiveWidget extends StatelessWidget {
  const CardProfileComponentLiveWidget({
    Key? key,
    required this.liveId,
    required this.yourId,
    required this.live,
    required this.type,
  }) : super(key: key);
  final String yourId, liveId;
  final Live live;
  final ProfilePageType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin),
      child: Row(
        children: [
          // Profile
          profileLiveNetworkUtils(
            size: 48,
            isLive: (live.status! == liveStatusDoing) ? true : false,
            url: live.cover,
          ),
          const SizedBox(width: 8),
          // User name || Name
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: ProfileLivePage(
                      liveId: liveId,
                      yourId: yourId,
                      type: (type == ProfilePageType.own)
                          ? ProfileLiveType.own
                          : ProfileLiveType.other,
                      isCreate: false,
                      isEdit: false,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // User name
                  Text(
                    live.name!,
                    style: semiBold12(colorThird),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Name
                  Text(
                    "${handlingYearMonthDateUtils(live.date!)} - ${live.time}",
                    style: regular12(Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Status
                  Text(
                    live.status!,
                    style: medium12(
                      (live.status == liveStatusDoing)
                          ? colorThird
                          : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }
}
