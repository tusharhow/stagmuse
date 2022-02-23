import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

// Follow
class CardFollowNotificationWidget extends StatelessWidget {
  const CardFollowNotificationWidget({
    Key? key,
    required this.notifId,
    required this.yourId,
    required this.followNotif,
    required this.notifPermission,
    required this.isFollback,
    required this.request,
  }) : super(key: key);
  final String yourId, notifId;
  final FollowNotifPermission? notifPermission;
  final FollowNotif? followNotif;
  final bool isFollback;
  final List request;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        notificationServices.deleteSingleNotif(
          userId: yourId,
          notifId: notifId,
        );
      },
      child: GestureDetector(
        onTap: () {
          // Update Notif
          notificationServices.updateReadNotif(
            userId: yourId,
            notifId: notifId,
          );
          Navigator.push(
            context,
            navigatorTo(
              context: context,
              screen: ProfilePage.other(
                yourId: yourId,
                userId: (notifPermission == null)
                    ? followNotif!.userId!
                    : notifPermission!.userId!,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
          child: StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser
                  .doc((notifPermission == null)
                      ? followNotif!.userId
                      : notifPermission!.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "Loading...",
                      style: medium14(colorThird),
                    ),
                  );
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile
                          photoProfileNetworkUtils(
                            size: 48,
                            url: dataProfile.photo,
                          ),
                          const SizedBox(width: 8),
                          // User name || Desciprition
                          Expanded(
                              child: RichText(
                            text: TextSpan(
                              text: "@${dataProfile.username} ",
                              style: semiBold14(colorThird),
                              children: [
                                TextSpan(
                                  text: (notifPermission != null &&
                                          !notifPermission!.giveAccess!)
                                      ? "ask to follow you"
                                      : "have followed you",
                                  style: medium14(colorThird),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      // Button Confirm || Delete
                      (notifPermission != null && !notifPermission!.giveAccess!)
                          ? Row(
                              children: [
                                const SizedBox(width: 50),
                                // Follow
                                flatTextButton(
                                  onPress: () {
                                    userServices.accept(
                                      yourId: yourId,
                                      userId: notifPermission!.userId!,
                                    );

                                    notificationServices.updateReadNotif(
                                      userId: yourId,
                                      notifId: notifId,
                                    );
                                  },
                                  buttonColor: colorPrimary,
                                  text: "Accept",
                                  textColor: colorThird,
                                  leftMargin: 0,
                                  rightMargin: 6,
                                  topMargin: 8,
                                  bottomMargin: 0,
                                  width: 80,
                                  height: 30,
                                ),
                                // Delete
                                flatOutlineTextButton(
                                  onPress: () {
                                    userServices.deleteRequestFollow(
                                      deleteSingleNotif: true,
                                      yourId: notifPermission!.userId!,
                                      userId: yourId,
                                    );

                                    notificationServices.updateReadNotif(
                                      userId: yourId,
                                      notifId: notifId,
                                    );
                                  },
                                  borderColor: colorPrimary,
                                  text: "Delete",
                                  textColor: colorPrimary,
                                  leftMargin: 6,
                                  rightMargin: 0,
                                  topMargin: 8,
                                  bottomMargin: 0,
                                  width: 80,
                                  height: 30,
                                ),
                              ],
                            )
                          : Container(),
                      // Button Follback or Unfoll
                      Row(
                        children: [
                          const SizedBox(width: 50),
                          (notifPermission != null)
                              ? (notifPermission!.giveAccess!)
                                  ? (isFollback)
                                      ? flatTextButton(
                                          onPress: () {
                                            userServices.follback(
                                              yourId: yourId,
                                              userId: notifPermission!.userId!,
                                            );

                                            notificationServices
                                                .updateReadNotif(
                                              userId: yourId,
                                              notifId: notifId,
                                            );
                                          },
                                          buttonColor: colorPrimary,
                                          text: "Follback",
                                          textColor: colorThird,
                                          leftMargin: 0,
                                          rightMargin: 6,
                                          topMargin: 0,
                                          bottomMargin: 0,
                                          width: 80,
                                          height: 30,
                                        )
                                      : flatOutlineTextButton(
                                          onPress: () {
                                            userServices.unFoll(
                                              notifId: notifId,
                                              userId: notifPermission!.userId!,
                                              yourId: yourId,
                                            );

                                            notificationServices
                                                .updateReadNotif(
                                              userId: yourId,
                                              notifId: notifId,
                                            );
                                          },
                                          borderColor: colorPrimary,
                                          text: "Unfoll",
                                          textColor: colorPrimary,
                                          leftMargin: 6,
                                          rightMargin: 0,
                                          topMargin: 0,
                                          bottomMargin: 0,
                                          width: 80,
                                          height: 30,
                                        )
                                  : Container()
                              : (request.contains(followNotif!.userId!))
                                  ? flatTextButton(
                                      onPress: () {
                                        userServices.deleteRequestFollow(
                                          deleteSingleNotif: true,
                                          yourId: yourId,
                                          userId: followNotif!.userId!,
                                        );

                                        notificationServices.updateReadNotif(
                                          userId: yourId,
                                          notifId: notifId,
                                        );
                                      },
                                      buttonColor: Colors.grey,
                                      text: "Request",
                                      textColor: colorThird,
                                      leftMargin: 0,
                                      rightMargin: 6,
                                      topMargin: 0,
                                      bottomMargin: 0,
                                      width: 80,
                                      height: 30,
                                    )
                                  : (isFollback)
                                      ? flatTextButton(
                                          onPress: () {
                                            userServices.addRequestFollow(
                                              yourId: yourId,
                                              userId: followNotif!.userId!,
                                            );

                                            notificationServices
                                                .updateReadNotif(
                                              userId: yourId,
                                              notifId: notifId,
                                            );
                                          },
                                          buttonColor: colorPrimary,
                                          text: "Follback",
                                          textColor: colorThird,
                                          leftMargin: 0,
                                          rightMargin: 6,
                                          topMargin: 0,
                                          bottomMargin: 0,
                                          width: 80,
                                          height: 30,
                                        )
                                      : flatOutlineTextButton(
                                          onPress: () {
                                            userServices.unFoll(
                                              notifId: null,
                                              userId: followNotif!.userId!,
                                              yourId: yourId,
                                            );

                                            notificationServices
                                                .updateReadNotif(
                                              userId: yourId,
                                              notifId: notifId,
                                            );
                                          },
                                          borderColor: colorPrimary,
                                          text: "Unfoll",
                                          textColor: colorPrimary,
                                          leftMargin: 6,
                                          rightMargin: 0,
                                          topMargin: 0,
                                          bottomMargin: 0,
                                          width: 80,
                                          height: 30,
                                        ),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}

// Like
class CardLikeNotificationWidget extends StatelessWidget {
  const CardLikeNotificationWidget({
    Key? key,
    required this.yourId,
    required this.notifId,
    required this.notif,
  }) : super(key: key);
  final String notifId, yourId;
  final LikeNotif notif;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        notificationServices.deleteSingleNotif(
          userId: yourId,
          notifId: notifId,
        );
      },
      child: GestureDetector(
        onTap: () async {
          // Navigate
          Navigator.push(
            context,
            navigatorTo(
              context: context,
              screen: DetailSinglePostPage(
                yourId: yourId,
                type: ProfilePageType.own,
                userId: yourId,
                postId: "${notif.postId}",
              ),
            ),
          );
          // Update notif
          await notificationServices.updateReadNotif(
            userId: yourId,
            notifId: notifId,
          );
        },
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestoreUser.doc(notif.userId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              // Object
              final User user =
                  User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
              final DataProfile dataProfile =
                  DataProfile.fromMap(user.dataProfile!);

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: margin, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile
                    photoProfileNetworkUtils(size: 48, url: dataProfile.photo),
                    const SizedBox(width: 8),
                    // User name || Desciprition
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "@${dataProfile.username} ",
                          style: semiBold14(colorThird),
                          children: [
                            TextSpan(
                              text: "likes your post",
                              style: regular14(colorThird),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// Live
class CardLiveNotificationWidget extends StatelessWidget {
  const CardLiveNotificationWidget({
    Key? key,
    required this.isLive,
  }) : super(key: key);
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 0),
      child: Row(
        children: [
          // Profile
          profileLiveUtils(size: 48, isLive: isLive),
          const SizedBox(width: 12),
          // Name || Description || Time
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: "Hairstyle Fashion ",
                    style: semiBold14(colorThird),
                    children: [
                      TextSpan(
                        text: (isLive) ? "live has begun\n" : "live is over\n",
                        style: regular14(colorThird),
                      ),
                      TextSpan(
                        text: (isLive)
                            ? "It's starting\n"
                            : "Ended ${handlingTimeUtils("2021-11-12 11:11:00")}\n",
                        style: regular12(Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
