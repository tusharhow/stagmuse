import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';

// Object
final NotificationServices notificationServices = NotificationServices();

// High Level
class FollowNotifPermission {
  FollowNotifPermission({
    this.type,
    this.userId,
    this.giveAccess,
    this.read,
  });

  String? type, userId;
  bool? giveAccess, read;

  // Map
  Map<String, dynamic> toMap(String userId) {
    return {
      "type": notificationTypeFollowPermission,
      "user id": userId,
      "give access": false,
      "read": false,
    };
  }

  factory FollowNotifPermission.fromMap(Map<String, dynamic> data) {
    return FollowNotifPermission(
      type: data["type"],
      userId: data["user id"],
      giveAccess: data["give access"],
      read: data["read"],
    );
  }
}

class FollowNotif {
  FollowNotif({this.type, this.userId, this.read});

  String? type, userId;
  bool? read;

  // Map
  Map<String, dynamic> toMap(String userId) {
    return {
      "type": notificationTypeFollow,
      "user id": userId,
      "read": false,
    };
  }

  factory FollowNotif.fromMap(Map<String, dynamic> data) {
    return FollowNotif(
      type: data["type"],
      userId: data["user id"],
      read: data["read"],
    );
  }
}

class LikeNotif {
  LikeNotif({this.type, this.userId, this.read, this.postId});

  String? type, userId, postId;
  bool? read;

  // Map
  Map<String, dynamic> toMap({
    required String userId,
    required String postId,
  }) {
    return {
      "type": notificationTypeLike,
      "user id": userId,
      "read": false,
      "post id": postId,
    };
  }

  factory LikeNotif.fromMap(Map<String, dynamic> data) {
    return LikeNotif(
      type: data["type"],
      userId: data["user id"],
      read: data["read"],
      postId: data['post id'],
    );
  }
}

class LiveNotif {
  LiveNotif({this.type, this.liveId, this.read});

  String? type, liveId;
  bool? read;

  // Map
  Map<String, dynamic> toMap(String userId) {
    return {
      "type": notificationTypeLive,
      "user id": userId,
      "read": false,
    };
  }

  factory LiveNotif.fromMap(Map<String, dynamic> data) {
    return LiveNotif(
      type: data["type"],
      liveId: data["live id"],
      read: data["read"],
    );
  }
}

// Services
class NotificationServices {
  // Singleton
  static final _instance =
      NotificationServices._constructor(FirebaseNotificationServices());
  NotificationServices._constructor(this.manager);

  factory NotificationServices() {
    return _instance;
  }

  // Process
  final NotificationManager manager;

  Future<void> checkTotalUnreadNotif({
    required String yourId,
    required Function(int) setTotal,
  }) async {
    firestoreUser
        .doc(yourId)
        .collection("NOTIFICATION")
        .where("read", isEqualTo: false)
        .snapshots()
        .listen((query) {
      setTotal.call(query.docs.length);
    });
  }

  Future<void> addFollowNotifPermission({
    required String yourId,
    required String userId,
  }) async {
    await manager.addFollowNotifPermission(yourId: yourId, userId: userId);
  }

  Future<void> updateFollowNotifPermission({
    required String userId,
    required String notifId,
    required bool giveAccess,
  }) async {
    await manager.updateFollowNotifPermission(
      userId: userId,
      notifId: notifId,
      giveAccess: giveAccess,
    );
  }

  Future<void> updateReadNotif({
    required String userId,
    required String notifId,
  }) async {
    await manager.updateReadNotif(
      userId: userId,
      notifId: notifId,
    );
  }

  Future<void> addFollowNotif({
    required String yourId,
    required String userId,
  }) async {
    await manager.addFollowNotif(
      yourId: yourId,
      userId: userId,
    );
  }

  Future<void> addLikeNotif({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    await manager.addLikeNotif(
      yourId: yourId,
      userId: userId,
      postId: postId,
    );
  }

  Future<void> addLiveNotif({
    required String yourId,
    required String userId,
  }) async {
    await manager.addLiveNotif(
      yourId: yourId,
      userId: userId,
    );
  }

  // Delete
  Future<void> deleteSingleNotif({
    required String userId,
    required String notifId,
  }) async {
    await manager.deleteSingleNotif(userId: userId, notifId: notifId);
  }

  Future<void> deleteAllNotif({
    required String userId,
    required String notifId,
  }) async {
    await manager.deleteAllNotif(userId: userId, notifId: notifId);
  }
}

// Low Level
abstract class NotificationManager {
  // Add || Update
  FutureOr<void> addFollowNotifPermission({
    required String yourId,
    required String userId,
  });
  FutureOr<void> updateFollowNotifPermission({
    required String userId,
    required String notifId,
    required bool giveAccess,
  });
  FutureOr<void> updateReadNotif({
    required String userId,
    required String notifId,
  });
  FutureOr<void> addFollowNotif({
    required String yourId,
    required String userId,
  });
  FutureOr<void> addLikeNotif({
    required String yourId,
    required String userId,
    required String postId,
  });
  FutureOr<void> addLiveNotif({
    required String yourId,
    required String userId,
  });

  // Delete
  FutureOr<void> deleteSingleNotif({
    required String userId,
    required String notifId,
  });
  FutureOr<void> deleteAllNotif({
    required String userId,
    required String notifId,
  });
}

class FirebaseNotificationServices extends NotificationManager {
  // Singleton
  static final _instance = FirebaseNotificationServices._constructor();
  FirebaseNotificationServices._constructor();

  factory FirebaseNotificationServices() {
    return _instance;
  }

  // Process
  final FollowNotifPermission followPermission = FollowNotifPermission();
  final FollowNotif follow = FollowNotif();
  final LikeNotif like = LikeNotif();
  final LiveNotif live = LiveNotif();

  @override
  Future<void> addFollowNotifPermission({
    required String yourId,
    required String userId,
  }) async {
    firestoreUser.doc(yourId).get().then((doc) async {
      // Object
      final User user = User.fromMap(doc.data() as Map<String, dynamic>);
      final DataProfile dataProfile = DataProfile.fromMap(user.dataProfile!);

      await firestoreUser.doc(userId).collection("NOTIFICATION").add(
            followPermission.toMap(yourId),
          );

      // Send
      notificationMessagingServices.sendNotification(
        title: 'Stagemuse',
        subject: "@${dataProfile.username} asking to follow you",
        topics: "notif$userId",
      );
    });
  }

  @override
  Future<void> updateFollowNotifPermission({
    required String userId,
    required String notifId,
    required bool giveAccess,
  }) async {
    await firestoreUser.doc(userId).collection("NOTIFICATION").doc(notifId).set(
      {
        "give access": giveAccess,
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> addFollowNotif({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).collection("NOTIFICATION").add(
          follow.toMap(userId),
        );
  }

  @override
  Future<void> addLikeNotif({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    await firestoreUser.doc(yourId).collection("NOTIFICATION").add(
          like.toMap(
            userId: userId,
            postId: postId,
          ),
        );
  }

  @override
  Future<void> addLiveNotif({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).collection("NOTIFICATION").add(
          live.toMap(userId),
        );
  }

  @override
  Future<void> deleteSingleNotif({
    required String userId,
    required String notifId,
  }) async {
    await firestoreUser
        .doc(userId)
        .collection("NOTIFICATION")
        .doc(notifId)
        .delete();
  }

  @override
  Future<void> deleteAllNotif({
    required String userId,
    required String notifId,
  }) async {
    await firestoreUser
        .doc(userId)
        .collection("NOTIFICATION")
        .get()
        .then((query) {
      for (DocumentSnapshot doc in query.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<void> updateReadNotif({
    required String userId,
    required String notifId,
  }) async {
    await firestoreUser
        .doc(userId)
        .collection("NOTIFICATION")
        .doc(notifId)
        .update({
      "read": true,
    });
  }
}
