import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileLiveComponentWidget extends StatelessWidget {
  const ProfileLiveComponentWidget({
    Key? key,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final ProfilePageType type;
  final String userId, yourId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.doc(userId).snapshots(),
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
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);
          final LiveFromProfile liveFromProfile =
              LiveFromProfile.fromMap(user.live!);

          if (liveFromProfile.providedByYou!.isNotEmpty ||
              liveFromProfile.youFollow!.isNotEmpty) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Provided By You || User
                  (liveFromProfile.providedByYou!.isNotEmpty)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: margin),
                              child: Text(
                                (type == ProfilePageType.own)
                                    ? "Provided by you"
                                    : "Provides by @${dataProfile.username}",
                                style: semiBold14(colorThird),
                              ),
                            ),
                            Column(
                              children: liveFromProfile.providedByYou!.map(
                                (liveId) {
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream:
                                        firestoreLive.doc(liveId).snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else {
                                        if (snapshot.data!.exists) {
                                          // Object
                                          final Live live = Live.fromMap(
                                            snapshot.data!.data()
                                                as Map<String, dynamic>,
                                          );

                                          return CardProfileComponentLiveWidget(
                                            liveId: liveId,
                                            live: live,
                                            yourId: yourId,
                                            type: type,
                                          );
                                        } else {
                                          userServices.deleteLiveByYou(
                                            liveId: liveId,
                                            userId: userId,
                                          );

                                          return const SizedBox();
                                        }
                                      }
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 24),
                  // You follow
                  (liveFromProfile.youFollow!.isNotEmpty)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: margin),
                              child: Text(
                                (type == ProfilePageType.own)
                                    ? "You follow"
                                    : "Followed by @${dataProfile.username}",
                                style: semiBold14(colorThird),
                              ),
                            ),
                            Column(
                              children: liveFromProfile.youFollow!.map(
                                (liveId) {
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream:
                                        firestoreLive.doc(liveId).snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else {
                                        if (snapshot.data!.exists) {
                                          // Object
                                          final Live live = Live.fromMap(
                                            snapshot.data!.data()
                                                as Map<String, dynamic>,
                                          );

                                          return CardProfileComponentLiveWidget(
                                            liveId: liveId,
                                            live: live,
                                            yourId: yourId,
                                            type: ProfilePageType.other,
                                          );
                                        } else {
                                          userServices.deleteLiveFollow(
                                            liveId: liveId,
                                            userId: userId,
                                          );

                                          return const SizedBox();
                                        }
                                      }
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "Empty Live",
                style: medium14(colorThird),
              ),
            );
          }
        }
      },
    );
  }
}
