import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

// Object
final DataProfileServices dataProfileServices = DataProfileServices();

class DataProfile {
  DataProfile({
    this.username,
    this.name,
    this.photo,
    this.bio,
    this.birthdate,
    this.email,
    this.phoneNumber,
  });

  String? phoneNumber, username, name, photo, bio, birthdate, email;

  // Map
  Map<String, dynamic> editabelToMap({
    required String? photo,
    required String username,
    required String name,
    required String? bio,
    required String birthdate,
    required String email,
    required String phoneNumber,
  }) {
    return {
      "photo": photo,
      "user name": username,
      "name": name,
      "bio": bio,
      "birthdate": birthdate,
      "email": email,
      "phone number": phoneNumber,
    };
  }

  factory DataProfile.fromMap(Map<String, dynamic> data) {
    return DataProfile(
        username: data["user name"],
        name: data["name"],
        photo: data["photo"],
        bio: data["bio"],
        birthdate: data["birthdate"],
        email: data["email"],
        phoneNumber: data["phone number"]);
  }
}

class DataProfileServices {
  // Singleton
  static final _instance =
      DataProfileServices.constructor(FirestoreDataProfileServices());
  DataProfileServices.constructor(this.manager);

  factory DataProfileServices() {
    return _instance;
  }

  // Process
  final DataProfileManager manager;

  Future<void> addUser({
    required String userId,
    required String? photo,
    required String username,
    required String name,
    required String? bio,
    required String birthdate,
    required String email,
    required String phoneNumber,
  }) async {
    await manager.addUser(
      userId: userId,
      photo: photo,
      username: username,
      name: name,
      bio: bio,
      birthdate: birthdate,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> updateDataProfile({
    required String userId,
    required String username,
    required String name,
    required String? bio,
    required bool isPrivateAccount,
  }) async {
    await manager.updateDataProfile(
      userId: userId,
      username: username,
      name: name,
      bio: bio,
      isPrivateAccount: isPrivateAccount,
    );
  }

  Future<void> updatePhotoProfile({
    required String userId,
    required String? url,
  }) async {
    await manager.updatePhotoProfile(userId: userId, url: url);
  }

  Future<void> checkUsername({
    required String username,
    required Function onValid,
    required Function onInValid,
    required Function updateBlocLoading,
    required Function updateBlocSuccess,
    required Function updateBlocError,
  }) async {
    await manager.checkUsername(
      username: username,
      onValid: onValid,
      onInValid: onInValid,
      updateBlocLoading: updateBlocLoading,
      updateBlocSuccess: updateBlocSuccess,
      updateBlocError: updateBlocError,
    );
  }
}

// Low Level
abstract class DataProfileManager {
  FutureOr<void> addUser({
    required String userId,
    required String? photo,
    required String username,
    required String name,
    required String? bio,
    required String birthdate,
    required String email,
    required String phoneNumber,
  });

  FutureOr<void> updateDataProfile({
    required String userId,
    required String username,
    required String name,
    required String? bio,
    required bool isPrivateAccount,
  });

  FutureOr<void> updatePhotoProfile({
    required String userId,
    required String? url,
  });

  FutureOr<void> checkUsername({
    required String username,
    required Function onValid,
    required Function onInValid,
    required Function updateBlocLoading,
    required Function updateBlocSuccess,
    required Function updateBlocError,
  });
}

class FirestoreDataProfileServices extends DataProfileManager {
  // Singleton
  static final _instance = FirestoreDataProfileServices._constructor();
  FirestoreDataProfileServices._constructor();

  factory FirestoreDataProfileServices() {
    return _instance;
  }

  // Process
  final DataProfile dataProfile = DataProfile();

  @override
  Future<void> addUser({
    required String userId,
    required String? photo,
    required String username,
    required String name,
    required String? bio,
    required String birthdate,
    required String email,
    required String phoneNumber,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "private account": false,
        "data profile": dataProfile.editabelToMap(
          photo: photo,
          username: username,
          name: name,
          bio: bio,
          birthdate: birthdate,
          email: email,
          phoneNumber: phoneNumber,
        ),
        "live": {
          "live": false,
          "provided by you": [],
          "you follow": [],
        },
        "followers": [],
        "following": [],
        "follow request": [],
        "save post": [],
        "tag": [],
        "liked posts": [],
        "block": [],
      },
    );
  }

  @override
  Future<void> updateDataProfile({
    required String userId,
    required String username,
    required String name,
    required String? bio,
    required bool isPrivateAccount,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "private account": isPrivateAccount,
        "data profile": {
          "user name": username,
          "name": name,
          "bio": bio,
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> checkUsername({
    required String username,
    required Function onValid,
    required Function onInValid,
    required Function updateBlocLoading,
    required Function updateBlocSuccess,
    required Function updateBlocError,
  }) async {
    // Update Bloc
    updateBlocLoading.call();
    // Check user name
    await firestoreUser.get().then((query) {
      if (query.docs.isNotEmpty) {
        // Do Looping
        for (DocumentSnapshot doc in query.docs) {
          // Object
          final User user = User.fromMap(doc.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);

          // Check User name
          if (dataProfile.username == username) {
            // Update Bloc
            updateBlocError.call();
            // On Invalid
            onInValid.call();

            return;
          } else {
            // Update Bloc
            updateBlocSuccess.call();
            // On Valid
            onValid.call();
            return;
          }
        }
      } else {
        // Update Bloc
        updateBlocSuccess.call();
        // On Valid
        onValid.call();
        return;
      }
    });
  }

  @override
  Future<void> updatePhotoProfile({
    required String userId,
    required String? url,
  }) async {
    await firestoreUser.doc(userId).set(
      {
        "data profile": {
          "photo": url,
        },
      },
      SetOptions(merge: true),
    );
  }
}
