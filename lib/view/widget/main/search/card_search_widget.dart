import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Account
class CardAccountSearchResultWidget extends StatelessWidget {
  const CardAccountSearchResultWidget({
    Key? key,
    required this.dataProfile,
    required this.forHistory,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final DataProfile dataProfile;
  final bool forHistory;
  final String yourId;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _bottomNavBloc = context.read<BottomNavigationBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: Row(
        children: [
          // Profile
          photoProfileNetworkUtils(size: 48, url: dataProfile.photo),
          const SizedBox(width: 8),
          // User name || Name
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (userId == yourId) {
                  _bottomNavBloc.add(
                    const SetBottomNavigation(3),
                  );
                  // Navigate
                  Navigator.pushAndRemoveUntil(
                      context,
                      navigatorTo(
                        context: context,
                        screen: const LandingPage(),
                      ),
                      (route) => false);
                } else {
                  adsServices.showInterstitialAd();
                  // Navigate
                  Navigator.push(
                    context,
                    navigatorTo(
                      context: context,
                      screen: ProfilePage.other(userId: userId, yourId: yourId),
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name
                  Text(
                    "@${dataProfile.username}",
                    style: semiBold14(colorThird),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Name
                  Text(
                    dataProfile.name!,
                    style: regular12(Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          (forHistory)
              ? GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

// Live
class CardLiveSearchResultWidget extends StatelessWidget {
  const CardLiveSearchResultWidget({
    Key? key,
    required this.liveId,
    required this.live,
    required this.yourId,
    required this.forHistory,
  }) : super(key: key);
  final Live live;
  final String yourId, liveId;
  final bool forHistory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: Row(
        children: [
          // Profile
          profileLiveNetworkUtils(
            size: 48,
            isLive: (live.status == liveStatusDoing) ? true : false,
            url: live.cover,
          ),
          const SizedBox(width: 8),
          // User name || Name
          Expanded(
            child: GestureDetector(
              onTap: () {
                adsServices.showInterstitialAd();
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: ProfileLivePage(
                      liveId: liveId,
                      isCreate: false,
                      isEdit: false,
                      yourId: yourId,
                      type: (live.provider == yourId)
                          ? ProfileLiveType.own
                          : ProfileLiveType.other,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    live.name!,
                    style: semiBold14(colorThird),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Status
                  Text(
                    live.status!,
                    style: regular12(Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          (forHistory)
              ? GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

// Live
class CardPostSearchResultWidget extends StatelessWidget {
  const CardPostSearchResultWidget({
    Key? key,
    required this.username,
    required this.postId,
    required this.textPost,
    required this.imagePost,
    required this.yourId,
    required this.forHistory,
  }) : super(key: key);
  final TextPost? textPost;
  final ImagePost? imagePost;
  final String yourId, postId, username;
  final bool forHistory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: Row(
        children: [
          // Post Cover
          (imagePost != null)
              ? Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      image: NetworkImage(imagePost!.images![0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const SizedBox(),

          const SizedBox(width: 8),
          // User name || Description
          Expanded(
            child: GestureDetector(
              onTap: () {
                adsServices.showInterstitialAd();
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: DetailSinglePostPage(
                      yourId: yourId,
                      type: (imagePost != null)
                          ? (imagePost!.yourId == yourId)
                              ? ProfilePageType.own
                              : ProfilePageType.other
                          : (textPost!.yourId == yourId)
                              ? ProfilePageType.own
                              : ProfilePageType.other,
                      userId: (imagePost != null)
                          ? imagePost!.yourId!
                          : textPost!.yourId!,
                      postId: postId,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@$username",
                    style: semiBold14(colorThird),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (imagePost != null)
                        ? imagePost!.description!
                        : textPost!.status!,
                    style: regular12(colorThird),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          (forHistory)
              ? GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
