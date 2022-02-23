import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CardLikePostWidget extends StatelessWidget {
  const CardLikePostWidget({
    Key? key,
    required this.yourId,
    required this.postId,
    required this.userId,
    required this.imagePost,
    required this.textPost,
  }) : super(key: key);
  final String yourId, userId, postId;
  final ImagePost? imagePost;
  final TextPost? textPost;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          // Object
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);

          return GestureDetector(
            onTap: () {
              // Navigate
              Navigator.push(
                context,
                navigatorTo(
                  context: context,
                  screen: DetailSinglePostPage(
                    yourId: yourId,
                    type: ProfilePageType.own,
                    userId: yourId,
                    postId: postId,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              color: colorBackground,
              padding:
                  const EdgeInsets.symmetric(horizontal: margin, vertical: 8),
              child: Row(
                children: [
                  // Post Cover
                  (imagePost != null)
                      ? Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            image: DecorationImage(
                              image: NetworkImage(imagePost!.images![0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(4),
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: Text(
                              textPost!.status!,
                              style: const TextStyle(
                                fontSize: 8,
                                color: colorThird,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${dataProfile.username}",
                          style: semiBold14(colorThird),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        (imagePost != null)
                            ? Text(
                                textPost!.status!,
                                style: regular12(Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Unlike Button
                  GestureDetector(
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
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
