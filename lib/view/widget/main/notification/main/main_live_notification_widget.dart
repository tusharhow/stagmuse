import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/utils/export_utils.dart';

class MainLiveNotificationWidget extends StatelessWidget {
  const MainLiveNotificationWidget({
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
          .where("type", isEqualTo: notificationTypeLive)
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
                      return Container();
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
