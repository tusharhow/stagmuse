import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/backend/backend_utils.dart';

class FileServices {
  // Image
  static Future<XFile?> getImageFromGallery() async {
    var _pick = await ImagePicker().pickImage(source: ImageSource.gallery);

    return _pick;
  }

  static Future<XFile?> getImageFromCamera() async {
    var _camera = await ImagePicker().pickImage(source: ImageSource.camera);

    return _camera;
  }

  // Video
  static getVideoFromGallery() async {
    var _pick = await ImagePicker().pickVideo(source: ImageSource.gallery);

    return _pick;
  }

  static getVideoFromCamera() async {
    var _camera = await ImagePicker().pickVideo(source: ImageSource.camera);

    return _camera;
  }
}

class FirebaseStorageServices {
  static Future<String> setProfile({
    required String username,
    required XFile pickedFile,
  }) async {
    File file = File(pickedFile.path);
    // Upload to firebase storage
    var storageReference = firebaseStorage.ref("profile/$username");
    var upload = await storageReference.putFile(file);
    var url = await upload.ref.getDownloadURL();

    return url;
  }

  static Future<String> setStory({
    required String username,
    required String fileName,
    required XFile pickedFile,
  }) async {
    File file = File(pickedFile.path);
    // Upload to firebase storage
    var storageReference = firebaseStorage.ref("story/$username/$fileName");
    var upload = await storageReference.putFile(file);
    var url = await upload.ref.getDownloadURL();

    return url;
  }

  static Future<void> deleteImage(String url) async {
    await firebaseStorage.refFromURL(url).delete();
  }

  static Future<String> setChat({
    required String username,
    required String fileName,
    required XFile pickedFile,
  }) async {
    File file = File(pickedFile.path);
    // Upload to firebase storage
    var storageReference = firebaseStorage.ref("chat/$username/$fileName");
    var upload = await storageReference.putFile(file);
    var url = await upload.ref.getDownloadURL();

    return url;
  }

  static Future<void> setPostImage({
    required String username,
    required List<PostFile> pickedFile,
  }) async {
    for (int i = 0; i < pickedFile.length; i++) {
      XFile pickFile = pickedFile[i].file;
      File file = File(pickFile.path);
      // Upload to firebase storage
      var storageReference = firebaseStorage.ref("post/$username/${file.path}");
      var upload = await storageReference.putFile(file);
      var url = await upload.ref.getDownloadURL();

      // Update Post Image
      postServices.updateImagePost(yourId: username, url: url);
    }
  }

  static Future<void> setLiveImage({
    required String username,
    required List<XFile> pickedFile,
  }) async {
    for (int i = 0; i < pickedFile.length; i++) {
      XFile pickFile = pickedFile[i];
      File file = File(pickFile.path);
      // Upload to firebase storage
      var storageReference = firebaseStorage.ref("live/$username/${file.path}");
      var upload = await storageReference.putFile(file);
      var url = await upload.ref.getDownloadURL();

      // Update Live Image
      liveServices.udpateImages(yourId: username, url: url);
    }
  }

  static Future<void> setLiveCover({
    required String username,
    required XFile pickedFile,
  }) async {
    File file = File(pickedFile.path);
    // Upload to firebase storage
    var storageReference =
        firebaseStorage.ref("live/$username/${pickedFile.name}");
    var upload = await storageReference.putFile(file);
    var url = await upload.ref.getDownloadURL();

    // Update Cover Image
    liveServices.udpateCover(yourId: username, cover: url);
  }

  static Future<void> updateLiveImage({
    required String username,
    required XFile pickedFile,
  }) async {
    File file = File(pickedFile.path);
    // Upload to firebase storage
    var storageReference =
        firebaseStorage.ref("live/$username/${pickedFile.name}");
    var upload = await storageReference.putFile(file);
    var url = await upload.ref.getDownloadURL();

    // Update Live Image
    liveServices.udpateImages(yourId: username, url: url);
  }
}
