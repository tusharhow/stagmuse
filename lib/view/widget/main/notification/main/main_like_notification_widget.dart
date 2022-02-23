import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class MainLikeNotificationWidget extends StatelessWidget {
  const MainLikeNotificationWidget({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreUser
          .doc(yourId)
          .collection("NOTIFICATION")
          .where("type", isEqualTo: notificationTypeLike)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Loading...",
              style: medium14(colorThird),
            ),
          );
        }
        return (snapshot.data!.docs.isNotEmpty)
            ? SingleChildScrollView(
                child: Column(
                  children: snapshot.data!.docs.map(
                    (doc) {
                      // Object
                      final LikeNotif notif =
                          LikeNotif.fromMap(doc.data() as Map<String, dynamic>);

                      return CardLikeNotificationWidget(
                        notifId: doc.id,
                        notif: notif,
                        yourId: yourId,
                      );
                    },
                  ).toList(),
                ),
              )
            : Center(
                child: Text(
                  "Empty Notification",
                  style: medium14(colorThird),
                ),
              );
      },
    );
  }
}
