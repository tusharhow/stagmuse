import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardProfileUploadImageLiveEventWidget extends StatelessWidget {
  const CardProfileUploadImageLiveEventWidget({
    Key? key,
    required this.liveId,
    required this.index,
    required this.type,
    required this.forCover,
    required this.memory,
    required this.network,
    required this.yourId,
  }) : super(key: key);
  final ProfileLiveEventType type;
  final int index;
  final bool forCover;
  final Future<Uint8List>? memory;
  final String? network, liveId, yourId;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _liveImage = context.watch<LiveImageBloc>();
    final _state = _liveImage.state;

    return (memory == null && network == null)
        ? GestureDetector(
            onTap: () {
              // Show Modal Bottom
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                context: context,
                builder: (context) {
                  return SetUplaodPhotoLiveEventWidget(
                    url: network ?? "",
                    yourId: yourId ?? "",
                    forCover: forCover,
                    type: type,
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Custom.camera, color: colorThird),
                  const SizedBox(height: 8),
                  Text(
                    "Upload your image",
                    style: medium12(colorThird),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        : (memory != null)
            ? FutureBuilder<Uint8List>(
                future: memory,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  return Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Delete
                          GestureDetector(
                            onTap: () {
                              if (forCover) {
                                // Update bloc
                                _liveImage.add(
                                  SetLiveImage(
                                    cover: null,
                                    images: _state.images,
                                  ),
                                );
                              } else {
                                List<XFile> _list = _state.images;
                                _list.removeAt(index);

                                // Update bloc
                                _liveImage.add(
                                  SetLiveImage(
                                    cover: null,
                                    images: _state.images,
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Custom.delete,
                              size: (forCover) ? 24 : 18,
                              color: colorThird,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Edit
                          GestureDetector(
                            onTap: () {
                              // Show Modal Bottom
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return SetUplaodPhotoLiveEventWidget(
                                    url: network ?? "",
                                    yourId: yourId ?? "",
                                    forCover: forCover,
                                    type: type,
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              size: (forCover) ? 24 : 18,
                              color: colorThird,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(network!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Delete
                      GestureDetector(
                        onTap: () {
                          if (forCover) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  content: Text(
                                    "Sorry, the main photo can't be deleted only can be replaced",
                                    style: medium14(colorThird),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            );
                          } else {
                            FirebaseStorageServices.deleteImage(network!);

                            liveServices.deleteImages(
                              liveId: liveId ?? "",
                              url: network!,
                            );
                          }
                        },
                        child: Icon(
                          Custom.delete,
                          size: (forCover) ? 24 : 18,
                          color: colorThird,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Edit
                      GestureDetector(
                        onTap: () {
                          // Show Modal Bottom
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return SetUplaodPhotoLiveEventWidget(
                                url: network ?? "",
                                yourId: yourId ?? "",
                                forCover: forCover,
                                type: type,
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          size: (forCover) ? 24 : 18,
                          color: colorThird,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}

class SetUplaodPhotoLiveEventWidget extends StatelessWidget {
  const SetUplaodPhotoLiveEventWidget({
    Key? key,
    required this.url,
    required this.yourId,
    required this.forCover,
    required this.type,
  }) : super(key: key);
  final String yourId, url;
  final bool forCover;
  final ProfileLiveEventType type;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _liveImage = context.watch<LiveImageBloc>();
    final _state = _liveImage.state;

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
          onTap: () {
            // Get Image Services Type Camera
            FileServices.getImageFromCamera().then(
              (value) {
                if (value != null) {
                  Navigator.pop(context);
                  if (type == ProfileLiveEventType.create) {
                    if (forCover) {
                      // Update bloc
                      _liveImage.add(
                        SetLiveImage(
                          cover: value,
                          images: _state.images,
                        ),
                      );
                    } else {
                      List<XFile> _list = _state.images;
                      _list.add(value);

                      // Update bloc
                      _liveImage.add(
                        SetLiveImage(
                          cover: _state.cover,
                          images: _list,
                        ),
                      );
                    }
                  } else {
                    if (forCover) {
                      FirebaseStorageServices.deleteImage(url);

                      FirebaseStorageServices.setLiveCover(
                        username: yourId,
                        pickedFile: value,
                      );
                    } else {
                      FirebaseStorageServices.deleteImage(url);

                      FirebaseStorageServices.updateLiveImage(
                        username: yourId,
                        pickedFile: value,
                      );
                    }
                  }
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
          onTap: () {
            // Get Image Services Type Gallery
            FileServices.getImageFromGallery().then(
              (value) async {
                Navigator.pop(context);
                if (value != null) {
                  if (type == ProfileLiveEventType.create) {
                    if (forCover) {
                      // Update bloc
                      _liveImage.add(
                        SetLiveImage(
                          cover: value,
                          images: _state.images,
                        ),
                      );
                    } else {
                      List<XFile> _list = _state.images;
                      _list.add(value);

                      // Update bloc
                      _liveImage.add(
                        SetLiveImage(
                          cover: _state.cover,
                          images: _list,
                        ),
                      );
                    }
                  } else {
                    if (forCover) {
                      FirebaseStorageServices.deleteImage(url);

                      FirebaseStorageServices.setLiveCover(
                        username: yourId,
                        pickedFile: value,
                      );
                    } else {
                      FirebaseStorageServices.deleteImage(url);

                      FirebaseStorageServices.updateLiveImage(
                        username: yourId,
                        pickedFile: value,
                      );
                    }
                  }
                }
              },
            );
          },
          title: Text("Gallery", style: medium18(colorThird)),
          trailing: const Icon(Custom.gallery, color: Colors.grey),
        ),
      ],
    );
  }
}
