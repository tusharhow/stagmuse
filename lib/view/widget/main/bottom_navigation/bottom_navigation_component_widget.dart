import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

Widget profileBottomNavigationWidget({
  required int index,
  required String yourId,
}) {
  return StreamBuilder<DocumentSnapshot>(
    stream: firestoreUser.doc(yourId).snapshots(),
    builder: (_, snapshot) {
      if (!snapshot.hasData) {
        return Icon(
          (index == 3) ? Custom.userFill : Custom.userOutline,
          color: Colors.white,
        );
      } else {
        // Object
        final User user =
            User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        final DataProfile dataProfile = DataProfile.fromMap(user.dataProfile!);

        return (dataProfile.photo == null)
            ? Icon(
                (index == 3) ? Custom.userFill : Custom.userOutline,
                color: Colors.white,
              )
            : photoProfileNetworkUtils(
                size: 24,
                url: dataProfile.photo,
                borderColor: (index == 3) ? colorThird : null,
              );
      }
    },
  );
}

Widget notificationBottomNavigationWidget({
  required Widget icon,
  required int total,
}) {
  return (total > 0)
      ? Badge(
          position: const BadgePosition(top: -10, end: -3),
          badgeContent: Text(
            ((total) > 9) ? "9+" : "$total",
            style: regular10(colorThird),
          ),
          badgeColor: Colors.red,
          child: icon,
        )
      : icon;
}
