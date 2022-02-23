import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

Widget photoProfileUtils({
  required double size,
  required String url,
}) {
  return CircleAvatar(
    radius: size * 1 / 2,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Image.asset(
        url,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget photoProfileNetworkUtils({
  required double size,
  required String? url,
  Color? borderColor,
}) {
  return (url == null)
      ? CircleAvatar(
          minRadius: size * 1 / 2,
          maxRadius: size * 1 / 2,
          backgroundColor: Colors.black.withOpacity(0.3),
          child: Icon(
            Custom.userFill,
            color: Colors.white,
            size: size * 1 / 2,
          ),
        )
      : CircleAvatar(
          radius: size * 1 / 2,
          backgroundColor: colorBackground,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (_, image) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: colorBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (borderColor == null)
                        ? Colors.transparent
                        : borderColor,
                    width: (borderColor == null) ? 0 : 1,
                  ),
                  image: DecorationImage(image: image, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
}

Widget photoProfileLocalUtils({
  required double size,
  required Uint8List url,
}) {
  return CircleAvatar(
    radius: size * 1 / 2,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Image.memory(
        url,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget firstProfileWithStoryOrLiveUtils({
  required double size,
  required bool live,
  required bool emptyStory,
}) {
  return (live)
      ? profileLiveUtils(size: size, isLive: live)
      : firstProfileWithStoryUtils(size: size, emptyStory: emptyStory);
}

Widget firstProfileWithStoryOrLiveNetworkUtils({
  required String yourId,
  required double size,
  required bool emptyStory,
}) {
  return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.doc(yourId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return photoProfileNetworkUtils(size: size, url: null);
        } else {
          // Object
          final User user =
              User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          final DataProfile dataProfile =
              DataProfile.fromMap(user.dataProfile!);
          final LiveFromProfile live = LiveFromProfile.fromMap(user.live!);

          return (user.live!.isNotEmpty)
              ? (live.live!)
                  ? profileLiveNetworkUtils(
                      size: size, isLive: true, url: dataProfile.photo)
                  : firstProfileWithStoryNetworkUtils(
                      size: size,
                      emptyStory: emptyStory,
                      url: dataProfile.photo,
                    )
              : firstProfileWithStoryNetworkUtils(
                  size: size,
                  emptyStory: emptyStory,
                  url: dataProfile.photo,
                );
        }
      });
}

Widget secondProfileWithStoryOrLiveUtils({
  required double size,
  required bool live,
  required bool emptyStory,
  required String url,
}) {
  return (live)
      ? profileLiveUtils(size: size, isLive: true)
      : (emptyStory)
          ? photoProfileUtils(size: size, url: gambarLogin)
          : secondProfileWithStoryUtils(size: size, emptyStory: false);
}

Widget secondProfileNetworkWithStoryOrLiveUtils({
  required double size,
  required bool live,
  required bool emptyStory,
  required String? url,
}) {
  return (live)
      ? profileLiveNetworkUtils(size: size, isLive: true, url: url)
      : (emptyStory)
          ? photoProfileNetworkUtils(size: size, url: url)
          : secondProfileNetworkWithStoryUtils(
              size: size, emptyStory: emptyStory, url: url);
}

Widget firstProfileWithStoryUtils({
  required double size,
  required bool emptyStory,
}) {
  return (!emptyStory)
      ? Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorSecondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: photoProfileUtils(size: size - 4, url: gambarLogin),
        )
      : Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorPrimary),
          ),
          child: photoProfileUtils(size: size - 4, url: gambarLogin),
        );
}

Widget firstProfileWithStoryNetworkUtils({
  required double size,
  required bool emptyStory,
  required String? url,
}) {
  return (!emptyStory)
      ? Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorSecondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: photoProfileNetworkUtils(size: size - 4, url: url),
        )
      : Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
          child: photoProfileNetworkUtils(size: size - 4, url: url),
        );
}

Widget secondProfileWithStoryUtils({
  required double size,
  required bool emptyStory,
}) {
  return (!emptyStory)
      ? Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorSecondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: photoProfileUtils(size: size - 4, url: gambarLogin),
        )
      : photoProfileUtils(size: size, url: gambarLogin);
}

Widget secondProfileNetworkWithStoryUtils({
  required double size,
  required bool emptyStory,
  required String? url,
}) {
  return (!emptyStory)
      ? Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorSecondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: photoProfileNetworkUtils(size: size - 4, url: url),
        )
      : photoProfileNetworkUtils(size: size - 4, url: url);
}

Widget profileLiveUtils({required double size, required bool isLive}) {
  return (isLive)
      ? Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorSecondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              photoProfileUtils(size: size - 4, url: gambarLogin),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size / 2 - 8,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        colorPrimary,
                        colorSecondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "LIVE",
                      style: TextStyle(
                        fontSize:
                            double.parse((size * 24 / 100).toStringAsFixed(1)),
                        fontWeight: FontWeight.bold,
                        color: colorThird,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      : photoProfileUtils(size: size, url: gambarLogin);
}

Widget profileLiveNetworkUtils({
  required double size,
  required bool isLive,
  required String? url,
}) {
  return (isLive)
      ? Container(
          padding: const EdgeInsets.all(4),
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorSecondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              photoProfileNetworkUtils(size: size - 4, url: url),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size / 2 - 8,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        colorPrimary,
                        colorSecondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "LIVE",
                      style: TextStyle(
                        fontSize:
                            double.parse((size * 24 / 100).toStringAsFixed(1)),
                        fontWeight: FontWeight.bold,
                        color: colorThird,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      : photoProfileNetworkUtils(size: size, url: url);
}
