import 'dart:async';
import 'package:stagemuse/utils/backend/backend_utils.dart';

// Object
// Database
final SearchDatabaseServices searchDatabaseServices = SearchDatabaseServices();

// High level
// Model
class SearchAllModelAccount {
  SearchAllModelAccount({this.userId, this.type});

  String? userId, type;

  // Map
  Map<String, dynamic> accountToMap(
    String userId,
  ) {
    return {"user id": userId, "type": searchTypeAccount};
  }

  factory SearchAllModelAccount.fromMap(Map<String, dynamic> data) {
    return SearchAllModelAccount(
      userId: data["user id"],
      type: data["type"],
    );
  }
}

class SearchAllModelLive {
  SearchAllModelLive({this.liveId, this.type});

  String? liveId, type;

  // Map
  Map<String, dynamic> liveToMap(
    String liveId,
  ) {
    return {"live id": liveId, "type": searchTypeLive};
  }

  factory SearchAllModelLive.fromMap(Map<String, dynamic> data) {
    return SearchAllModelLive(
      liveId: data["live id"],
      type: data["type"],
    );
  }
}

// Method
// Database
class SearchDatabaseServices {
  // Singleton
  static final _instance =
      SearchDatabaseServices._constructor(FirebaseSearchServices());
  SearchDatabaseServices._constructor(this.searchManager);

  factory SearchDatabaseServices() {
    return _instance;
  }

  // Process
  final SearchManager searchManager;

  Future<void> addAccount(String userId) async {
    await searchManager.addAccount(userId);
  }

  Future<void> addLive(String liveId) async {
    await searchManager.addLive(liveId);
  }

  Future<void> deleteLive(String id) async {
    await searchManager.deleteLive(id);
  }
}

// Low Level
abstract class SearchManager {
  FutureOr<void> addAccount(String userId);
  FutureOr<void> addLive(String liveId);
  FutureOr<void> deleteLive(String id);
}

class FirebaseSearchServices extends SearchManager {
  // Singleton
  static final _instance = FirebaseSearchServices._constructor();
  FirebaseSearchServices._constructor();

  factory FirebaseSearchServices() {
    return _instance;
  }

  // Process
  final SearchAllModelAccount account = SearchAllModelAccount();
  final SearchAllModelLive live = SearchAllModelLive();

  @override
  Future<void> addAccount(String userId) async {
    await firestoreAll.add(account.accountToMap(userId));
  }

  @override
  Future<void> addLive(String liveId) async {
    await firestoreAll.add(live.liveToMap(liveId));
  }

  @override
  Future<void> deleteLive(String id) async {
    await firestoreAll.doc(id).delete();
  }
}
