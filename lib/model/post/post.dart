import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/backend/backend_response_bloc.dart';
import 'package:stagemuse/model/backend/backend.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Object
final PostServices postServices = PostServices();

// High Level
class TextPost {
  TextPost({
    this.type,
    this.yourId,
    this.time,
    this.status,
    this.likes,
    this.totalComment,
  });

  String? type, yourId, time, status;
  int? totalComment;
  List? likes;

  // Map
  Map<String, dynamic> toMap({
    required String yourId,
    required String time,
    required String status,
    required List likes,
  }) {
    return {
      "user id": yourId,
      "type": postTypeText,
      "time": time,
      "status": status,
      "likes": likes,
      "total comment": 0.toInt(),
    };
  }

  factory TextPost.fromMap(Map<String, dynamic> data) {
    return TextPost(
      yourId: data["user id"],
      type: data['type'],
      time: data['time'],
      status: data['status'],
      likes: data['likes'],
      totalComment: data['total comment'],
    );
  }
}

class ImagePost {
  ImagePost({
    this.type,
    this.yourId,
    this.time,
    this.description,
    this.likes,
    this.images,
    this.totalComment,
  });

  String? type, yourId, time, description;
  List? likes, images;
  int? totalComment;

  // Map
  Map<String, dynamic> toMap({
    required String yourId,
    required String time,
    required String description,
    required List likes,
  }) {
    return {
      "user id": yourId,
      "type": postTypeImage,
      "time": time,
      "description": description,
      "likes": likes,
      "images": [],
      "total comment": 0.toInt(),
    };
  }

  factory ImagePost.fromMap(Map<String, dynamic> data) {
    return ImagePost(
      yourId: data["user id"],
      type: data['type'],
      time: data['time'],
      description: data['description'],
      images: data['images'],
      likes: data['likes'],
      totalComment: data['total comment'],
    );
  }
}

class CommentPost {
  CommentPost({
    this.userId,
    this.time,
    this.comment,
    this.likes,
  });

  String? userId, time, comment;
  List? likes;

  // Map
  Map<String, dynamic> toMap({
    required String userId,
    required String time,
    required String comment,
  }) {
    return {
      "user id": userId,
      "time": time,
      "comment": comment,
      "likes": [],
    };
  }

  factory CommentPost.fromMap(Map<String, dynamic> data) {
    return CommentPost(
      userId: data["user id"],
      time: data['time'],
      comment: data['comment'],
      likes: data['likes'],
    );
  }
}

// Services
class PostServices {
  // Singleton
  static final _instance = PostServices._constructor(FirebasePostServices());
  PostServices._constructor(this.manager);

  factory PostServices() {
    return _instance;
  }

  // Process
  final PostManager manager;

  // Image Post
  Future<void> addImagePost({
    required BuildContext context,
    required String yourId,
    required String description,
    required List likes,
  }) async {
    // Date Time
    final DateTime now = DateTime.now();
    final String time =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
    // Bloc
    final _bloc = context.read<BackendResponseBloc>();

    // Update Post
    await manager.addImagePost(
      onLoading: () {
        _bloc.add(
          const SetBackendResponse(
            BackEndResponse(BackEndStatus.loading),
          ),
        );
      },
      onDone: () {
        _bloc.add(
          const SetBackendResponse(
            BackEndResponse(BackEndStatus.success),
          ),
        );
      },
      onError: () {
        _bloc.add(
          const SetBackendResponse(
            BackEndResponse(BackEndStatus.error),
          ),
        );
      },
      yourId: yourId,
      time: time,
      description: description,
      likes: likes,
    );

    // Update Feed
    await feedServices.updateFeed(context: context, yourId: yourId);
  }

  Future<void> updateImagePost({
    required String yourId,
    required String url,
  }) async {
    await manager.updateImagePost(yourId: yourId, url: url);
  }

  // Text Post
  Future<void> addTextPost({
    required BuildContext context,
    required String yourId,
    required String status,
    required List likes,
  }) async {
    // Date Time
    final DateTime now = DateTime.now();
    final String time =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
    // Bloc
    final _bloc = context.read<BackendResponseBloc>();

    await manager.addTextPost(
      onLoading: () {
        _bloc.add(
          const SetBackendResponse(
            BackEndResponse(BackEndStatus.loading),
          ),
        );
      },
      onDone: () {
        _bloc.add(
          const SetBackendResponse(
            BackEndResponse(BackEndStatus.success),
          ),
        );
      },
      onError: () {
        _bloc.add(
          const SetBackendResponse(
            BackEndResponse(BackEndStatus.error),
          ),
        );
      },
      yourId: yourId,
      time: time,
      status: status,
      likes: likes,
    );

    // Update Feed
    await feedServices.updateFeed(context: context, yourId: yourId);
  }

  // Delete
  Future<void> deletePost({
    required String yourId,
    required String postId,
  }) async {
    await manager.deletePost(yourId: yourId, postId: postId);
  }

  // Like
  Future<void> likePost({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    await manager.likePost(
      yourId: yourId,
      userId: userId,
      postId: postId,
    );
  }

  Future<void> unLikePost({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    await manager.unLikePost(
      yourId: yourId,
      userId: userId,
      postId: postId,
    );
  }

  // Save
  Future<void> savePost({
    required String yourId,
    required String postId,
    required String userId,
  }) async {
    await manager.savePost(
      yourId: yourId,
      postId: postId,
      userId: userId,
    );
  }

  Future<void> unSavePost({
    required String userId,
    required String yourId,
    required String postId,
  }) async {
    await manager.unSavePost(
      yourId: yourId,
      postId: postId,
      userId: userId,
    );
  }

  // Comment
  Future<void> addComment({
    required String yourId,
    required String userId,
    required String postId,
    required String comment,
  }) async {
    await manager.addComment(
      userId: userId,
      postId: postId,
      comment: comment,
      yourId: yourId,
    );
  }

  Future<void> replyComment({
    required String yourId,
    required String userId,
    required String postId,
    required String commentId,
    required String comment,
  }) async {
    await manager.replyComment(
      userId: userId,
      postId: postId,
      commentId: commentId,
      comment: comment,
      yourId: yourId,
    );
  }

  Future<void> likeComment({
    required bool likeMainComment,
    required String yourId,
    required String postId,
    required String commentId,
    required String replyId,
    required String userId,
  }) async {
    await manager.likeComment(
      likeMainComment: likeMainComment,
      yourId: yourId,
      postId: postId,
      commentId: commentId,
      replyId: replyId,
      userId: userId,
    );
  }

  Future<void> unLikeComment({
    required bool likeMainComment,
    required String yourId,
    required String postId,
    required String commentId,
    required String replyId,
    required String userId,
  }) async {
    await manager.unLikeComment(
      likeMainComment: likeMainComment,
      yourId: yourId,
      postId: postId,
      commentId: commentId,
      replyId: replyId,
      userId: userId,
    );
  }
}

// Low Level
abstract class PostManager {
  // Image Post
  FutureOr<void> addImagePost({
    required Function onLoading,
    required Function onError,
    required Function onDone,
    required String yourId,
    required String time,
    required String description,
    required List likes,
  });
  FutureOr<void> updateImagePost({
    required String yourId,
    required String url,
  });
  // Text Post
  FutureOr<void> addTextPost({
    required Function onLoading,
    required Function onError,
    required Function onDone,
    required String yourId,
    required String time,
    required String status,
    required List likes,
  });
  // Delete
  FutureOr<void> deletePost({
    required String yourId,
    required String postId,
  });
  // Like
  FutureOr<void> likePost({
    required String yourId,
    required String userId,
    required String postId,
  });
  FutureOr<void> unLikePost({
    required String yourId,
    required String userId,
    required String postId,
  });
  // Save
  FutureOr<void> savePost({
    required String yourId,
    required String userId,
    required String postId,
  });
  FutureOr<void> unSavePost({
    required String yourId,
    required String userId,
    required String postId,
  });
  // Comment
  FutureOr<void> addComment({
    required String yourId,
    required String userId,
    required String postId,
    required String comment,
  });
  FutureOr<void> replyComment({
    required String yourId,
    required String userId,
    required String postId,
    required String commentId,
    required String comment,
  });
  FutureOr<void> likeComment({
    required bool likeMainComment,
    required String yourId,
    required String postId,
    required String commentId,
    required String replyId,
    required String userId,
  });
  FutureOr<void> unLikeComment({
    required bool likeMainComment,
    required String yourId,
    required String postId,
    required String commentId,
    required String replyId,
    required String userId,
  });
}

class FirebasePostServices implements PostManager {
  // Singleton'
  static final _instance = FirebasePostServices._constructor();
  FirebasePostServices._constructor();

  factory FirebasePostServices() {
    return _instance;
  }

  // Process
  final ImagePost image = ImagePost();
  final TextPost text = TextPost();
  final CommentPost commentPost = CommentPost();

  // Image
  @override
  Future<void> addImagePost({
    required Function onLoading,
    required Function onError,
    required Function onDone,
    required String yourId,
    required String time,
    required String description,
    required List likes,
  }) async {
    onLoading.call();

    await firestoreUser
        .doc(yourId)
        .collection('POST')
        .add(
          image.toMap(
            yourId: yourId,
            time: time,
            description: description,
            likes: likes,
          ),
        )
        .catchError((e) {
      debugPrint(e);

      onError.call();
    }).whenComplete(() => onDone.call());
  }

  @override
  Future<void> updateImagePost({
    required String yourId,
    required String url,
  }) async {
    firestoreUser.doc(yourId).collection('POST').get().then((query) {
      final postId = query.docs[query.docs.length - 1].id;

      firestoreUser.doc(yourId).collection('POST').doc(postId).update({
        "images": FieldValue.arrayUnion([url]),
      });
    });
  }

  // Text
  @override
  Future<void> addTextPost({
    required Function onLoading,
    required Function onError,
    required Function onDone,
    required String yourId,
    required String time,
    required String status,
    required List likes,
  }) async {
    onLoading.call();

    await firestoreUser
        .doc(yourId)
        .collection('POST')
        .add(
          text.toMap(
            yourId: yourId,
            time: time,
            status: status,
            likes: likes,
          ),
        )
        .catchError((e) {
      debugPrint(e);

      onError.call();
    }).whenComplete(() => onDone.call());
  }

  // Delete
  @override
  Future<void> deletePost({
    required String yourId,
    required String postId,
  }) async {
    firestoreUser.doc(yourId).collection('POST').doc(postId).get().then(
      (doc) {
        // Map
        final map = doc.data() as Map<String, dynamic>;

        if (map['type'] == postTypeImage) {
          // Object
          final ImagePost image = ImagePost.fromMap(map);

          for (String url in image.images!) {
            // Delete
            FirebaseStorageServices.deleteImage(url);
          }
        }
      },
    );
    firestoreUser.doc(yourId).collection('POST').doc(postId).delete();

    // Delete Feed
    firestoreFeed.doc(yourId).get().then(
      (doc) {
        // Object
        final feed = doc.data() as Map<String, dynamic>;

        if (feed['post id'] == postId) {
          feedServices.deleteFeed(yourId);
        }
      },
    );
  }

  // Like
  @override
  Future<void> likePost({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    // For Post
    await firestoreUser.doc(userId).collection('POST').doc(postId).update(
      {
        "likes": FieldValue.arrayUnion([yourId]),
      },
    );
    // For You
    await firestoreUser.doc(yourId).update(
      {
        "liked posts": FieldValue.arrayUnion([
          {
            'post id': postId,
            "user id": userId,
          }
        ]),
      },
    );
  }

  @override
  Future<void> unLikePost({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    // For Post
    await firestoreUser.doc(userId).collection('POST').doc(postId).update(
      {
        "likes": FieldValue.arrayRemove([yourId]),
      },
    );
    // For You
    await firestoreUser.doc(yourId).update(
      {
        "liked posts": FieldValue.arrayRemove([
          {
            'post id': postId,
            "user id": userId,
          }
        ]),
      },
    );
  }

  // Save
  @override
  Future<void> savePost({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    await firestoreUser.doc(yourId).update(
      {
        "save post": FieldValue.arrayUnion([
          {
            'post id': postId,
            "user id": userId,
          }
        ]),
      },
    );
  }

  @override
  Future<void> unSavePost({
    required String yourId,
    required String userId,
    required String postId,
  }) async {
    await firestoreUser.doc(yourId).update(
      {
        "save post": FieldValue.arrayRemove([
          {
            'post id': postId,
            "user id": userId,
          }
        ]),
      },
    );
  }

  @override
  Future<void> addComment({
    required String yourId,
    required String userId,
    required String postId,
    required String comment,
  }) async {
    // Date Time
    final DateTime now = DateTime.now();
    final String time =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";

    await firestoreUser
        .doc(userId)
        .collection('POST')
        .doc(postId)
        .collection('COMMENT')
        .add(
          commentPost.toMap(
            userId: yourId,
            time: time,
            comment: comment,
          ),
        );

    await firestoreUser.doc(userId).collection('POST').doc(postId).get().then(
      (doc) {
        if (doc.exists) {
          final map = doc.data() as Map<String, dynamic>;

          firestoreUser.doc(userId).collection('POST').doc(postId).update(
            {
              "total comment": map['total comment'] + 1,
            },
          );
        }
      },
    );
  }

  @override
  Future<void> replyComment({
    required String yourId,
    required String userId,
    required String postId,
    required String commentId,
    required String comment,
  }) async {
    // Date Time
    final DateTime now = DateTime.now();
    final String time =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";

    await firestoreUser
        .doc(userId)
        .collection('POST')
        .doc(postId)
        .collection('COMMENT')
        .doc(commentId)
        .collection('REPLY')
        .add(
          commentPost.toMap(
            userId: yourId,
            time: time,
            comment: comment,
          ),
        );

    await firestoreUser.doc(userId).collection('POST').doc(postId).get().then(
      (doc) {
        final map = doc.data() as Map<String, dynamic>;

        firestoreUser.doc(userId).collection('POST').doc(postId).update(
          {
            "total comment": map['total comment'] + 1,
          },
        );
      },
    );
  }

  @override
  Future<void> likeComment({
    required bool likeMainComment,
    required String yourId,
    required String postId,
    required String commentId,
    required String replyId,
    required String userId,
  }) async {
    if (likeMainComment) {
      await firestoreUser
          .doc(userId)
          .collection('POST')
          .doc(postId)
          .collection('COMMENT')
          .doc(commentId)
          .update(
        {
          "likes": FieldValue.arrayUnion([yourId])
        },
      );
    } else {
      await firestoreUser
          .doc(userId)
          .collection('POST')
          .doc(postId)
          .collection('COMMENT')
          .doc(commentId)
          .collection('REPLY')
          .doc(replyId)
          .update(
        {
          "likes": FieldValue.arrayUnion([yourId])
        },
      );
    }
  }

  @override
  Future<void> unLikeComment({
    required bool likeMainComment,
    required String yourId,
    required String postId,
    required String commentId,
    required String replyId,
    required String userId,
  }) async {
    if (likeMainComment) {
      await firestoreUser
          .doc(userId)
          .collection('POST')
          .doc(postId)
          .collection('COMMENT')
          .doc(commentId)
          .update(
        {
          "likes": FieldValue.arrayRemove([yourId])
        },
      );
    } else {
      await firestoreUser
          .doc(userId)
          .collection('POST')
          .doc(postId)
          .collection('COMMENT')
          .doc(commentId)
          .collection('REPLY')
          .doc(replyId)
          .update(
        {
          "likes": FieldValue.arrayRemove([yourId])
        },
      );
    }
  }
}
