import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/chat/chat.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

// Text
class ChatTextBubbleSender extends StatelessWidget {
  const ChatTextBubbleSender({
    Key? key,
    required this.message,
  }) : super(key: key);
  final TextMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 1 / 5, right: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecondary,
                    colorPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Text(
                message.message!,
                style: medium12(colorThird),
              ),
            ),
            // Time
            Text(
              handlingChatTime(message.time!),
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTextBubbleReceive extends StatelessWidget {
  const ChatTextBubbleReceive({
    Key? key,
    required this.message,
  }) : super(key: key);
  final TextMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 1 / 5, left: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: colorThird,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                message.message!,
                style: medium12(colorBackground),
              ),
            ),
            // Time
            Text(
              handlingChatTime(message.time!),
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Audio
class ChatAudioBubbleSender extends StatelessWidget {
  const ChatAudioBubbleSender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 1 / 2, right: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Play || Control || Duration
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecondary,
                    colorPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Play
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Custom.play, color: colorThird),
                  ),
                  const SizedBox(width: 4),
                  // Control
                  Expanded(
                    child: Container(
                      height: 1,
                      color: colorThird,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Duration
                  Text(
                    "10:09",
                    style: semiBold12(colorThird),
                  ),
                ],
              ),
            ),
            // Time
            Text(
              "01.30 AM",
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatAudioBubbleReceive extends StatelessWidget {
  const ChatAudioBubbleReceive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 1 / 2, left: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: colorThird,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Play
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Custom.play, color: colorBackground),
                  ),
                  const SizedBox(width: 4),
                  // Control
                  Expanded(
                    child: Container(
                      height: 1,
                      color: colorBackground,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Duration
                  Text(
                    "10:09",
                    style: semiBold12(colorBackground),
                  ),
                ],
              ),
            ),
            // Time
            Text(
              "01.30 AM",
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Call
enum ChatCallType { phone, video }

class ChatCallBubbleSender extends StatelessWidget {
  const ChatCallBubbleSender({
    Key? key,
    required this.type,
  }) : super(key: key);
  final ChatCallType type;

  const ChatCallBubbleSender.phone({
    Key? key,
    this.type = ChatCallType.phone,
  }) : super(key: key);

  const ChatCallBubbleSender.video({
    Key? key,
    this.type = ChatCallType.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          left: margin,
          right: margin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Play || Control || Duration
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecondary,
                    colorPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Icon(
                      (type == ChatCallType.phone)
                          ? Icons.phone
                          : Icons.videocam,
                      color: colorThird),
                  const SizedBox(width: 4),
                  // Description
                  Text(
                    (type == ChatCallType.phone)
                        ? "Phone call begins"
                        : "Video call begins",
                    style: semiBold12(colorThird),
                  ),
                ],
              ),
            ),
            // Time
            Text(
              "01.30 AM",
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatCallBubbleReceive extends StatelessWidget {
  const ChatCallBubbleReceive({
    Key? key,
    required this.type,
  }) : super(key: key);
  final ChatCallType type;

  const ChatCallBubbleReceive.phone({
    Key? key,
    this.type = ChatCallType.phone,
  }) : super(key: key);

  const ChatCallBubbleReceive.video({
    Key? key,
    this.type = ChatCallType.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: margin,
          right: margin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: colorThird,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Icon(
                    (type == ChatCallType.phone) ? Icons.phone : Icons.videocam,
                    color: colorBackground,
                  ),
                  const SizedBox(width: 4),
                  // Description
                  Text(
                    (type == ChatCallType.phone)
                        ? "Phone call begins"
                        : "Video call begins",
                    style: semiBold12(colorBackground),
                  ),
                ],
              ),
            ),
            // Time
            Text(
              "01.30 AM",
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Image
class ChatImageBubbleSender extends StatelessWidget {
  const ChatImageBubbleSender({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ImageMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 1 / 3, right: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1 / 4,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecondary,
                    colorPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(message.url!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Time
            Text(
              handlingChatTime(message.time!),
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatImageBubbleReceive extends StatelessWidget {
  const ChatImageBubbleReceive({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ImageMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 1 / 3, left: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1 / 4,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: colorThird,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(message.url!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Time
            Text(
              handlingChatTime(message.time!),
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Story
class ChatStoryBubbleSender extends StatelessWidget {
  const ChatStoryBubbleSender({
    Key? key,
    required this.userId,
    required this.storyId,
    required this.message,
  }) : super(key: key);
  final String userId, storyId;
  final StoryCommentMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 1 / 3, right: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecondary,
                    colorPrimary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Story View
                  StreamBuilder<DocumentSnapshot>(
                      stream: firestoreUser
                          .doc(userId)
                          .collection('STORY')
                          .doc(storyId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              'Loading...',
                              style: medium12(colorThird),
                            ),
                          );
                        } else {
                          if (snapshot.data!.exists) {
                            // Story
                            final Story story = Story.fromMap(
                                snapshot.data!.data() as Map<String, dynamic>);

                            return Container(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 1 / 4,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(story.url!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Icon(
                                Icons.rotate_right,
                                color: colorThird,
                              ),
                            );
                          }
                        }
                      }),
                  const SizedBox(height: 8),
                  // Message
                  Text(
                    message.message!,
                    style: medium12(colorThird),
                  ),
                ],
              ),
            ),
            // Time
            Text(
              handlingChatTime(message.time!),
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatStoryBubbleReceive extends StatelessWidget {
  const ChatStoryBubbleReceive({
    Key? key,
    required this.userId,
    required this.storyId,
    required this.message,
  }) : super(key: key);
  final String userId, storyId;
  final StoryCommentMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 1 / 3, left: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: colorThird,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story View
                  StreamBuilder<DocumentSnapshot>(
                      stream: firestoreUser
                          .doc(userId)
                          .collection('STORY')
                          .doc(storyId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              'Loading...',
                              style: medium12(colorThird),
                            ),
                          );
                        } else {
                          if (snapshot.data!.exists) {
                            // Story
                            final Story story = Story.fromMap(
                                snapshot.data!.data() as Map<String, dynamic>);

                            return Container(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 1 / 4,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(story.url!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Icon(
                                Icons.rotate_right,
                                color: colorBackground,
                              ),
                            );
                          }
                        }
                      }),
                  const SizedBox(height: 8),
                  // Message
                  Text(
                    message.message!,
                    style: medium12(colorBackground),
                  ),
                ],
              ),
            ),
            // Time
            Text(
              handlingChatTime(message.time!),
              style: medium12(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
