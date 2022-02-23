import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileFollowersComponentWidget extends StatelessWidget {
  const ProfileFollowersComponentWidget({
    Key? key,
    required this.userId,
    required this.yourId,
  }) : super(key: key);
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
          final User user1 =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return (user1.followers!.isNotEmpty)
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(user1.followers!.length, (index) {
                      final accountId = user1.followers![index];

                      return StreamBuilder<DocumentSnapshot>(
                          stream: firestoreUser.doc(accountId).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CardProfileFollowWidget(
                                toYou: (accountId == yourId) ? true : false,
                                yourId: yourId,
                                userId: userId,
                                dataProfile: null,
                                contain: false,
                              );
                            } else {
                              // Object
                              final User user2 = User.fromMap(snapshot.data!
                                  .data() as Map<String, dynamic>);
                              final DataProfile dataProfile =
                                  DataProfile.fromMap(user2.dataProfile!);

                              return CardProfileFollowWidget(
                                toYou: (accountId == yourId) ? true : false,
                                yourId: userId,
                                userId: snapshot.data!.id,
                                dataProfile: dataProfile,
                                contain: (user1.following!
                                        .contains(snapshot.data!.id))
                                    ? true
                                    : false,
                              );
                            }
                          });
                    }).toList(),
                  ),
                )
              : Center(
                  child: Text(
                    "Empty Followers",
                    style: medium14(colorThird),
                  ),
                );
        }
      },
    );
  }
}
