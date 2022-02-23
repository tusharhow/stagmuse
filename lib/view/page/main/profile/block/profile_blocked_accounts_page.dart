import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileBlockedAccountsPage extends StatelessWidget {
  const ProfileBlockedAccountsPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: margin),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Custom.back),
            ),
          ],
        ),
        title: const Text("Blocked Accounts"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
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

            return (user.block!.isNotEmpty)
                ? SingleChildScrollView(
                    child: Column(
                      children: List.generate(user.block!.length, (index) {
                        // Object
                        final accountId = user.block![index];

                        return StreamBuilder<DocumentSnapshot>(
                            stream: firestoreUser.doc(accountId).snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text(
                                    "Loading...",
                                    style: medium12(colorThird),
                                  ),
                                );
                              } else {
                                // Object
                                final User user = User.fromMap(snapshot.data!
                                    .data() as Map<String, dynamic>);
                                final DataProfile dataProfile =
                                    DataProfile.fromMap(user.dataProfile!);

                                return CardProfileBlockedAccountsWidget(
                                  userId: accountId,
                                  yourId: yourId,
                                  dataProfile: dataProfile,
                                );
                              }
                            });
                      }).toList(),
                    ),
                  )
                : Center(
                    child: Text(
                      "Empty Blocked Accounts",
                      style: medium14(colorThird),
                    ),
                  );
          }
        },
      ),
    );
  }
}
