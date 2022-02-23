import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';

class FileCreatePostWidget extends StatelessWidget {
  const FileCreatePostWidget({
    Key? key,
    this.height,
    required this.forMainFilePost,
  }) : super(key: key);
  final double? height;
  final bool forMainFilePost;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _postFileBloc = context.watch<PostFileBloc>();

    return SizedBox(
      width: double.infinity,
      height: (height == null)
          ? MediaQuery.of(context).size.height * 1 / 2
          : height,
      child: (_postFileBloc.state.files.isEmpty)
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: margin),
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(0.3),
              child: BlocSelector<PostTypeBloc, PostTypeValue, PostType>(
                selector: (state) {
                  return state.type;
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (state == PostType.gallery)
                            ? Custom.gallery
                            : Custom.camera,
                        size: 36,
                        color: colorThird,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (state == PostType.gallery)
                            ? "From gallery"
                            : "From camera",
                        style: regular14(colorThird),
                      ),
                    ],
                  );
                },
              ),
            )
          : CarouselSlider.builder(
              slideBuilder: (index) {
                return (_postFileBloc.state.files[index].type == postTypeImage)
                    ? Column(
                        children: [
                          // View
                          Expanded(
                            child: FutureBuilder<Uint8List>(
                              future: _postFileBloc.state.files[index].url,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      "Loading...",
                                      style: medium14(colorThird),
                                    ),
                                  );
                                }
                                return Image.memory(
                                  snapshot.data!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          // Delete
                          (!forMainFilePost)
                              ? flatTextButton(
                                  onPress: () {
                                    List<PostFile> files =
                                        _postFileBloc.state.files;
                                    files.removeAt(index);

                                    _postFileBloc.add(SetPostFile(files));
                                  },
                                  text: "Delete",
                                  textColor: colorPrimary,
                                  buttonColor: colorThird,
                                  leftMargin: 0,
                                  rightMargin: 0,
                                  topMargin: 0,
                                  bottomMargin: 16,
                                  width: double.infinity,
                                  height: 48,
                                  radius: 0,
                                )
                              : Container(),
                        ],
                      )
                    : Container();
              },
              slideIndicator: CircularSlideIndicator(
                padding: EdgeInsets.only(bottom: (forMainFilePost) ? 8 : 0),
                currentIndicatorColor: colorPrimary,
                indicatorBackgroundColor: colorPrimary.withOpacity(0.2),
                indicatorRadius: 5,
                itemSpacing: 12,
              ),
              itemCount: _postFileBloc.state.files.length,
            ),
    );
  }
}

class SetTypePostFileWidget extends StatelessWidget {
  const SetTypePostFileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _postTypeBloc = context.read<PostTypeBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: margin),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          onTap: () async {
            switch (_postTypeBloc.state.type) {
              case PostType.camera:
                // Get Image From Camera
                await FileServices.getImageFromCamera();
                break;
              default:
                // Get Image From Gallery
                await FileServices.getImageFromGallery();
            }
          },
          title: Text("Image", style: medium18(colorThird)),
          trailing: const Icon(Custom.gallery, color: Colors.grey),
        ),
        // Video
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: margin),
          onTap: () async {
            switch (_postTypeBloc.state.type) {
              case PostType.camera:
                // Get Video From Camera
                await FileServices.getVideoFromCamera();
                break;
              default:
                // Get Video From Gallery
                await FileServices.getVideoFromGallery();
            }
          },
          title: Text("Video", style: medium18(colorThird)),
          trailing: const Icon(Icons.slow_motion_video, color: Colors.grey),
        ),
      ],
    );
  }
}
