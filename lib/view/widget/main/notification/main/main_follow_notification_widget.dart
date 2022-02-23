import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/backend/backend_utils.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class MainFollowNotificationWidget extends StatelessWidget {
  const MainFollowNotificationWidget({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreUser.doc(yourId).collection("NOTIFICATION").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Loading...",
              style: medium14(colorThird),
            ),
          );
        } else {
          final snapshots = snapshot.data!.docs
              .where((doc) =>
                  doc["type"] == notificationTypeFollowPermission ||
                  doc["type"] == notificationTypeFollow)
              .toList();

          return (snapshot.data!.docs.isNotEmpty)
              ? SingleChildScrollView(
                  child: Column(
                      children: snapshots.map((doc) {
                    // Object
                    final map = doc.data() as Map<String, dynamic>;

                    // Define Type
                    bool notifTypePermission =
                        (map["type"] == notificationTypeFollowPermission)
                            ? true
                            : false;

                    return StreamBuilder<DocumentSnapshot>(
                        stream: firestoreUser.doc(yourId).snapshots(),
                        builder: (context, snapshot2) {
                          if (!snapshot2.hasData) {
                            return Container();
                          } else {
                            // Object
                            final User user = User.fromMap(
                              snapshot2.data!.data() as Map<String, dynamic>,
                            );

                            return (map["type"] ==
                                        notificationTypeFollowPermission ||
                                    map["type"] == notificationTypeFollow)
                                ? CardFollowNotificationWidget(
                                    notifId: doc.id,
                                    followNotif: (!notifTypePermission)
                                        ? FollowNotif.fromMap(map)
                                        : null,
                                    notifPermission: (notifTypePermission)
                                        ? FollowNotifPermission.fromMap(map)
                                        : null,
                                    yourId: yourId,
                                    isFollback: (user.following!
                                            .contains(map["user id"]))
                                        ? false
                                        : true,
                                    request: (user.followRequest!),
                                  )
                                : const SizedBox();
                          }
                        });
                  }).toList()),
                )
              : Center(
                  child: Text(
                    "Empty Notification",
                    style: medium14(colorThird),
                  ),
                );
        }
      },
    );
  }
}
