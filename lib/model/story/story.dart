import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/backend/backend_utils.dart';
import 'package:stagemuse/view/export_view.dart';

// Object
final StoryServices storyServices = StoryServices();

// High Level
class Story {
  Story({
    this.url,
    this.time,
    this.views,
    this.youSee,
  });

  String? url, time;
  List? views;
  bool? youSee;

  // Map
  Map<String, dynamic> toMap({
    required String url,
    required String time,
  }) {
    return {
      "url": url,
      "time": time,
      "views": [],
      "you see": false,
    };
  }

  factory Story.fromMap(Map<String, dynamic> data) {
    return Story(
      url: data['url'],
      time: data['time'],
      views: data['views'],
      youSee: data["you see"],
    );
  }
}

class StoryViewers {
  StoryViewers({this.userId, this.time});

  String? userId, time;

  // Map
  Map<String, dynamic> toMap({
    required String userId,
    required String time,
  }) {
    return {
      "user id": userId,
      "time": time,
    };
  }

  factory StoryViewers.fromMap(Map<String, dynamic> data) {
    return StoryViewers(
      userId: data["user id"],
      time: data["time"],
    );
  }
}

class StoryServices {
  // Singleton
  static final _instance = StoryServices._constructor(FirebaseStoryServices());
  StoryServices._constructor(this.manager);

  factory StoryServices() {
    return _instance;
  }

  // Process
  final StoryManager manager;

  Future<void> deleteStoryControler(String userId) async {
    firestoreUser.doc(userId).collection("STORY").snapshots().listen(
      (query) {
        for (DocumentSnapshot doc in query.docs) {
          // Object
          final Story story = Story.fromMap(doc.data() as Map<String, dynamic>);
          final DateTime convert =
              DateFormat('yyyy-MM-dd HH:mm').parse(story.time!);
          final DateTime _limit = DateFormat('yyyy-MM-dd HH:mm').parse(
              "${convert.year}-${convert.month}-${convert.day + 1} ${convert.hour}:${convert.minute}");

          if (DateTime.now().compareTo(_limit) > 0) {
            // Delete
            deleteStory(userId: userId, storyId: doc.id);
          }
        }
      },
    );
  }

  Future<void> nextViewers({
    required String userId,
    required String yourId,
    required String storyId,
  }) async {
    firestoreUser.doc(userId).collection('STORY').get().then((query) {
      for (DocumentSnapshot doc in query.docs) {
        final Story story = Story.fromMap(
          doc.data() as Map<String, dynamic>,
        );
        // Use last query
        final Story storyLast = Story.fromMap(
          query.docs[query.docs.length - 1].data(),
        );

        if (story.views!
                .where((element) => element["user id"] == yourId)
                .isNotEmpty &&
            storyLast.views!
                .where((element) => element["user id"] == yourId)
                .isEmpty) {
          storyController.next();
          storyController.pause();
          storyController.play();
        }
      }
    });
  }

  Future<void> checkStoryControl({
    required bool own,
    required String yourId,
    required String? userId,
    required Function empty,
    required Function youSee,
    required Function youNotSee,
    required Function notEmpty,
  }) async {
    firestoreUser
        .doc((own) ? yourId : userId)
        .collection('STORY')
        .snapshots()
        .listen((query) {
      if (query.docs.isNotEmpty) {
        notEmpty.call();
        return;
      } else {
        empty.call();
        return;
      }
    });

    firestoreUser
        .doc((own) ? yourId : userId)
        .collection('STORY')
        .snapshots()
        .listen((query) {
      if (query.docs.isNotEmpty) {
        // Use last query
        final Story storyLast = Story.fromMap(query.docs.last.data());

        if (own) {
          if (!storyLast.youSee!) {
            youNotSee.call();
            return;
          } else {
            youSee.call();
            return;
          }
        } else {
          if (storyLast.views!.isNotEmpty) {
            if (storyLast.views!
                .where((element) => element["user id"] == yourId)
                .isNotEmpty) {
              youSee.call();
              return;
            } else {
              youNotSee.call();

              return;
            }
          } else {
            youNotSee.call();
            return;
          }
        }
      } else {
        youSee.call();
        return;
      }
    });
  }

  Future<void> addStory({
    required String userId,
    required String url,
    required String time,
  }) async {
    await manager.addStory(
      userId: userId,
      url: url,
      time: time,
    );
  }

  Future<void> udpateSeeStory({
    required String userId,
    required String storyId,
  }) async {
    await manager.udpateSeeStory(userId: userId, storyId: storyId);
  }

  Future<void> deleteStory({
    required String userId,
    required String storyId,
  }) async {
    firestoreUser
        .doc(userId)
        .collection('STORY')
        .doc(storyId)
        .get()
        .then((doc) async {
      if (doc.exists) {
        // Object
        final Story story = Story.fromMap(doc.data() as Map<String, dynamic>);

        await FirebaseStorageServices.deleteImage(story.url!).whenComplete(() {
          manager.deleteStory(userId: userId, storyId: storyId);
        });
      }
    });
  }

  Future<void> udpateStoryViewer({
    required String userId,
    required String yourId,
    required String storyId,
  }) async {
    await manager.udpateStoryViewer(
      userId: userId,
      storyId: storyId,
      yourId: yourId,
    );
  }
}

// Low Level
abstract class StoryManager {
  FutureOr<void> addStory({
    required String userId,
    required String url,
    required String time,
  });
  FutureOr<void> deleteStory({
    required String userId,
    required String storyId,
  });
  FutureOr<void> udpateSeeStory({
    required String userId,
    required String storyId,
  });
  FutureOr<void> udpateStoryViewer({
    required String yourId,
    required String userId,
    required String storyId,
  });
}

class FirebaseStoryServices implements StoryManager {
  // Singleton
  static final _instance = FirebaseStoryServices._constructor();
  FirebaseStoryServices._constructor();

  factory FirebaseStoryServices() {
    return _instance;
  }

  // Process
  final Story story = Story();
  final StoryViewers view = StoryViewers();

  @override
  Future<void> addStory({
    required String userId,
    required String url,
    required String time,
  }) async {
    await firestoreUser.doc(userId).collection("STORY").add(
          story.toMap(url: url, time: time),
        );
  }

  @override
  Future<void> deleteStory({
    required String userId,
    required String storyId,
  }) async {
    await firestoreUser.doc(userId).collection("STORY").doc(storyId).delete();
  }

  @override
  Future<void> udpateSeeStory({
    required String userId,
    required String storyId,
  }) async {
    await firestoreUser.doc(userId).collection("STORY").doc(storyId).update({
      "you see": true,
    });
  }

  @override
  Future<void> udpateStoryViewer({
    required String userId,
    required String yourId,
    required String storyId,
  }) async {
    final DateTime time = DateTime.now();

    await firestoreUser.doc(userId).collection("STORY").doc(storyId).update(
      {
        "views": FieldValue.arrayUnion([
          view.toMap(
              userId: yourId,
              time:
                  "${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}")
        ]),
      },
    );
  }
}
