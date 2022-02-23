import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfileLikePostPage extends StatefulWidget {
  const ProfileLikePostPage({
    Key? key,
    required this.postIndex,
    required this.type,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final int postIndex;
  final ProfilePageType type;
  final String userId, yourId;

  @override
  _ProfileLikePostPageState createState() => _ProfileLikePostPageState();
}

class _ProfileLikePostPageState extends State<ProfileLikePostPage> {
  // Controller
  final scroll = ItemScrollController();

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
        title: const Text('Liked Posts'),
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
        stream: firestoreUser.doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Loading...',
                style: medium14(colorThird),
              ),
            );
          }
          // Object
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return (user.likedPost!.isNotEmpty)
              ? ScrollablePositionedList.builder(
                  itemScrollController: scroll,
                  initialScrollIndex: widget.postIndex,
                  itemCount: user.likedPost!.length,
                  itemBuilder: (context, index) {
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
                            final ImagePost? imagePost =
                                (map['type'] == postTypeImage)
                                    ? ImagePost.fromMap(map)
                                    : null;
                            final TextPost? textPost =
                                (map['type'] == postTypeText)
                                    ? TextPost.fromMap(map)
                                    : null;

                            return Column(
                              children: [
                                (imagePost != null)
                                    ? (imagePost.images!.length < 2)
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              top: 16,
                                              bottom: (snapshot.data!.id ==
                                                      user.likedPost![user
                                                              .likedPost!
                                                              .length -
                                                          1]['post id'])
                                                  ? 16
                                                  : 0,
                                            ),
                                            child: CardSinglePostImageWidget(
                                              yourId: widget.yourId,
                                              postId: snapshot.data!.id,
                                              type: widget.type,
                                              imagePost: imagePost,
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                              top: 16,
                                              bottom: (snapshot.data!.id ==
                                                      user.likedPost![user
                                                              .likedPost!
                                                              .length -
                                                          1]['post id'])
                                                  ? 16
                                                  : 0,
                                            ),
                                            child: CardMultiPostImageWidget(
                                              yourId: widget.yourId,
                                              postId: snapshot.data!.id,
                                              imagePost: imagePost,
                                              type: widget.type,
                                            ),
                                          )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: 16,
                                          bottom: (snapshot.data!.id ==
                                                  user.likedPost![
                                                      user.likedPost!.length -
                                                          1]['post id'])
                                              ? 16
                                              : 0,
                                        ),
                                        child: CardPostTextWidget(
                                          yourId: widget.yourId,
                                          postId: snapshot.data!.id,
                                          textPost: textPost ?? TextPost(),
                                          type: widget.type,
                                        ),
                                      )
                              ],
                            );
                          } else {
                            // Delete Like Post
                            postServices.unLikePost(
                              yourId: widget.userId,
                              userId: map['user id'],
                              postId: map['post id'],
                            );

                            return const SizedBox();
                          }
                        }
                      },
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Empty Post',
                    style: medium14(colorThird),
                  ),
                );
        },
      ),
    );
  }
}
