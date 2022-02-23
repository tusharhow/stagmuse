import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileBlocPrivatekWidget extends StatelessWidget {
  const ProfileBlocPrivatekWidget({
    Key? key,
    required this.block,
    required this.private,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final List block, private;
  final String yourId, userId;

  @override
  Widget build(BuildContext context) {
    return profileCheckAccessAccount(list: block, userId: userId)
        ? StreamBuilder<DocumentSnapshot>(
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

                return Padding(
                  padding: const EdgeInsets.all(margin),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Center(
                        child: photoProfileNetworkUtils(
                          size: 120,
                          url: dataProfile.photo,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.block, color: colorThird),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "This account is blocked by you",
                                style: medium14(colorThird),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Button Follow
                      flatTextButton(
                        onPress: () {
                          userServices.deleteBloc(
                            yourId: yourId,
                            userId: userId,
                          );
                        },
                        text: "Unblock",
                        textColor: colorThird,
                        buttonColor: colorPrimary,
                        leftMargin: 0,
                        rightMargin: 0,
                        topMargin: 36,
                        bottomMargin: 0,
                        width: null,
                        height: null,
                      )
                    ],
                  ),
                );
              }
            },
          )
        : ProfilePrivateWidget(list: private, yourId: yourId, userId: userId);
  }
}

class ProfilePrivateWidget extends StatelessWidget {
  const ProfilePrivateWidget({
    Key? key,
    required this.list,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final List list;
  final String yourId, userId;

  @override
  Widget build(BuildContext context) {
    return profileCheckAccessAccount(list: list, userId: userId)
        ? ProfileMainWidget(
            type: ProfilePageType.other,
            yourId: yourId,
            userId: userId,
          )
        : StreamBuilder<DocumentSnapshot>(
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

                return Padding(
                  padding: const EdgeInsets.all(margin),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Center(
                        child: photoProfileNetworkUtils(
                          size: 120,
                          url: dataProfile.photo,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock, color: colorThird),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "This account is private",
                                style: medium14(colorThird),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Button Follow
                      StreamBuilder<DocumentSnapshot>(
                        stream: firestoreUser.doc(yourId).snapshots(),
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

                            return (user.followRequest!.contains(userId))
                                ? flatTextButton(
                                    onPress: () {
                                      userServices.deleteRequestFollow(
                                        deleteSingleNotif: true,
                                        yourId: yourId,
                                        userId: userId,
                                      );
                                    },
                                    text: "Request",
                                    textColor: colorThird,
                                    buttonColor: Colors.grey,
                                    leftMargin: 0,
                                    rightMargin: 0,
                                    topMargin: 36,
                                    bottomMargin: 0,
                                    width: null,
                                    height: null,
                                  )
                                : (user.followers!.contains(userId))
                                    ? flatTextButton(
                                        onPress: () {
                                          userServices.addRequestFollow(
                                            yourId: yourId,
                                            userId: userId,
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
                                        height: null,
                                      )
                                    : flatTextButton(
                                        onPress: () {
                                          userServices.addRequestFollow(
                                            yourId: yourId,
                                            userId: userId,
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
                                        height: null,
                                      );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          );
  }
}

bool profileCheckAccessAccount({
  required List list,
  required String userId,
}) {
  return list.contains(userId);
}
