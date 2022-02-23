import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileSavePostPage extends StatelessWidget {
  const ProfileSavePostPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    // Size Grid
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 1 / 5;
    final double itemWidth = size.width / 3;

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
        title: const Text("Saved posts"),
        centerTitle: true,
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
      body: StreamBuilder<DocumentSnapshot>(
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

            return (user.savePost!.isNotEmpty)
                ? GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 2,
                    childAspectRatio: (itemWidth / itemHeight),
                    mainAxisSpacing: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      user.savePost!.length,
                      (index) {
                        final map = user.savePost![index];

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
                                final map = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                final ImagePost? imagePost =
                                    (map['type'] == postTypeImage)
                                        ? ImagePost.fromMap(map)
                                        : null;
                                final TextPost? textPost =
                                    (map['type'] == postTypeText)
                                        ? TextPost.fromMap(map)
                                        : null;

                                return GestureDetector(
                                  onTap: () {
                                    // Navigate
                                    Navigator.push(
                                      context,
                                      navigatorTo(
                                        context: context,
                                        screen: ProfileDetailSavePostPage(
                                          userId: userId,
                                          postIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CardProfileComponentBottomWidget(
                                    image: imagePost,
                                    text: textPost,
                                  ),
                                );
                              } else {
                                if (!snapshot.data!.exists) {
                                  postServices.unSavePost(
                                    userId: map['user id'],
                                    yourId: userId,
                                    postId: map['post id'],
                                  );
                                }

                                return const SizedBox();
                              }
                            }
                          },
                        );
                      },
                    ).toList(),
                  )
                : Center(
                    child: Text(
                      "Empty Saved Posts",
                      style: medium14(colorThird),
                    ),
                  );
          }
        },
      ),
    );
  }
}
