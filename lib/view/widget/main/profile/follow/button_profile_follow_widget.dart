import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

class ButtonProfileFollowWidget extends StatelessWidget {
  const ButtonProfileFollowWidget({
    Key? key,
    required this.contain,
    required this.toYou,
    required this.userId,
    required this.yourId,
  }) : super(key: key);
  final bool contain, toYou;
  final String yourId, userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
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
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return (toYou)
              ? Container()
              : (user.followRequest!.contains(userId))
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
                      leftMargin: 4,
                      rightMargin: 0,
                      topMargin: 0,
                      bottomMargin: 0,
                      width: null,
                      height: null,
                    )
                  : (contain)
                      ? flatOutlineTextButton(
                          onPress: () {
                            userServices.unFoll(
                              notifId: null,
                              userId: userId,
                              yourId: yourId,
                            );
                          },
                          text: "Unfoll",
                          textColor: colorSecondary,
                          borderColor: colorSecondary,
                          leftMargin: 4,
                          rightMargin: 0,
                          topMargin: 0,
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
                          text: "Follback",
                          textColor: colorThird,
                          buttonColor: colorSecondary,
                          leftMargin: 4,
                          rightMargin: 0,
                          topMargin: 0,
                          bottomMargin: 0,
                          width: null,
                          height: null,
                        );
        }
      },
    );
  }
}
