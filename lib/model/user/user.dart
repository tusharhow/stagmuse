import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/backend/backend_utils.dart';

// Create Object
final UserServices userServices = UserServices();

// High Level
class User {
  User({
    this.privateAccount,
    this.dataProfile,
    this.live,
    this.followRequest,
    this.followers,
    this.following,
    this.savePost,
    this.tag,
    this.likedPost,
    this.block,
  });

  bool? privateAccount;
  List? followers, following, savePost, tag, likedPost, block, followRequest;
  Map<String, dynamic>? dataProfile, live;

  // Map
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      privateAccount: data["private account"],
      dataProfile: data["data profile"],
      // live: data["live"],
      followers: data["followers"],
      following: data["following"],
      followRequest: data["follow request"],
      savePost: data["save post"],
      tag: data["tag"],
      likedPost: data["liked posts"],
      block: data["block"],
    );
  }
}

// Services
class UserServices {
  // Singleton
  static final _instance = UserServices._constructor(FirebaseUserServices());
  UserServices._constructor(this.manager);

  factory UserServices() {
    return _instance;
  }

  // Process
  final UserManager manager;

  Future<void> block({
    required String userId,
    required String yourId,
  }) async {
    await firestoreUser.doc(yourId).get().then((doc) {
      // Object
      final User user = User.fromMap(doc.data() as Map<String, dynamic>);

      if (user.privateAccount!) {
        firestoreUser
            .doc(userId)
            .collection("NOTIFICATION")
            .where("type", isEqualTo: notificationTypeFollowPermission)
            .get()
            .then((query) {
          if (query.docs.isNotEmpty) {
            for (DocumentSnapshot doc in query.docs) {
              if (doc.id == yourId) {
                deleteRequestFollow(
                  deleteSingleNotif: true,
                  yourId: yourId,
                  userId: userId,
                );
                deleteFollowers(yourId: yourId, userId: userId);
                deleteFollowers(yourId: userId, userId: yourId);

                deleteFollowing(yourId: yourId, userId: userId);
                deleteFollowing(yourId: userId, userId: yourId);
                return;
              } else {
                deleteFollowers(yourId: yourId, userId: userId);
                deleteFollowers(yourId: userId, userId: yourId);

                deleteFollowing(yourId: yourId, userId: userId);
                deleteFollowing(yourId: userId, userId: yourId);
                return;
              }
            }
          } else {
            deleteFollowers(yourId: yourId, userId: userId);
            deleteFollowers(yourId: userId, userId: yourId);

            deleteFollowing(yourId: yourId, userId: userId);
            deleteFollowing(yourId: userId, userId: yourId);
            return;
          }
        });
      } else {
        deleteFollowers(yourId: yourId, userId: userId);
        deleteFollowers(yourId: userId, userId: yourId);

        deleteFollowing(yourId: yourId, userId: userId);
        deleteFollowing(yourId: userId, userId: yourId);
        return;
      }
    });

    firestoreUser
        .doc(yourId)
        .collection("NOTIFICATION")
        .where("user id", isEqualTo: userId)
        .get()
        .then((query) {
      if (query.docs.isNotEmpty) {
        for (DocumentSnapshot doc in query.docs) {
          notificationServices.deleteSingleNotif(
            userId: yourId,
            notifId: doc.id,
          );

          deleteFollowers(yourId: yourId, userId: userId);
          deleteFollowers(yourId: userId, userId: yourId);

          deleteFollowing(yourId: yourId, userId: userId);
          deleteFollowing(yourId: userId, userId: yourId);
          return;
        }
      } else {
        deleteFollowers(yourId: yourId, userId: userId);
        deleteFollowers(yourId: userId, userId: yourId);

        deleteFollowing(yourId: yourId, userId: userId);
        deleteFollowing(yourId: userId, userId: yourId);
        return;
      }
    });
  }

  Future<void> follback({
    required String userId,
    required String yourId,
  }) async {
    // For You
    await addFollowing(yourId: yourId, userId: userId);
    // For User
    await addFollowers(yourId: userId, userId: yourId);
    await notificationServices.addFollowNotif(yourId: userId, userId: yourId);
  }

  Future<void> unFoll({
    required String? notifId,
    required String userId,
    required String yourId,
  }) async {
    if (notifId != null) {
      notificationServices.updateFollowNotifPermission(
        userId: yourId,
        notifId: notifId,
        giveAccess: false,
      );

      await deleteFollowing(yourId: yourId, userId: userId);
      await deleteFollowers(yourId: userId, userId: yourId);
      return;
    } else {
      await deleteFollowing(yourId: yourId, userId: userId);
      await deleteFollowers(yourId: userId, userId: yourId);
      return;
    }
  }

  Future<void> accept({
    required String yourId,
    required String userId,
  }) async {
    firestoreUser
        .doc(yourId)
        .collection("NOTIFICATION")
        .where("type", isEqualTo: notificationTypeFollowPermission)
        .get()
        .then((query) {
      for (DocumentSnapshot doc in query.docs) {
        notificationServices.updateFollowNotifPermission(
          userId: yourId,
          notifId: doc.id,
          giveAccess: true,
        );
        // For You
        addFollowers(yourId: yourId, userId: userId);
        // For User
        addFollowing(yourId: userId, userId: yourId);
        deleteRequestFollow(
          deleteSingleNotif: false,
          yourId: userId,
          userId: yourId,
        );
      }
    });
  }

  // Block
  Future<void> addBloc({
    required String yourId,
    required String userId,
  }) async {
    await manager.addBloc(yourId: yourId, userId: userId);
  }

  Future<void> deleteBloc({
    required String yourId,
    required String userId,
  }) async {
    await manager.deleteBloc(yourId: yourId, userId: userId);
  }

  // Request Follow
  Future<void> addRequestFollow({
    required String yourId,
    required String userId,
  }) async {
    await manager.addRequestFollow(yourId: yourId, userId: userId);
  }

  Future<void> deleteRequestFollow({
    required bool deleteSingleNotif,
    required String yourId,
    required String userId,
  }) async {
    await manager.deleteRequestFollow(
      yourId: yourId,
      userId: userId,
      deleteSingleNotif: deleteSingleNotif,
    );
  }

  // Followers
  Future<void> addFollowers({
    required String yourId,
    required String userId,
  }) async {
    await manager.addFollowers(yourId: yourId, userId: userId);
  }

  Future<void> deleteFollowers({
    required String yourId,
    required String userId,
  }) async {
    await manager.deleteFollowers(yourId: yourId, userId: userId);
  }

  // Following
  Future<void> addFollowing({
    required String yourId,
    required String userId,
  }) async {
    await manager.addFollowing(yourId: yourId, userId: userId);
  }

  Future<void> deleteFollowing({
    required String yourId,
    required String userId,
  }) async {
    await manager.deleteFollowing(yourId: yourId, userId: userId);
  }

  // Liked Post
  Future<void> addLikedPost({
    required String postId,
    required String userId,
  }) async {
    await manager.addLikedPost(postId: postId, userId: userId);
  }

  Future<void> deleteLikedPost({
    required String postId,
    required String userId,
  }) async {
    await manager.deleteLikedPost(postId: postId, userId: userId);
  }

  // Save Post
  Future<void> addSavePost({
    required String yourId,
    required String postId,
  }) async {
    await manager.addSavePost(yourId: yourId, postId: postId);
  }

  Future<void> deleteSavePost({
    required String yourId,
    required String postId,
  }) async {
    await manager.deleteSavePost(yourId: yourId, postId: postId);
  }

  // Tag
  Future<void> addTag({
    required String postId,
    required String userId,
  }) async {
    await manager.addTag(postId: postId, userId: userId);
  }

  Future<void> deleteTag({
    required String postId,
    required String userId,
  }) async {
    await manager.deleteTag(postId: postId, userId: userId);
  }

  // Live
  Future<void> udpateLiveStatus({
    required String userId,
    required bool live,
  }) async {
    await manager.udpateLiveStatus(userId: userId, live: live);
  }

  // By You
  Future<void> addLiveByYou({
    required String liveId,
    required String userId,
  }) async {
    await manager.addLiveByYou(liveId: liveId, userId: userId);
  }

  Future<void> deleteLiveByYou({
    required String liveId,
    required String userId,
  }) async {
    await manager.deleteLiveByYou(liveId: liveId, userId: userId);
  }

  // Follow
  Future<void> addLiveFollow({
    required String liveId,
    required String userId,
  }) async {
    await manager.addLiveFollow(liveId: liveId, userId: userId);
  }

  Future<void> deleteLiveFollow({
    required String liveId,
    required String userId,
  }) async {
    await manager.deleteLiveFollow(liveId: liveId, userId: userId);
  }
}

// Low Level
abstract class UserManager {
  // Block
  FutureOr<void> addBloc({
    required String yourId,
    required String userId,
  });
  FutureOr<void> deleteBloc({
    required String yourId,
    required String userId,
  });

  // Request Follow
  FutureOr<void> addRequestFollow({
    required String yourId,
    required String userId,
  });

  FutureOr<void> deleteRequestFollow({
    required bool deleteSingleNotif,
    required String yourId,
    required String userId,
  });

  // Followers
  FutureOr<void> addFollowers({
    required String yourId,
    required String userId,
  });
  FutureOr<void> deleteFollowers({
    required String yourId,
    required String userId,
  });

  // Following
  FutureOr<void> addFollowing({
    required String yourId,
    required String userId,
  });
  FutureOr<void> deleteFollowing({
    required String yourId,
    required String userId,
  });

  // Liked Post
  FutureOr<void> addLikedPost({
    required String postId,
    required String userId,
  });
  FutureOr<void> deleteLikedPost({
    required String postId,
    required String userId,
  });

  // Save Post
  FutureOr<void> addSavePost({
    required String yourId,
    required String postId,
  });
  FutureOr<void> deleteSavePost({
    required String yourId,
    required String postId,
  });

  // Tag
  FutureOr<void> addTag({
    required String postId,
    required String userId,
  });
  FutureOr<void> deleteTag({
    required String postId,
    required String userId,
  });

  // Live
  FutureOr<void> udpateLiveStatus({
    required String userId,
    required bool live,
  });
  // By You
  FutureOr<void> addLiveByYou({
    required String liveId,
    required String userId,
  });
  FutureOr<void> deleteLiveByYou({
    required String liveId,
    required String userId,
  });
  // Follow
  FutureOr<void> addLiveFollow({
    required String liveId,
    required String userId,
  });
  FutureOr<void> deleteLiveFollow({
    required String liveId,
    required String userId,
  });
}

class FirebaseUserServices implements UserManager {
  // Singleton
  static final _instance = FirebaseUserServices._constructor();
  FirebaseUserServices._constructor();

  factory FirebaseUserServices() {
    return _instance;
  }

  // Process
  // Bloc
  @override
  Future<void> addBloc({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "block": FieldValue.arrayUnion([userId])
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteBloc({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "block": FieldValue.arrayRemove([userId])
      },
      SetOptions(merge: true),
    );
  }

  // Request Follow
  @override
  Future<void> addRequestFollow({
    required String yourId,
    required String userId,
  }) async {
    firestoreUser.doc(userId).get().then((doc) async {
      // Object
      final User user = User.fromMap(doc.data() as Map<String, dynamic>);

      if (user.privateAccount!) {
        await firestoreUser.doc(yourId).set(
          {
            "follow request": FieldValue.arrayUnion([userId])
          },
          SetOptions(merge: true),
        );

        notificationServices.addFollowNotifPermission(
          yourId: yourId,
          userId: userId,
        );
        return;
      } else {
        // For You
        addFollowing(yourId: yourId, userId: userId);
        // For User
        addFollowers(yourId: userId, userId: yourId);
        notificationServices.addFollowNotif(yourId: yourId, userId: userId);
        return;
      }
    });
  }

  @override
  Future<void> deleteRequestFollow({
    required bool deleteSingleNotif,
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "follow request": FieldValue.arrayRemove([userId])
      },
      SetOptions(merge: true),
    );

    if (deleteSingleNotif) {
      firestoreUser
          .doc(userId)
          .collection("NOTIFICATION")
          .where("user id", isEqualTo: yourId)
          .get()
          .then((query) async {
        if (query.docs.isNotEmpty) {
          for (DocumentSnapshot doc in query.docs) {
            // Object
            final map = doc.data() as Map<String, dynamic>;

            if (map["type"] == notificationTypeFollowPermission &&
                map["user id"] == yourId) {
              notificationServices.deleteSingleNotif(
                userId: userId,
                notifId: doc.id,
              );

              return;
            }
          }
        }
      });
    }
  }

  // Followers
  @override
  FutureOr<void> addFollowers({
    required String yourId,
    required String userId,
  }) async {
    firestoreUser.doc(userId).get().then((doc) async {
      // Object
      final User user = User.fromMap(doc.data() as Map<String, dynamic>);
      final DataProfile dataProfile = DataProfile.fromMap(user.dataProfile!);

      await firestoreUser.doc(yourId).set(
        {
          "followers": FieldValue.arrayUnion([userId])
        },
        SetOptions(merge: true),
      );

      // Send
      notificationMessagingServices.sendNotification(
        title: 'Stagemuse',
        subject: "@${dataProfile.username} start following you",
        topics: "notif$userId",
      );
    });
  }

  @override
  Future<void> deleteFollowers({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "followers": FieldValue.arrayRemove([userId])
      },
      SetOptions(merge: true),
    );
  }

  // Following
  @override
  Future<void> addFollowing({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "following": FieldValue.arrayUnion([userId])
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteFollowing({
    required String yourId,
    required String userId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "following": FieldValue.arrayRemove([userId])
      },
      SetOptions(merge: true),
    );
  }

  // Lke
  @override
  Future<void> addLikedPost({
    required String postId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "liked posts": FieldValue.arrayUnion([postId])
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteLikedPost({
    required String postId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "liked posts": FieldValue.arrayRemove([postId])
      },
      SetOptions(merge: true),
    );
  }

  // Save
  @override
  Future<void> addSavePost({
    required String yourId,
    required String postId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "save post": FieldValue.arrayUnion([postId])
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteSavePost({
    required String yourId,
    required String postId,
  }) async {
    await firestoreUser.doc(yourId).set(
      {
        "save post": FieldValue.arrayRemove([postId])
      },
      SetOptions(merge: true),
    );
  }

  // Tag
  @override
  Future<void> addTag({
    required String postId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "tag": FieldValue.arrayUnion([postId])
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteTag({
    required String postId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "tag": FieldValue.arrayRemove([postId])
      },
      SetOptions(merge: true),
    );
  }

  // Live
  // By You
  @override
  Future<void> addLiveByYou({
    required String liveId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "live": {
          "provided by you": FieldValue.arrayUnion([liveId])
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteLiveByYou({
    required String liveId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "live": {
          "provided by you": FieldValue.arrayRemove([liveId])
        }
      },
      SetOptions(merge: true),
    );
  }

  // Follow
  @override
  Future<void> addLiveFollow({
    required String liveId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "live": {
          "you follow": FieldValue.arrayUnion([liveId])
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteLiveFollow({
    required String liveId,
    required String userId,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "live": {
          "you follow": FieldValue.arrayRemove([liveId])
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> udpateLiveStatus({
    required String userId,
    required bool live,
  }) async {
    await firestoreUser.doc(userId).update(
      {
        "live": {
          "live": live,
        }
      },
    );
  }
}
