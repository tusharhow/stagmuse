import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class CardChatListWidget extends StatelessWidget {
  const CardChatListWidget({
    Key? key,
    required this.userId,
    required this.yourId,
  }) : super(key: key);
  final String userId, yourId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        chatServices.deleteChatAt(yourId: yourId, userId: userId);
      },
      child: GestureDetector(
        onTap: () {
          // Navigate
          Navigator.push(
            context,
            navigatorTo(
              context: context,
              screen: ChatDetailPage(
                userId: userId,
                yourId: yourId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
          child: StreamBuilder<DocumentSnapshot>(
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
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);

                  return Row(
                    children: [
                      // Profile
                      photoProfileNetworkUtils(
                          size: 48, url: dataProfile.photo),
                      const SizedBox(width: 12),
                      // Name || Latest Message || Time
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            // Name
                            Text(
                              "@${dataProfile.username}",
                              style: semiBold14(colorThird),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Latest Message || Time
                            StreamBuilder<QuerySnapshot>(
                              stream: firestoreUser
                                  .doc(yourId)
                                  .collection('CHAT')
                                  .doc(userId)
                                  .collection('MESSAGES')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox();
                                } else {
                                  final lastChat = snapshot.data!.docs[0].data()
                                      as Map<String, dynamic>;
                                  final List chats = lastChat['Chats'];
                                  final chat = chats[chats.length - 1];

                                  final TextMessage? textMessage =
                                      (chat['type'] == chatTypeText)
                                          ? TextMessage.fromMap(chat)
                                          : null;
                                  final StoryCommentMessage? storyMessage =
                                      (chat['type'] == chatTypeStory)
                                          ? StoryCommentMessage.fromMap(chat)
                                          : null;

                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: firestoreUser
                                          .doc(yourId)
                                          .collection('CHAT')
                                          .doc(userId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        } else {
                                          final read = snapshot.data!.data()
                                              as Map<String, dynamic>;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Latest
                                              (textMessage != null)
                                                  ? Text(
                                                      textMessage.message!,
                                                      style: (read['read'])
                                                          ? regular12(
                                                              Colors.grey)
                                                          : regular12(
                                                              colorThird),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  : (storyMessage != null)
                                                      ? Text(
                                                          storyMessage.message!,
                                                          style: (read['read'])
                                                              ? regular12(
                                                                  Colors.grey)
                                                              : regular12(
                                                                  colorThird),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : Row(
                                                          children: [
                                                            const Icon(
                                                              Custom.picture,
                                                              color:
                                                                  Colors.grey,
                                                              size: 12,
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              'Image',
                                                              style: (read[
                                                                      'read'])
                                                                  ? regular12(
                                                                      Colors
                                                                          .grey)
                                                                  : regular12(
                                                                      colorThird),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                              const SizedBox(height: 6),
                                              // Time
                                              Text(
                                                handlingTimeUtils(chat['time']),
                                                style: regular12(Colors.grey),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          );
                                        }
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
