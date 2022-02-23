import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/backend/backend_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Object
final ChatServices chatServices = ChatServices();

// High Level
class TextMessage {
  TextMessage({
    this.message,
    this.time,
    this.type,
    this.from,
  });

  String? message, time, type, from;

  // Map
  Map<String, dynamic> toMap({
    required String message,
    required String from,
    required String time,
  }) {
    return {
      "message": message,
      "time": time,
      "type": chatTypeText,
      "from": from,
    };
  }

  factory TextMessage.fromMap(Map<String, dynamic> data) {
    return TextMessage(
      from: data["from"],
      message: data['message'],
      type: data['type'],
      time: data['time'],
    );
  }
}

class ImageMessage {
  ImageMessage({
    this.url,
    this.time,
    this.type,
    this.from,
  });

  String? url, time, type, from;

  // Map
  Map<String, dynamic> toMap({
    required String url,
    required String from,
    required String time,
  }) {
    return {
      "url": url,
      "time": time,
      "type": chatTypeImage,
      "from": from,
    };
  }

  factory ImageMessage.fromMap(Map<String, dynamic> data) {
    return ImageMessage(
      from: data["from"],
      url: data['url'],
      type: data['type'],
      time: data['time'],
    );
  }
}

class StoryCommentMessage {
  StoryCommentMessage({
    this.storyId,
    this.message,
    this.time,
    this.type,
    this.from,
  });

  String? storyId, message, time, type, from;

  // Map
  Map<String, dynamic> toMap({
    required String storyId,
    required String message,
    required String from,
    required String time,
  }) {
    return {
      "message": message,
      "time": time,
      "type": chatTypeStory,
      "from": from,
      "story id": storyId,
    };
  }

  factory StoryCommentMessage.fromMap(Map<String, dynamic> data) {
    return StoryCommentMessage(
      from: data["from"],
      message: data['message'],
      type: data['type'],
      time: data['time'],
      storyId: data['story id'],
    );
  }
}

// Services
class ChatServices {
  // Singleton
  static final _instance = ChatServices._constructor(FirebaseChatServices());
  ChatServices._constructor(this.manager);

  factory ChatServices() {
    return _instance;
  }

  // Process
  final ChatManager manager;

  Future<void> addChat({
    required BuildContext context,
    required bool fromCamera,
    required String yourId,
    required String userId,
    required String chatType,
    required String? message,
    required String from,
  }) async {
    final DateTime now = DateTime.now();
    final String newId = DateFormat('yyyy-MM-dd').format(now);

    // Notification
    firestoreUser.doc(userId).get().then(
      (doc) {
        // Object
        final User user = User.fromMap(doc.data() as Map<String, dynamic>);
        final DataProfile dataProfile = DataProfile.fromMap(user.dataProfile!);

        if (chatType == chatTypeText) {
          // To you
          sendTextChat(
            yourId: yourId,
            userId: userId,
            dateChatId: newId,
            message: message!,
            from: from,
            time: DateFormat('yyyy-MM-dd HH:mm').format(now),
          );
          // To user
          sendTextChat(
            yourId: userId,
            userId: yourId,
            dateChatId: newId,
            message: message,
            from: from,
            time: DateFormat('yyyy-MM-dd HH:mm').format(now),
          );

          // Send
          notificationMessagingServices.sendNotification(
            title: 'Stagemuse',
            subject: "@${dataProfile.username} $message",
            topics: "chat$userId",
          );
        } else if (chatType == chatTypeStory) {
          // Bloc
          final _storyId = context.read<StoryControllBloc>();

          // To you
          sendStoryCommentChat(
            yourId: yourId,
            userId: userId,
            dateChatId: newId,
            message: message!,
            storyId: _storyId.state.storyId!,
            from: from,
            time: DateFormat('yyyy-MM-dd HH:mm').format(now),
          );

          // To user
          sendStoryCommentChat(
            yourId: userId,
            userId: yourId,
            dateChatId: newId,
            message: message,
            storyId: _storyId.state.storyId!,
            from: from,
            time: DateFormat('yyyy-MM-dd HH:mm').format(now),
          );

          // Send
          notificationMessagingServices.sendNotification(
            title: 'Stagemuse',
            subject: "@${dataProfile.username} $message",
            topics: "chat$userId",
          );
        } else {
          sendImageChat(
            fromCamera: fromCamera,
            yourId: yourId,
            userId: userId,
            dateChatId: newId,
            from: from,
            time: DateFormat('yyyy-MM-dd HH:mm').format(now),
          );

          // Send
          notificationMessagingServices.sendNotification(
            title: 'Stagemuse',
            subject: "@${dataProfile.username} send photo",
            topics: "chat$userId",
          );
        }
      },
    );
  }

  Future<void> deleteChatAt({
    required String yourId,
    required String userId,
  }) async {
    await manager.deleteChatAt(yourId: yourId, userId: userId);
  }

  Future<void> sendTextChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String message,
    required String from,
    required String time,
  }) async {
    await manager.sendTextChat(
      yourId: yourId,
      userId: userId,
      dateChatId: dateChatId,
      message: message,
      from: from,
      time: time,
    );
  }

  Future<void> sendImageChat({
    required bool fromCamera,
    required String yourId,
    required String userId,
    required String dateChatId,
    required String from,
    required String time,
  }) async {
    if (fromCamera) {
      await FileServices.getImageFromCamera().then((file) {
        if (file != null) {
          // To You
          FirebaseStorageServices.setChat(
            username: yourId,
            fileName: file.path,
            pickedFile: file,
          ).then((url) {
            manager.sendImageChat(
              yourId: yourId,
              userId: userId,
              dateChatId: dateChatId,
              url: url,
              from: from,
              time: time,
            );
          });
          // To User
          FirebaseStorageServices.setChat(
            username: userId,
            fileName: file.path,
            pickedFile: file,
          ).then((url) {
            manager.sendImageChat(
              yourId: userId,
              userId: yourId,
              dateChatId: dateChatId,
              url: url,
              from: from,
              time: time,
            );
          });
        }
      });
    } else {
      await FileServices.getImageFromGallery().then((file) {
        if (file != null) {
          // To You
          FirebaseStorageServices.setChat(
            username: yourId,
            fileName: file.path,
            pickedFile: file,
          ).then((url) {
            manager.sendImageChat(
              yourId: yourId,
              userId: userId,
              dateChatId: dateChatId,
              url: url,
              from: from,
              time: time,
            );
          });
          // To User
          FirebaseStorageServices.setChat(
            username: userId,
            fileName: file.path,
            pickedFile: file,
          ).then((url) {
            manager.sendImageChat(
              yourId: userId,
              userId: yourId,
              dateChatId: dateChatId,
              url: url,
              from: from,
              time: time,
            );
          });
        }
      });
    }
  }

  Future<void> udpdateReadChat({
    required String yourId,
    required String userId,
    required String dateChatId,
  }) async {
    await manager.udpdateReadChat(
      yourId: yourId,
      userId: userId,
      dateChatId: dateChatId,
    );
  }

  Future<void> sendStoryCommentChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String message,
    required String storyId,
    required String from,
    required String time,
  }) async {
    await manager.sendStoryCommentChat(
      yourId: yourId,
      userId: userId,
      dateChatId: dateChatId,
      message: message,
      storyId: storyId,
      from: from,
      time: time,
    );
  }
}

// Low Level
abstract class ChatManager {
  FutureOr<void> deleteChatAt({
    required String yourId,
    required String userId,
  });
  FutureOr<void> sendTextChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String message,
    required String from,
    required String time,
  });
  FutureOr<void> sendImageChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String url,
    required String from,
    required String time,
  });
  FutureOr<void> sendStoryCommentChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String message,
    required String storyId,
    required String from,
    required String time,
  });
  FutureOr<void> udpdateReadChat({
    required String yourId,
    required String userId,
    required String dateChatId,
  });
}

class FirebaseChatServices implements ChatManager {
  // Singleton
  static final _instance = FirebaseChatServices._constructor();
  FirebaseChatServices._constructor();

  factory FirebaseChatServices() {
    return _instance;
  }

  // Process
  final TextMessage textMessage = TextMessage();
  final ImageMessage imageMessage = ImageMessage();
  final StoryCommentMessage commentMessage = StoryCommentMessage();

  @override
  Future<void> deleteChatAt({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser
        .doc(yourId)
        .collection('CHAT')
        .doc(userId)
        .collection('MESSAGES')
        .get()
        .then((query) {
      for (DocumentSnapshot doc1 in query.docs) {
        firestoreUser
            .doc(yourId)
            .collection('CHAT')
            .doc(userId)
            .collection('MESSAGES')
            .doc(doc1.id)
            .get()
            .then((doc) {
          final map = doc.data() as Map<String, dynamic>;

          for (Map<String, dynamic> chat in map['Chats']) {
            if (chat['type'] == chatTypeImage) {
              FirebaseStorageServices.deleteImage(chat['url']);
            }
          }
          doc1.reference.delete();
        });
      }
    });

    firestoreUser.doc(yourId).collection('CHAT').doc(userId).delete();
  }

  @override
  Future<void> sendImageChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String url,
    required String from,
    required String time,
  }) async {
    await firestoreUser.doc(yourId).collection('CHAT').doc(userId).set({
      "user id": userId,
      "read": false,
    }, SetOptions(merge: true)).then((_) {
      firestoreUser
          .doc(yourId)
          .collection('CHAT')
          .doc(userId)
          .collection('MESSAGES')
          .doc(dateChatId)
          .set({
        "read": false,
        "Chats": FieldValue.arrayUnion(
          [
            imageMessage.toMap(
              url: url,
              from: from,
              time: time,
            ),
          ],
        ),
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> sendTextChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String message,
    required String from,
    required String time,
  }) async {
    await firestoreUser.doc(yourId).collection('CHAT').doc(userId).set({
      "user id": userId,
      "read": false,
    }, SetOptions(merge: true)).then((_) {
      firestoreUser
          .doc(yourId)
          .collection('CHAT')
          .doc(userId)
          .collection('MESSAGES')
          .doc(dateChatId)
          .set({
        "Chats": FieldValue.arrayUnion(
          [
            textMessage.toMap(
              message: message,
              from: from,
              time: time,
            ),
          ],
        ),
      }, SetOptions(merge: true));
    });
  }

  @override
  Future<void> udpdateReadChat({
    required String yourId,
    required String userId,
    required String dateChatId,
  }) async {
    await firestoreUser.doc(yourId).collection('CHAT').doc(userId).set({
      'user id': userId,
      "read": true,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> sendStoryCommentChat({
    required String yourId,
    required String userId,
    required String dateChatId,
    required String message,
    required String storyId,
    required String from,
    required String time,
  }) async {
    await firestoreUser.doc(yourId).collection('CHAT').doc(userId).set({
      "user id": userId,
      "read": false,
    }, SetOptions(merge: true)).then((_) {
      firestoreUser
          .doc(yourId)
          .collection('CHAT')
          .doc(userId)
          .collection('MESSAGES')
          .doc(dateChatId)
          .set({
        "Chats": FieldValue.arrayUnion(
          [
            commentMessage.toMap(
              storyId: storyId,
              message: message,
              from: from,
              time: time,
            ),
          ],
        ),
      }, SetOptions(merge: true));
    });
  }
}
