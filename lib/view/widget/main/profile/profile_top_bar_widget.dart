import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTopBarWidget extends StatelessWidget {
  const ProfileTopBarWidget({
    Key? key,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final ProfilePageType type;
  final String yourId;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(margin, 24, margin, 36),
      child: Column(
        children: [
          // Photo || Name || Bio
          Row(
            children: [
              // Photo
              profilePhotoWidget(
                  (type == ProfilePageType.own) ? yourId : userId!),
              const SizedBox(width: 18),
              // Name || Bio
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestoreUser
                      .doc((type == ProfilePageType.own) ? yourId : userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      // Object
                      final User user = User.fromMap(
                          snapshot.data!.data() as Map<String, dynamic>);

                      final DataProfile dataProfile =
                          DataProfile.fromMap(user.dataProfile!);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Name
                          Text(
                            dataProfile.name!,
                            style: semiBold14(colorThird),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Bio
                          (dataProfile.bio == null)
                              ? Container()
                              : Text(
                                  dataProfile.bio!,
                                  style: regular12(colorThird),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Name
                        Text(
                          "Loading...",
                          style: semiBold14(colorThird),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Bio
                        Text(
                          "Loading...",
                          style: regular12(colorThird),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Posts || Followers || Following
          StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser
                .doc((type == ProfilePageType.own) ? yourId : userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Posts
                    postProfileTopBarWidget(yourId),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: ProfileFollowPage.followers(
                              userId: yourId,
                              yourId: yourId,
                            ),
                          ),
                        );
                      },
                      child: postFollowWProfileWidget(
                        title: "Followers",
                        value: 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: ProfileFollowPage.following(
                              yourId: yourId,
                              userId: yourId,
                            ),
                          ),
                        );
                      },
                      child: postFollowWProfileWidget(
                        title: "Following",
                        value: 0,
                      ),
                    ),
                  ],
                );
              } else {
                // Object
                final User user =
                    User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Posts
                    postProfileTopBarWidget(
                      (type == ProfilePageType.own) ? yourId : userId!,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: ProfileFollowPage.followers(
                              userId: (type == ProfilePageType.own)
                                  ? yourId
                                  : userId!,
                              yourId: yourId,
                            ),
                          ),
                        );
                      },
                      child: postFollowWProfileWidget(
                        title: "Followers",
                        value: (user.followers!.isEmpty)
                            ? 0
                            : user.followers!.length,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // Navigate
                        Navigator.push(
                          context,
                          navigatorTo(
                            context: context,
                            screen: ProfileFollowPage.following(
                              userId: (type == ProfilePageType.own)
                                  ? yourId
                                  : userId!,
                              yourId: yourId,
                            ),
                          ),
                        );
                      },
                      child: postFollowWProfileWidget(
                        title: "Following",
                        value: (user.following!.isEmpty)
                            ? 0
                            : user.following!.length,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          // Button
          buttonProfileTopBarWidget(
            context: context,
            type: type,
            yourId: yourId,
            userId: userId,
          ),
        ],
      ),
    );
  }
}

// Photo Profile
Widget profilePhotoWidget(String userId) {
  return StreamBuilder<DocumentSnapshot>(
    stream: firestoreUser.doc(userId).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data!.exists) {
        // Object
        final User user =
            User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        final DataProfile dataProfile = DataProfile.fromMap(user.dataProfile!);

        return photoProfileNetworkUtils(
          size: 80,
          url: dataProfile.photo,
        );
      }
      return photoProfileNetworkUtils(size: 80, url: null);
    },
  );
}

// Post Follow
Widget postFollowWProfileWidget({
  required String title,
  required int value,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: colorBackground,
      borderRadius: const BorderRadius.all(
        Radius.circular(7),
      ),
      boxShadow: [
        BoxShadow(
          color: colorThird.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Value
        Text(convertTextFormat(value), style: semiBold14(colorThird)),
        // Title
        Text(title, style: regular14(colorThird)),
      ],
    ),
  );
}

// Button
Widget buttonProfileTopBarWidget({
  required BuildContext context,
  required ProfilePageType type,
  required String yourId,
  String? userId,
}) {
  // Bloc
  final _editBloc = context.read<EditProfileBloc>();

  switch (type) {
    case ProfilePageType.own:
      return Row(
        children: [
          // Button Edit Profile
          Expanded(
            flex: 5,
            child: flatOutlineTextButton(
              onPress: () {
                adsServices.showRewardedAd();
                // Update Bloc
                _editBloc.add(
                  SetEditProfile(
                    userNameEmpty: false,
                    nameEmpty: false,
                    bioEmpty: false,
                    privateAccount: _editBloc.state.privateAccount,
                  ),
                );
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: EditProfilePage(userId: yourId),
                  ),
                );
              },
              text: "Edit Profile",
              textColor: colorPrimary,
              borderColor: colorPrimary,
              leftMargin: 0,
              rightMargin: 0,
              topMargin: 36,
              bottomMargin: 0,
              width: null,
              height: 48,
            ),
          ),
          const SizedBox(width: 12),
          // Button Posts's Save
          Expanded(
            child: flatOutlineIconButton(
              onPress: () {
                adsServices.showInterstitialAd();
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: ProfileSavePostPage(userId: yourId),
                  ),
                );
              },
              icon: Custom.bookmarkOutline,
              iconColor: colorPrimary,
              iconSize: 18,
              borderColor: colorPrimary,
              leftMargin: 0,
              rightMargin: 0,
              topMargin: 36,
              bottomMargin: 0,
              width: null,
              height: 48,
            ),
          ),
        ],
      );
    default:
      return Row(
        children: [
          // Button Follow
          Expanded(
            child: buttonFollowProfileTopBarWidget(
                userid: userId!, yourid: yourId),
          ),
          const SizedBox(width: 12),
          // Button Send Message
          Expanded(
            child: flatOutlineTextButton(
              onPress: () {
                adsServices.showRewardedAd();
                // Navigate
                Navigator.push(
                  context,
                  navigatorTo(
                    context: context,
                    screen: ChatDetailPage(
                      userId: userId,
                      yourId: yourId,
                    ),
                  ),
                );
              },
              text: "Send Message",
              textColor: colorPrimary,
              borderColor: colorPrimary,
              leftMargin: 0,
              rightMargin: 0,
              topMargin: 36,
              bottomMargin: 0,
              width: null,
              height: 48,
            ),
          ),
        ],
      );
  }
}

Widget postProfileTopBarWidget(String userId) {
  return StreamBuilder<QuerySnapshot>(
    stream: firestoreUser.doc(userId).collection("POST").snapshots(),
    builder: (_, snapshot) {
      if (!snapshot.hasData) {
        return postFollowWProfileWidget(title: "Posts", value: 0);
      }

      return (snapshot.data!.docs.isNotEmpty)
          ? postFollowWProfileWidget(
              title: "Posts", value: snapshot.data!.docs.length)
          : postFollowWProfileWidget(title: "Posts", value: 0);
    },
  );
}

Widget buttonFollowProfileTopBarWidget({
  required String userid,
  required String yourid,
}) {
  return StreamBuilder<DocumentSnapshot>(
    stream: firestoreUser.doc(userid).snapshots(),
    builder: (_, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: Text(
            "Loading...",
            style: medium14(colorThird),
          ),
        );
      } else {
        // Object
        final User user =
            User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        return (user.followRequest!.contains(yourid))
            ? flatTextButton(
                onPress: () {
                  userServices.accept(yourId: yourid, userId: userid);
                },
                text: "Accept",
                textColor: colorThird,
                buttonColor: colorPrimary,
                leftMargin: 0,
                rightMargin: 0,
                topMargin: 36,
                bottomMargin: 0,
                width: null,
                height: 48,
              )
            : (user.followers!.contains(yourid))
                ? flatOutlineTextButton(
                    onPress: () {
                      userServices.unFoll(
                        notifId: null,
                        userId: userid,
                        yourId: yourid,
                      );
                    },
                    text: "Unfoll",
                    textColor: colorPrimary,
                    borderColor: colorPrimary,
                    leftMargin: 0,
                    rightMargin: 0,
                    topMargin: 36,
                    bottomMargin: 0,
                    width: null,
                    height: 48,
                  )
                : (!user.followers!.contains(yourid) &&
                        user.following!.contains(yourid))
                    ? flatTextButton(
                        onPress: () {
                          userServices.follback(
                            yourId: yourid,
                            userId: userid,
                          );
                        },
                        text: "Follback",
                        textColor: colorThird,
                        buttonColor: colorPrimary,
                        leftMargin: 0,
                        rightMargin: 0,
                        topMargin: 36,
                        bottomMargin: 0,
                        width: null,
                        height: 48,
                      )
                    : flatTextButton(
                        onPress: () {
                          userServices.follback(
                            yourId: yourid,
                            userId: userid,
                          );
                        },
                        text: "Follow",
                        textColor: colorThird,
                        buttonColor: colorPrimary,
                        leftMargin: 0,
                        rightMargin: 0,
                        topMargin: 36,
                        bottomMargin: 0,
                        width: null,
                        height: 48,
                      );
      }
    },
  );
}
