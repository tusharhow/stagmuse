import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

class SaveButtonPostWidget extends StatelessWidget {
  const SaveButtonPostWidget({
    Key? key,
    required this.userId,
    required this.postId,
    required this.yourId,
  }) : super(key: key);
  final String yourId, userId, postId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestoreUser.doc(yourId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
              onPressed: () {},
              icon: const Icon(Custom.bookmarkOutline,
                  size: 20, color: colorThird),
            );
          } else {
            // Object
            final User user =
                User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

            return (user.savePost!.isEmpty)
                ? GestureDetector(
                    onTap: () {
                      postServices.savePost(
                        yourId: yourId,
                        postId: postId,
                        userId: userId,
                      );
                    },
                    child: const Icon(
                      Custom.bookmarkOutline,
                      color: colorThird,
                      size: 20,
                    ),
                  )
                : (user.savePost!
                        .where((map) => map['post id'] == postId)
                        .isNotEmpty)
                    ? GestureDetector(
                        onTap: () {
                          postServices.unSavePost(
                            userId: userId,
                            yourId: yourId,
                            postId: postId,
                          );
                        },
                        child: const Icon(
                          Custom.bookmarkFill,
                          color: colorThird,
                          size: 20,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          postServices.savePost(
                            yourId: yourId,
                            postId: postId,
                            userId: userId,
                          );
                        },
                        child: const Icon(
                          Custom.bookmarkOutline,
                          color: colorThird,
                          size: 20,
                        ),
                      );
          }
        });
  }
}
