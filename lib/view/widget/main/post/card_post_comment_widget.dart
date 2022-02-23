import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CardPostMainCommentWidget extends StatefulWidget {
  const CardPostMainCommentWidget({
    Key? key,
    required this.commentId,
    required this.userId,
    required this.yourId,
    required this.postId,
    required this.comment,
  }) : super(key: key);
  final String userId, yourId, postId, commentId;
  final CommentPost comment;

  @override
  _CardPostMainCommentWidgetState createState() =>
      _CardPostMainCommentWidgetState();
}

class _CardPostMainCommentWidgetState extends State<CardPostMainCommentWidget> {
  bool _expand = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _expand = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.doc(widget.comment.userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          // Object
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: margin,
              vertical: 12,
            ),
            child: Column(
              children: [
                // Main Comment
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo
                    photoProfileNetworkUtils(size: 36, url: dataProfile.photo),
                    const SizedBox(width: 12),
                    // User name || Comment || Time || Total Like || Button Reply
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User name || Comment
                          RichText(
                            text: TextSpan(
                              text: (widget.comment.userId == widget.yourId)
                                  ? "You "
                                  : "@${dataProfile.username} ",
                              style: semiBold14(colorThird),
                              children: [
                                TextSpan(
                                  text: widget.comment.comment,
                                  style: regular14(colorThird),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Time || Total like || Button Reply
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Time
                              Flexible(
                                child: Text(
                                  handlingTimeUtils(widget.comment.time!),
                                  style: medium10(Colors.grey),
                                ),
                              ),
                              // Total Like
                              Flexible(
                                child: Text(
                                  "${convertTextFormat(widget.comment.likes!.length)} likes",
                                  style: medium10(Colors.grey),
                                ),
                              ),
                              // Button Reply
                              GestureDetector(
                                onTap: () {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return CommentBarWidget.reply(
                                        username: "@${dataProfile.username}",
                                        postId: widget.postId,
                                        userId: widget.userId,
                                        commentId: widget.commentId,
                                        yourId: widget.yourId,
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Reply",
                                  style: medium10(Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Button Like
                    FavoriteButtonCommentWidget(
                      likeForMain: true,
                      commentId: widget.commentId,
                      postId: widget.postId,
                      userId: widget.userId,
                      yourId: widget.yourId,
                      replyId: "",
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sub Comments
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreUser
                      .doc(widget.userId)
                      .collection('POST')
                      .doc(widget.postId)
                      .collection('COMMENT')
                      .doc(widget.commentId)
                      .collection('REPLY')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    return (snapshot.data!.docs.isNotEmpty)
                        ? Column(
                            children: [
                              // Button See all replies
                              (_expand)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _expand = false;
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Show less",
                                          style: medium10(Colors.grey),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _expand = true;
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "See all ${snapshot.data!.docs.length} replies",
                                          style: medium10(Colors.grey),
                                        ),
                                      ),
                                    ),
                              // Replies
                              (_expand)
                                  ? Column(
                                      children: snapshot.data!.docs.map(
                                      (doc) {
                                        // Object
                                        final CommentPost reply =
                                            CommentPost.fromMap(doc.data()
                                                as Map<String, dynamic>);

                                        return CardPostSubMainCommentWidget(
                                          postId: widget.postId,
                                          userId: widget.userId,
                                          commentId: widget.commentId,
                                          yourId: widget.yourId,
                                          reply: reply,
                                          replyId: doc.id,
                                        );
                                      },
                                    ).toList())
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox();
                  },
                )
              ],
            ),
          );
        }
      },
    );
  }
}

class CardPostSubMainCommentWidget extends StatelessWidget {
  const CardPostSubMainCommentWidget({
    Key? key,
    required this.replyId,
    required this.yourId,
    required this.postId,
    required this.userId,
    required this.commentId,
    required this.reply,
  }) : super(key: key);
  final String userId, postId, replyId, yourId, commentId;
  final CommentPost reply;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.doc(reply.userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          // Object
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: margin + 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                photoProfileNetworkUtils(size: 24, url: dataProfile.photo),
                const SizedBox(width: 12),
                // User name || Comment || Time || Total Like || Button Reply || Button See all replies
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name
                      RichText(
                        text: TextSpan(
                          text: (reply.userId == yourId)
                              ? "You "
                              : "@${dataProfile.username} ",
                          style: semiBold12(colorThird),
                          children: [
                            TextSpan(
                              text: reply.comment,
                              style: regular12(colorThird),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Time || Total like || Button Reply
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time
                          Flexible(
                            child: Text(
                              handlingTimeUtils(reply.time!),
                              style: medium10(Colors.grey),
                            ),
                          ),
                          // Total Like
                          Flexible(
                            child: Text(
                              "${convertTextFormat(reply.likes!.length)} likes",
                              style: medium10(Colors.grey),
                            ),
                          ),
                          // Button Reply
                          GestureDetector(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return CommentBarWidget.reply(
                                    username: "@${dataProfile.username} ",
                                    postId: postId,
                                    userId: userId,
                                    commentId: commentId,
                                    yourId: yourId,
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Reply",
                              style: medium10(Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Button Like
                FavoriteButtonCommentWidget(
                  likeForMain: false,
                  commentId: commentId,
                  postId: postId,
                  userId: userId,
                  yourId: yourId,
                  replyId: replyId,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
