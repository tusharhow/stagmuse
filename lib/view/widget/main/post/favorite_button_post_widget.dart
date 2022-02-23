import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';

class FavoriteButtonPostWidget extends StatelessWidget {
  const FavoriteButtonPostWidget({
    Key? key,
    required this.postFrom,
    required this.userId,
    required this.postId,
    required this.yourId,
  }) : super(key: key);
  final String yourId, userId, postId, postFrom;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.doc(yourId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.favorite_outline_rounded,
              color: colorThird,
            ),
          );
        } else {
          // Object
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);

          return (user.likedPost!.isEmpty)
              ? GestureDetector(
                  onTap: () {
                    // For Post && You
                    postServices.likePost(
                      yourId: yourId,
                      userId: userId,
                      postId: postId,
                    );

                    if (postFrom != yourId) {
                      // For Notif
                      notificationServices.addLikeNotif(
                        yourId: userId,
                        userId: yourId,
                        postId: postId,
                      );

                      // Send
                      notificationMessagingServices.sendNotification(
                        title: 'Stagemuse',
                        subject: "@${dataProfile.username} like your post",
                        topics: "notif$userId",
                      );
                    }
                  },
                  child: const Icon(
                    Icons.favorite_outline_rounded,
                    color: colorThird,
                  ),
                )
              : (user.likedPost!
                      .where((map) => map['post id'] == postId)
                      .isNotEmpty)
                  ? GestureDetector(
                      onTap: () {
                        // For Post && You
                        postServices.unLikePost(
                          yourId: yourId,
                          userId: userId,
                          postId: postId,
                        );
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // For Post && You
                        postServices.likePost(
                          yourId: yourId,
                          userId: userId,
                          postId: postId,
                        );
                      },
                      child: const Icon(
                        Icons.favorite_outline_rounded,
                        color: colorThird,
                      ),
                    );
        }
      },
    );
  }
}

class FavoriteButtonCommentWidget extends StatelessWidget {
  const FavoriteButtonCommentWidget({
    Key? key,
    required this.likeForMain,
    required this.commentId,
    required this.userId,
    required this.postId,
    required this.yourId,
    required this.replyId,
  }) : super(key: key);
  final bool likeForMain;
  final String yourId, userId, replyId, commentId, postId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        (likeForMain)
            ? StreamBuilder<DocumentSnapshot>(
                stream: firestoreUser
                    .doc(userId)
                    .collection('POST')
                    .doc(postId)
                    .collection('COMMENT')
                    .doc(commentId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.favorite_outline_rounded,
                        color: colorThird,
                        size: 18,
                      ),
                    );
                  } else {
                    // Object
                    final CommentPost comment = CommentPost.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);

                    return (comment.likes!.isEmpty)
                        ? GestureDetector(
                            onTap: () {
                              // For Post
                              postServices.likeComment(
                                likeMainComment: true,
                                yourId: yourId,
                                postId: postId,
                                commentId: commentId,
                                replyId: "",
                                userId: userId,
                              );
                            },
                            child: const Icon(
                              Icons.favorite_outline_rounded,
                              color: colorThird,
                              size: 18,
                            ),
                          )
                        : (comment.likes!.contains(yourId))
                            ? GestureDetector(
                                onTap: () {
                                  postServices.unLikeComment(
                                    likeMainComment: true,
                                    yourId: yourId,
                                    postId: postId,
                                    commentId: commentId,
                                    replyId: "",
                                    userId: userId,
                                  );
                                },
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  postServices.likeComment(
                                    likeMainComment: true,
                                    yourId: yourId,
                                    postId: postId,
                                    commentId: commentId,
                                    replyId: "",
                                    userId: userId,
                                  );
                                },
                                child: const Icon(
                                  Icons.favorite_outline_rounded,
                                  color: colorThird,
                                  size: 18,
                                ),
                              );
                  }
                },
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: firestoreUser
                    .doc(userId)
                    .collection('POST')
                    .doc(postId)
                    .collection('COMMENT')
                    .doc(commentId)
                    .collection('REPLY')
                    .doc(replyId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.favorite_outline_rounded,
                        color: colorThird,
                        size: 18,
                      ),
                    );
                  } else {
                    // Object
                    final CommentPost reply = CommentPost.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);

                    return (reply.likes!.isEmpty)
                        ? GestureDetector(
                            onTap: () {
                              // For Post
                              postServices.likeComment(
                                likeMainComment: false,
                                yourId: yourId,
                                postId: postId,
                                commentId: commentId,
                                replyId: replyId,
                                userId: userId,
                              );
                            },
                            child: const Icon(
                              Icons.favorite_outline_rounded,
                              color: colorThird,
                              size: 18,
                            ),
                          )
                        : (reply.likes!.contains(yourId))
                            ? GestureDetector(
                                onTap: () {
                                  postServices.unLikeComment(
                                    likeMainComment: false,
                                    yourId: yourId,
                                    postId: postId,
                                    commentId: commentId,
                                    replyId: replyId,
                                    userId: userId,
                                  );
                                },
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  postServices.likeComment(
                                    likeMainComment: false,
                                    yourId: yourId,
                                    postId: postId,
                                    commentId: commentId,
                                    replyId: replyId,
                                    userId: userId,
                                  );
                                },
                                child: const Icon(
                                  Icons.favorite_outline_rounded,
                                  color: colorThird,
                                  size: 18,
                                ),
                              );
                  }
                },
              ),
      ],
    );
  }
}
