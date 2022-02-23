import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

enum ProfilePageType { own, other }

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final ProfilePageType type;
  final String yourId;
  final String? userId;

  const ProfilePage.own({
    Key? key,
    this.type = ProfilePageType.own,
    required this.yourId,
    required this.userId,
  }) : super(key: key);

  const ProfilePage.other({
    Key? key,
    this.type = ProfilePageType.other,
    required this.yourId,
    required this.userId,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: (widget.type == ProfilePageType.own)
            ? null
            : Row(
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
        title: Row(
          children: [
            SizedBox(
              width: (widget.type == ProfilePageType.own) ? 12 : 0,
            ),
            // User name
            StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser
                  .doc((widget.type == ProfilePageType.own)
                      ? widget.yourId
                      : widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("Loading...");
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);

                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);

                  return Text("@${dataProfile.username}");
                }
              },
            ),
          ],
        ),
        actions: [
          profilePopMenuWidget(
            context: context,
            type: widget.type,
            yourId: widget.yourId,
            userId: (widget.type == ProfilePageType.own) ? null : widget.userId,
          ),
          const SizedBox(width: 12),
        ],
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorSecondary,
                colorPrimary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: (widget.type == ProfilePageType.own)
          ? ProfileMainWidget(
              type: ProfilePageType.own,
              yourId: widget.yourId,
              userId: widget.userId,
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(widget.yourId).snapshots(),
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
                  final User user1 = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);

                  return StreamBuilder<DocumentSnapshot>(
                      stream: firestoreUser.doc(widget.userId!).snapshots(),
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
                          final User user2 = User.fromMap(
                              snapshot.data!.data() as Map<String, dynamic>);

                          return (user2.privateAccount!)
                              ? ProfileBlocPrivatekWidget(
                                  block: user1.block!,
                                  private: user1.following!,
                                  yourId: widget.yourId,
                                  userId: snapshot.data!.id,
                                )
                              : ProfileMainWidget(
                                  type: ProfilePageType.other,
                                  yourId: widget.yourId,
                                  userId: widget.userId,
                                );
                        }
                      });
                }
              },
            ),
    );
  }
}
