import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:story_creator/story_creator.dart';

class SetStoryFileTypeWidget extends StatelessWidget {
  const SetStoryFileTypeWidget({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

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
            await FileServices.getImageFromCamera().then(
              (file) async {
                if (file != null) {
                  // Navigate
                  File? edited = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoryCreator(
                        filePath: file.path,
                      ),
                    ),
                  );

                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    if (edited != null) {
                      FirebaseStorageServices.setStory(
                        username: yourId,
                        fileName: file.name,
                        pickedFile: XFile(edited.path),
                      ).then((value) {
                        final time = DateTime.now();

                        storyServices.addStory(
                          userId: yourId,
                          url: value,
                          time:
                              "${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}",
                        );

                        Navigator.pop(context);

                        adsServices.showRewardedAd();
                      });
                    }
                  });
                }
              },
            );
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
                // Navigate
                File? edited = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StoryCreator(
                      filePath: file.path,
                    ),
                  ),
                );

                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  if (edited != null) {
                    FirebaseStorageServices.setStory(
                      username: yourId,
                      fileName: file.name,
                      pickedFile: XFile(edited.path),
                    ).then((value) {
                      final time = DateTime.now();

                      storyServices.addStory(
                        userId: yourId,
                        url: value,
                        time:
                            "${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}",
                      );

                      Navigator.pop(context);

                      adsServices.showRewardedAd();
                    });
                  }
                });
              }
            });
          },
          title: Text("Gallery", style: medium18(colorThird)),
          trailing: const Icon(Custom.gallery, color: Colors.grey),
        ),
      ],
    );
  }
}
