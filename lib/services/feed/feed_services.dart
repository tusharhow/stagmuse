import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/backend/backend_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Object
final FeedServices feedServices = FeedServices();

// High Level
class Feed {
  Feed({
    this.postId,
    this.time,
  });

  String? postId, time;

  // Map
  Map<String, dynamic> toMap({
    required String postId,
    required String time,
  }) {
    return {
      "post id": postId,
      "time": time,
    };
  }

  factory Feed.fromMap(Map<String, dynamic> data) {
    return Feed(postId: data['post id'], time: data['time']);
  }
}

// Services
class FeedServices {
  // Singleton
  static final _instance = FeedServices._constructor(FirebaseFeedServices());
  FeedServices._constructor(this.manager);

  factory FeedServices() {
    return _instance;
  }

  // Process
  final FeedManager manager;

  Future<void> updateFeed({
    required BuildContext context,
    required String yourId,
  }) async {
    // Bloc
    final _bloc = context.read<BackendResponseBloc>();

    await manager.updateFeed(
      yourId: yourId,
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
    );
  }

  Future<void> deleteFeed(String feedId) async {
    await manager.deleteFeed(feedId);
  }
}

// Low Level
abstract class FeedManager {
  FutureOr<void> updateFeed({
    required Function onLoading,
    required Function onError,
    required Function onDone,
    required String yourId,
  });

  FutureOr<void> deleteFeed(String feedId);
}

class FirebaseFeedServices implements FeedManager {
  // Singleton
  static final _instance = FirebaseFeedServices._constructor();
  FirebaseFeedServices._constructor();

  factory FirebaseFeedServices() {
    return _instance;
  }

  // Process
  final Feed feed = Feed();

  @override
  Future<void> updateFeed({
    required String yourId,
    required Function onLoading,
    required Function onError,
    required Function onDone,
  }) async {
    onLoading.call();
    firestoreUser.doc(yourId).collection('POST').orderBy('time').get().then(
      (query) async {
        if (query.docs.isNotEmpty) {
          final Map map = query.docs.last.data();

          // Update feed
          await firestoreFeed
              .doc(yourId)
              .set(
                feed.toMap(
                  postId: query.docs.last.id,
                  time: map['time'],
                ),
                SetOptions(merge: true),
              )
              .catchError((e) {
            debugPrint(e);

            onError.call();
          }).whenComplete(() => onDone.call());
        }
      },
    );
  }

  @override
  Future<void> deleteFeed(String feedId) async {
    await firestoreFeed.doc(feedId).delete();
  }
}
