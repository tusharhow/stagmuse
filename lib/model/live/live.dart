import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';

// Object
final LiveServices liveServices = LiveServices();

// High Level
class LiveExample {
  LiveExample({
    required this.name,
    required this.time,
    required this.date,
    required this.status,
    required this.description,
    required this.provider,
    required this.cover,
    required this.images,
    required this.followers,
  });

  String? name, time, date, status, description, provider;
  List? images, followers;
  XFile? cover;
}

class Live {
  Live({
    this.name,
    this.time,
    this.date,
    this.status,
    this.description,
    this.provider,
    this.cover,
    this.images,
    this.followers,
  });

  String? name, time, date, status, description, provider, cover;
  List? images, followers;

  // Map
  Map<String, dynamic> toMap({
    required String name,
    required String time,
    required String date,
    required String description,
    required String provider,
  }) {
    return {
      "name": name,
      "time": time,
      "date": date,
      "status": liveStatusSoon,
      "description": description,
      "provider": provider,
      "cover": null,
      "images": [],
      "followers": [],
    };
  }

  factory Live.fromMap(Map<String, dynamic> data) {
    return Live(
      date: data['date'],
      description: data['description'],
      followers: data['followers'],
      name: data['name'],
      provider: data['provider'],
      status: data['status'],
      time: data['time'],
      cover: data['cover'],
      images: data['images'],
    );
  }
}

// Services
class LiveServices {
  // Singleton
  static final _instance = LiveServices._constructor(FirebaseLiveServices());
  LiveServices._constructor(this.manager);

  factory LiveServices() {
    return _instance;
  }

  // Process
  final LiveManager manager;

  Future<void> addLive({
    required Function onLoading,
    required Function onSuccess,
    required String yourId,
    required String name,
    required String time,
    required String date,
    required String description,
    required String provider,
  }) async {
    onLoading.call();
    // For Live
    await manager.addLive(
      yourId: yourId,
      name: name,
      time: time,
      date: date,
      description: description,
      provider: provider,
    );

    // For You
    firestoreLive
        .where('provider', isEqualTo: yourId)
        .orderBy('date')
        .snapshots()
        .listen(
      (query) {
        // Update For You
        userServices.addLiveByYou(
          liveId: query.docs[query.docs.length - 1].id,
          userId: yourId,
        );

        // Update Search
        searchDatabaseServices.addLive(query.docs[query.docs.length - 1].id);
      },
    );

    onSuccess.call();
  }

  Future<void> updateLive({
    required Function loading,
    required Function success,
    required String liveId,
    required String name,
    required String time,
    required String date,
    required String description,
  }) async {
    loading.call();

    manager.updateLive(
      liveId: liveId,
      name: name,
      time: time,
      date: date,
      description: description,
    );

    success.call();
  }

  Future<void> deleteLive(String liveId) async {
    firestoreLive.doc(liveId).get().then(
      (doc) {
        // Object
        final Live live = Live.fromMap(doc.data() as Map<String, dynamic>);

        // Delete Cover
        FirebaseStorageServices.deleteImage(live.cover!);

        if (live.images!.isNotEmpty) {
          for (String url in live.images!) {
            // Delete Image
            FirebaseStorageServices.deleteImage(url);
          }
        }
      },
    );

    manager.deleteLive(liveId);
  }

  Future<void> updateLiveStatus(String userId) async {
    firestoreLive.where('provider', isEqualTo: userId).snapshots().listen(
      (query) {
        for (DocumentSnapshot doc in query.docs) {
          // Convert
          final DateTime convert = DateFormat('yyyy-MM-dd').parse(doc['date']);

          if (DateTime.now().compareTo(convert) >= 0) {
            udpateStatus(liveId: doc.id, status: liveStatusExpired);
          }
        }
      },
    );
  }

  Future<void> udpateStatus({
    required String liveId,
    required String status,
  }) async {
    await manager.udpateStatus(liveId: liveId, status: status);
  }

  Future<void> udpateCover({
    required String yourId,
    required String? cover,
  }) async {
    firestoreLive
        .where('provider', isEqualTo: yourId)
        .orderBy('date')
        .snapshots()
        .listen(
      (query) {
        manager.udpateCover(
          liveId: query.docs[query.docs.length - 1].id,
          cover: cover,
        );
      },
    );
  }

  Future<void> udpateImages({
    required String yourId,
    required String url,
  }) async {
    firestoreLive
        .where('provider', isEqualTo: yourId)
        .orderBy('date')
        .snapshots()
        .listen(
      (query) {
        manager.udpateImages(
          liveId: query.docs[query.docs.length - 1].id,
          url: url,
        );
      },
    );
  }

  Future<void> deleteImages({
    required String liveId,
    required String url,
  }) async {
    await manager.deleteImages(liveId: liveId, url: url);
  }

  Future<void> addLiveFollowers({
    required String liveId,
    required String yourId,
  }) async {
    // For Live
    await manager.addLiveFollowers(liveId: liveId, yourId: yourId);

    // For you
    await userServices.addLiveFollow(liveId: liveId, userId: yourId);
  }

  Future<void> deleteLiveFollowers({
    required String liveId,
    required String yourId,
  }) async {
    // For Live
    await manager.deleteLiveFollowers(liveId: liveId, yourId: yourId);

    // For User
    await userServices.deleteLiveFollow(liveId: liveId, userId: yourId);
  }
}

abstract class LiveManager {
  FutureOr<void> addLive({
    required String yourId,
    required String name,
    required String time,
    required String date,
    required String description,
    required String provider,
  });
  FutureOr<void> updateLive({
    required String liveId,
    required String name,
    required String time,
    required String date,
    required String description,
  });
  FutureOr<void> deleteLive(String liveId);
  FutureOr<void> udpateStatus({
    required String liveId,
    required String status,
  });
  FutureOr<void> udpateCover({
    required String liveId,
    required String? cover,
  });
  FutureOr<void> udpateImages({
    required String liveId,
    required String url,
  });
  FutureOr<void> deleteImages({
    required String liveId,
    required String url,
  });
  FutureOr<void> addLiveFollowers({
    required String liveId,
    required String yourId,
  });
  FutureOr<void> deleteLiveFollowers({
    required String liveId,
    required String yourId,
  });
}

class FirebaseLiveServices implements LiveManager {
  // Singleton
  static final _instance = FirebaseLiveServices._constructor();
  FirebaseLiveServices._constructor();

  factory FirebaseLiveServices() {
    return _instance;
  }

  // Process
  final Live live = Live();

  @override
  Future<void> addLive({
    required String yourId,
    required String name,
    required String time,
    required String date,
    required String description,
    required String provider,
  }) async {
    await firestoreLive.add(
      live.toMap(
        name: name,
        time: time,
        date: date,
        description: description,
        provider: provider,
      ),
    );
  }

  @override
  Future<void> deleteLive(
    String liveId,
  ) async {
    await firestoreLive.doc(liveId).delete();
  }

  @override
  Future<void> udpateCover({
    required String liveId,
    required String? cover,
  }) async {
    await firestoreLive.doc(liveId).update({
      'cover': cover,
    });
  }

  @override
  Future<void> udpateImages({
    required String liveId,
    required String url,
  }) async {
    await firestoreLive.doc(liveId).update({
      'images': FieldValue.arrayUnion([url]),
    });
  }

  @override
  FutureOr<void> udpateStatus({
    required String liveId,
    required String status,
  }) async {
    await firestoreLive.doc(liveId).update({
      'status': status,
    });
  }

  @override
  Future<void> deleteImages({
    required String liveId,
    required String url,
  }) async {
    await firestoreLive.doc(liveId).update({
      'images': FieldValue.arrayRemove([url]),
    });
  }

  @override
  Future<void> addLiveFollowers({
    required String liveId,
    required String yourId,
  }) async {
    await firestoreLive.doc(liveId).update({
      'followers': FieldValue.arrayUnion([yourId]),
    });
  }

  @override
  Future<void> deleteLiveFollowers({
    required String liveId,
    required String yourId,
  }) async {
    await firestoreLive.doc(liveId).update({
      'followers': FieldValue.arrayRemove([yourId]),
    });
  }

  @override
  Future<void> updateLive({
    required String liveId,
    required String name,
    required String time,
    required String date,
    required String description,
  }) async {
    await firestoreLive.doc(liveId).update({
      "name": name,
      "time": time,
      "date": date,
      "description": description,
    });
  }
}
