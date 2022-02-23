import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileDetailSavePostPage extends StatelessWidget {
  const ProfileDetailSavePostPage({
    Key? key,
    required this.postIndex,
    required this.userId,
  }) : super(key: key);
  final String userId;
  final int postIndex;

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
        title: const Text("Detail saved posts"),
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
                ? ScrollablePositionedList.builder(
                    initialScrollIndex: postIndex,
                    itemCount: user.savePost!.length,
                    itemBuilder: (context, index) {
                      // Object
                      final map1 = user.savePost![index];

                      return StreamBuilder<DocumentSnapshot>(
                        stream: firestoreUser
                            .doc(map1['user id'])
                            .collection('POST')
                            .doc(map1['post id'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            // Object
                            final map2 =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final ImagePost? imagePost =
                                (map2['type'] == postTypeImage)
                                    ? ImagePost.fromMap(map2)
                                    : null;
                            final TextPost? textPost =
                                (map2['type'] == postTypeText)
                                    ? TextPost.fromMap(map2)
                                    : null;

                            return (imagePost != null)
                                ? (imagePost.images!.length < 2)
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: 16,
                                          bottom: (snapshot.data!.id ==
                                                  user.savePost!
                                                      .last['post id'])
                                              ? 16
                                              : 0,
                                        ),
                                        child: CardSinglePostImageWidget(
                                          yourId: userId,
                                          postId: snapshot.data!.id,
                                          type: ProfilePageType.other,
                                          imagePost: imagePost,
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: 16,
                                          bottom: (snapshot.data!.id ==
                                                  user.savePost!
                                                      .last['post id'])
                                              ? 16
                                              : 0,
                                        ),
                                        child: CardMultiPostImageWidget(
                                          yourId: userId,
                                          postId: snapshot.data!.id,
                                          imagePost: imagePost,
                                          type: ProfilePageType.other,
                                        ),
                                      )
                                : Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                      bottom: (snapshot.data!.id ==
                                              user.savePost!.last['post id'])
                                          ? 16
                                          : 0,
                                    ),
                                    child: CardPostTextWidget(
                                      yourId: userId,
                                      postId: snapshot.data!.id,
                                      textPost: textPost ?? TextPost(),
                                      type: ProfilePageType.other,
                                    ),
                                  );
                          }
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Empty Post",
                      style: medium14(colorThird),
                    ),
                  );
          }
        },
      ),
    );
  }
}
