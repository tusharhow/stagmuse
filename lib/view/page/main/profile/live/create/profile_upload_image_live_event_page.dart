import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUploadImageLiveEventPage extends StatelessWidget {
  const ProfileUploadImageLiveEventPage({
    Key? key,
    required this.yourId,
    required this.liveId,
    required this.type,
  }) : super(key: key);
  final String liveId, yourId;
  final ProfileLiveEventType type;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _liveImage = context.watch<LiveImageBloc>();
    final _state = _liveImage.state;

    // Size Grid
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * 1 / 5;
    final double itemWidth = size.width / 3;
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(width: margin),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Custom.back),
            ),
          ],
        ),
        title: const Text("Upload Image"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorSecondary,
                colorPrimary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: (type == ProfileLiveEventType.create)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "Add photos to make them more interesting",
                      style: semiBold22(colorThird),
                    ),
                    // Subtitle
                    Text(
                      "Upload photos as interesting as possible, at least 4 photos to make the event look more attractive to users",
                      style: regular12(colorThird),
                    ),
                    const SizedBox(height: 32),
                    // Main Cover
                    Text(
                      "Main photo (cover)",
                      style: semiBold18(colorThird),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 1 / 2,
                      child: CardProfileUploadImageLiveEventWidget(
                        liveId: null,
                        yourId: null,
                        index: 0,
                        forCover: true,
                        memory: (_state.cover == null)
                            ? null
                            : _state.cover!.readAsBytes(),
                        network: null,
                        type: type,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // More Photos
                    Text(
                      "More photos (gallery)",
                      style: semiBold18(colorThird),
                    ),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      mainAxisSpacing: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        10,
                        (index) {
                          return CardProfileUploadImageLiveEventWidget(
                            liveId: null,
                            yourId: null,
                            index: index,
                            forCover: false,
                            memory: (_state.images.isEmpty)
                                ? null
                                : (index <= _state.images.length - 1)
                                    ? _state.images[index].readAsBytes()
                                    : null,
                            network: null,
                            type: type,
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: firestoreLive.doc(liveId).snapshots(),
              builder: (ocntext, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "Loading...",
                      style: medium14(colorThird),
                    ),
                  );
                } else {
                  // Object
                  final Live live = Live.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(margin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            "Add photos to make them more interesting",
                            style: semiBold22(colorThird),
                          ),
                          // Subtitle
                          Text(
                            "Upload photos as interesting as possible, at least 4 photos to make the event look more attractive to users",
                            style: regular12(colorThird),
                          ),
                          const SizedBox(height: 32),
                          // Main Cover
                          Text(
                            "Main photo (cover)",
                            style: semiBold18(colorThird),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 1 / 2,
                            child: CardProfileUploadImageLiveEventWidget(
                              liveId: snapshot.data!.id,
                              yourId: live.provider!,
                              index: 0,
                              forCover: true,
                              memory: null,
                              network: live.cover!,
                              type: type,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // More Photos
                          Text(
                            "More photos (gallery)",
                            style: semiBold18(colorThird),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            crossAxisSpacing: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                            mainAxisSpacing: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              10,
                              (index) {
                                return CardProfileUploadImageLiveEventWidget(
                                  liveId: snapshot.data!.id,
                                  yourId: live.provider!,
                                  index: index,
                                  forCover: false,
                                  memory: null,
                                  network: (live.images!.isEmpty)
                                      ? null
                                      : (index <= live.images!.length - 1)
                                          ? live.images![index]
                                          : null,
                                  type: type,
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
