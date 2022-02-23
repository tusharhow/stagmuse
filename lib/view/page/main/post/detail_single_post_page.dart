import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class DetailSinglePostPage extends StatelessWidget {
  const DetailSinglePostPage({
    Key? key,
    required this.yourId,
    required this.type,
    required this.userId,
    required this.postId,
  }) : super(key: key);
  final ProfilePageType type;
  final String userId, yourId, postId;

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
        title: // User name
            StreamBuilder<DocumentSnapshot>(
          stream: firestoreUser.doc(userId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading...");
            } else {
              // Object
              final User user =
                  User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

              final DataProfile dataProfile =
                  DataProfile.fromMap(user.dataProfile!);

              return Text("@${dataProfile.username}");
            }
          },
        ),
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
      body: Center(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser
                .doc(userId)
                .collection('POST')
                .doc(postId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'Loading...',
                    style: medium14(colorThird),
                  ),
                );
              } else {
                if (snapshot.data!.exists) {
                  // Object
                  final map = snapshot.data!.data() as Map<String, dynamic>;
                  final ImagePost? imagePost = (map['type'] == postTypeImage)
                      ? ImagePost.fromMap(map)
                      : null;
                  final TextPost? textPost = (map['type'] == postTypeText)
                      ? TextPost.fromMap(map)
                      : null;

                  return (imagePost != null)
                      ? (imagePost.images!.length < 2)
                          ? CardSinglePostImageWidget(
                              yourId: yourId,
                              postId: postId,
                              type: type,
                              imagePost: imagePost,
                            )
                          : CardMultiPostImageWidget(
                              yourId: yourId,
                              postId: postId,
                              imagePost: imagePost,
                              type: type,
                            )
                      : CardPostTextWidget(
                          yourId: yourId,
                          postId: postId,
                          textPost: textPost ?? TextPost(),
                          type: type,
                        );
                } else {
                  return Text(
                    'Post is deleted',
                    style: medium14(colorThird),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
