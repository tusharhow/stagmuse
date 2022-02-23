import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class PostCommentPage extends StatelessWidget {
  const PostCommentPage({
    Key? key,
    required this.yourId,
    required this.userId,
    required this.postId,
  }) : super(key: key);
  final String userId, yourId, postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
            title: const Text("Comments"),
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
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                // Description
                StreamBuilder<DocumentSnapshot>(
                  stream: firestoreUser
                      .doc(userId)
                      .collection('POST')
                      .doc(postId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else {
                      // Object
                      final post =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final TextPost? textPost = (post['type'] == postTypeText)
                          ? TextPost.fromMap(post)
                          : null;
                      final ImagePost? imagePost =
                          (post['type'] == postTypeImage)
                              ? ImagePost.fromMap(post)
                              : null;

                      return StreamBuilder<DocumentSnapshot>(
                        stream: firestoreUser.doc(post['user id']).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            // Object
                            final User user = User.fromMap(
                                snapshot.data!.data() as Map<String, dynamic>);
                            final DataProfile dataProfile =
                                DataProfile.fromMap(user.dataProfile!);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: margin,
                                vertical: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Photo
                                  photoProfileNetworkUtils(
                                    size: 36,
                                    url: dataProfile.photo,
                                  ),
                                  const SizedBox(width: 12),
                                  // Description || Time
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Description
                                        RichText(
                                          text: TextSpan(
                                            text: "@${dataProfile.username} ",
                                            style: semiBold14(colorThird),
                                            children: [
                                              TextSpan(
                                                text: (textPost != null)
                                                    ? textPost.status
                                                    : imagePost!.description,
                                                style: regular14(colorThird),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Time
                                        Text(
                                          handlingTimeUtils(post['time']),
                                          style: medium14(Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
                Container(height: 0.5, color: colorPrimary),
                // Comments
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreUser
                      .doc(userId)
                      .collection('POST')
                      .doc(postId)
                      .collection('COMMENT')
                      .orderBy('likes', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else {
                      return (snapshot.data!.docs.isNotEmpty)
                          ? Column(
                              children: snapshot.data!.docs.map(
                                (doc) {
                                  // Object
                                  final CommentPost comment =
                                      CommentPost.fromMap(
                                          doc.data() as Map<String, dynamic>);

                                  return CardPostMainCommentWidget(
                                    postId: postId,
                                    userId: userId,
                                    yourId: yourId,
                                    comment: comment,
                                    commentId: doc.id,
                                  );
                                },
                              ).toList(),
                            )
                          : const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
