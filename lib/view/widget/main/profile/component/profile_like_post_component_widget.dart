import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileLikePostComponentWidget extends StatelessWidget {
  const ProfileLikePostComponentWidget({
    Key? key,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final ProfilePageType type;
  final String userId, yourId;

  @override
  Widget build(BuildContext context) {
    // Size Grid
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 1 / 5;
    final double itemWidth = size.width / 3;

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
        }
        // Object
        final User user =
            User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        return (user.likedPost!.isNotEmpty)
            ? GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 2,
                childAspectRatio: (itemWidth / itemHeight),
                mainAxisSpacing: 2,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  user.likedPost!.length,
                  (index) {
                    final map = user.likedPost![index];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: firestoreUser
                          .doc(map['user id'])
                          .collection('POST')
                          .doc(map['post id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        } else {
                          if (snapshot.data!.exists) {
                            // Object
                            final map =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final TextPost? text = (map['type'] == postTypeText)
                                ? TextPost.fromMap(map)
                                : null;
                            final ImagePost? image =
                                (map['type'] == postTypeImage)
                                    ? ImagePost.fromMap(map)
                                    : null;

                            return GestureDetector(
                              onTap: () {
                                // Navigate
                                Navigator.push(
                                  context,
                                  navigatorTo(
                                    context: context,
                                    screen: ProfileLikePostPage(
                                      yourId: yourId,
                                      type: type,
                                      userId: userId,
                                      postIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: CardProfileComponentBottomWidget(
                                image: image,
                                text: text,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }
                      },
                    );
                  },
                ).toList())
            : Center(
                child: Text(
                  "Empty Post",
                  style: medium14(colorThird),
                ),
              );
      },
    );
  }
}
