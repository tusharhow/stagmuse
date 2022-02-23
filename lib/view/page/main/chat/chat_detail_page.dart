import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    Key? key,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final String yourId;
  final String userId;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // Controller
  final ItemScrollController scroll = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        notificationMessagingServices.subsribeTopic("chat${widget.yourId}");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              const SizedBox(width: margin),
              GestureDetector(
                onTap: () {
                  notificationMessagingServices.subsribeTopic(
                    "chat${widget.yourId}",
                  );
                  Navigator.pop(context);
                },
                child: const Icon(Custom.back),
              ),
            ],
          ),
          title: StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.doc(widget.userId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(
                  "Loading...",
                  style: medium12(colorThird),
                );
              } else {
                // Object
                final User user =
                    User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                final DataProfile dataProfile =
                    DataProfile.fromMap(user.dataProfile!);

                return Row(
                  children: [
                    photoProfileNetworkUtils(size: 24, url: dataProfile.photo),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(
                      "@${dataProfile.username}",
                      style: medium14(colorThird),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                );
              }
            },
          ),
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreUser
                    .doc(widget.yourId)
                    .collection('CHAT')
                    .doc(widget.userId)
                    .collection('MESSAGES')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "Loading",
                        style: medium14(colorThird),
                      ),
                    );
                  }
                  return snapshot.data!.docs.isNotEmpty
                      ? SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            children: List.generate(snapshot.data!.docs.length,
                                (index) {
                              final chatDateId = snapshot.data!.docs[index];

                              return StreamBuilder<DocumentSnapshot>(
                                stream: firestoreUser
                                    .doc(widget.yourId)
                                    .collection('CHAT')
                                    .doc(widget.userId)
                                    .collection('MESSAGES')
                                    .doc(chatDateId.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container(
                                        width: 10,
                                        height: 8,
                                        color: colorPrimary);
                                  } else {
                                    // Object
                                    final map = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    final List chats = map['Chats'];

                                    return Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        Center(
                                          child: Text(
                                            handlingChatTimeUtils(
                                              snapshot.data!.id,
                                            ),
                                            style: medium12(Colors.grey),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Column(
                                          children: chats.map((data) {
                                            // Object
                                            final TextMessage? textMessage =
                                                (data['type'] == chatTypeText)
                                                    ? TextMessage.fromMap(data)
                                                    : null;
                                            final ImageMessage? imageMessage =
                                                (data['type'] == chatTypeImage)
                                                    ? ImageMessage.fromMap(data)
                                                    : null;

                                            final StoryCommentMessage?
                                                storyMessage =
                                                (data['type'] == chatTypeStory)
                                                    ? StoryCommentMessage
                                                        .fromMap(data)
                                                    : null;

                                            // Update read chat
                                            chatServices.udpdateReadChat(
                                              yourId: widget.yourId,
                                              userId: widget.userId,
                                              dateChatId: chatDateId.id,
                                            );

                                            // Unsub topic chat
                                            notificationMessagingServices
                                                .unSubsribeTopic(
                                              'chat${widget.yourId}',
                                            );
                                            return Column(
                                              children: [
                                                (textMessage != null)
                                                    // Text
                                                    ? (textMessage.from ==
                                                            chatFrom(
                                                                widget.yourId))
                                                        ? ChatTextBubbleSender(
                                                            message:
                                                                textMessage,
                                                          )
                                                        : ChatTextBubbleReceive(
                                                            message:
                                                                textMessage,
                                                          )
                                                    :
                                                    // Story
                                                    (storyMessage != null)
                                                        ? (storyMessage.from ==
                                                                chatFrom(widget
                                                                    .yourId))
                                                            ? ChatStoryBubbleSender(
                                                                userId: widget
                                                                    .userId,
                                                                storyId:
                                                                    storyMessage
                                                                        .storyId!,
                                                                message:
                                                                    storyMessage)
                                                            : ChatStoryBubbleReceive(
                                                                userId: widget
                                                                    .userId,
                                                                storyId:
                                                                    storyMessage
                                                                        .storyId!,
                                                                message:
                                                                    storyMessage)
                                                        :
                                                        // Image
                                                        (imageMessage!.from ==
                                                                chatFrom(widget
                                                                    .yourId))
                                                            ? ChatImageBubbleSender(
                                                                message:
                                                                    imageMessage,
                                                              )
                                                            : ChatImageBubbleReceive(
                                                                message:
                                                                    imageMessage,
                                                              ),
                                                const SizedBox(height: 8),
                                              ],
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
            Container(height: 0.5, color: colorPrimary),
            // Chat bar
            ChatBarWidget(userId: widget.userId, yourId: widget.yourId),
          ],
        ),
      ),
    );
  }
}
