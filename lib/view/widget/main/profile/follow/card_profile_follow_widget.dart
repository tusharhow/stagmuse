import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CardProfileFollowWidget extends StatelessWidget {
  const CardProfileFollowWidget({
    Key? key,
    required this.toYou,
    required this.userId,
    required this.yourId,
    required this.dataProfile,
    required this.contain,
  }) : super(key: key);
  final bool toYou, contain;
  final String userId, yourId;
  final DataProfile? dataProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: (dataProfile == null)
          ? Center(
              child: Text(
                "Loading..",
                style: medium12(colorThird),
              ),
            )
          : Row(
              children: [
                // Profile
                secondProfileNetworkWithStoryOrLiveUtils(
                  size: 48,
                  live: false,
                  emptyStory: true,
                  url: dataProfile!.photo,
                ),
                const SizedBox(width: 8),
                // User name || Name
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate
                      (toYou)
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              navigatorTo(
                                context: context,
                                screen: const LandingPage(),
                              ),
                              (route) => false)
                          : Navigator.push(
                              context,
                              navigatorTo(
                                context: context,
                                screen: ProfilePage.other(
                                  userId: userId,
                                  yourId: yourId,
                                ),
                              ),
                            );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User name
                        Text(
                          "@${dataProfile!.username!}",
                          style: semiBold12(colorThird),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Name
                        Text(
                          dataProfile!.name!,
                          style: regular12(Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Button Follow
                ButtonProfileFollowWidget(
                  contain: contain,
                  toYou: toYou,
                  userId: userId,
                  yourId: yourId,
                ),
              ],
            ),
    );
  }
}
