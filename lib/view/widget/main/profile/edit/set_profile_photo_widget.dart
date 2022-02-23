import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';

class SetProfilePhotoWidget extends StatelessWidget {
  const SetProfilePhotoWidget({
    Key? key,
    required this.userId,
    required this.username,
    required this.url,
  }) : super(key: key);
  final String? userId, username, url;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Camera
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: margin),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          onTap: () async {
            // Get Image Services Type Camera
            await FileServices.getImageFromCamera().then((file) async {
              if (file != null) {
                // Set To FIrebase Storage
                await FirebaseStorageServices.setProfile(
                  username: username!,
                  pickedFile: file,
                ).then((value) async {
                  // Update firestore data profile
                  await dataProfileServices
                      .updatePhotoProfile(userId: userId!, url: value)
                      .then((_) {
                    Navigator.pop(context);
                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: colorPrimary,
                        content: Text(
                          "Your profile is updated",
                          style: medium14(colorThird),
                        ),
                      ),
                    );
                  });
                });
              }
            });
          },
          title: Text("Camera", style: medium18(colorThird)),
          trailing: const Icon(Custom.camera, color: Colors.grey),
        ),
        // Gallery
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: margin),
          onTap: () async {
            // Get Image Services Type Gallery
            await FileServices.getImageFromGallery().then((file) async {
              if (file != null) {
                // Set To FIrebase Storage
                await FirebaseStorageServices.setProfile(
                        username: username!, pickedFile: file)
                    .then((value) async {
                  // Update firestore data profile
                  await dataProfileServices
                      .updatePhotoProfile(userId: userId!, url: value)
                      .then((_) {
                    Navigator.pop(context);
                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: colorPrimary,
                        content: Text(
                          "Your profile is updated",
                          style: medium14(colorThird),
                        ),
                      ),
                    );
                  });
                });
              }
            });
          },
          title: Text("Gallery", style: medium18(colorThird)),
          trailing: const Icon(Custom.gallery, color: Colors.grey),
        ),
        // Delete
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: margin),
          onTap: () async {
            if (url == null) {
              Navigator.pop(context);
              // Show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  backgroundColor: colorPrimary,
                  content: Text(
                    "Your profile is updated",
                    style: medium14(colorThird),
                  ),
                ),
              );
            } else {
              await FirebaseStorageServices.deleteImage(url!).then((_) async {
                // Update firestore data profile
                await dataProfileServices
                    .updatePhotoProfile(userId: userId!, url: null)
                    .then((_) {
                  Navigator.pop(context);
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: colorPrimary,
                      content: Text(
                        "Your profile is updated",
                        style: medium14(colorThird),
                      ),
                    ),
                  );
                });
              });
            }
          },
          title: Text("Delete", style: medium18(colorThird)),
          trailing: const Icon(Custom.delete, color: Colors.grey),
        ),
      ],
    );
  }
}
