import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ButtonSeeStoryViewerWidget extends StatelessWidget {
  const ButtonSeeStoryViewerWidget({
    Key? key,
    required this.storyId,
    required this.userId,
  }) : super(key: key);
  final String userId;
  final String? storyId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        storyController.pause();
        // Show Bottom Sheet
        showModalBottomSheet(
          backgroundColor: colorBackground,
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 24,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          context: context,
          builder: (context) {
            return SetStoryViewerWidget(
              storyId: storyId!,
              userId: userId,
            );
          },
        ).whenComplete(() => storyController.play());
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.remove_red_eye, color: colorThird),
                const SizedBox(width: 8),
                (storyId != null)
                    ? StreamBuilder<DocumentSnapshot>(
                        stream: firestoreUser
                            .doc(userId)
                            .collection("STORY")
                            .doc(storyId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              "Loading...",
                              style: regular18(colorThird),
                            );
                          } else {
                            if (snapshot.data != null) {
                              final Story story = Story.fromMap(snapshot.data!
                                  .data() as Map<String, dynamic>);

                              return Text(
                                "${story.views!.length}",
                                style: regular18(colorThird),
                              );
                            }

                            return Text(
                              "Loading...",
                              style: regular18(colorThird),
                            );
                          }
                        },
                      )
                    : Text(
                        "Loading...",
                        style: regular18(colorThird),
                      ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class SetStoryViewerWidget extends StatelessWidget {
  const SetStoryViewerWidget({
    Key? key,
    required this.userId,
    required this.storyId,
  }) : super(key: key);
  final String userId, storyId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: StreamBuilder<DocumentSnapshot>(
          stream: firestoreUser
              .doc(userId)
              .collection("STORY")
              .doc(storyId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: margin,
                      vertical: 18,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorSecondary,
                          colorPrimary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.clear, color: colorThird),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Loading...",
                          style: medium18(colorThird),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(child: Container()),
                ],
              );
            } else {
              // Object
              final Story story =
                  Story.fromMap(snapshot.data!.data() as Map<String, dynamic>);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: margin,
                      vertical: 18,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorSecondary,
                          colorPrimary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.clear, color: colorThird),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${story.views!.length} views",
                          style: medium18(colorThird),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return confirmationDialog(
                                  content: Text(
                                    "Are you sure you want to delete this story?",
                                    style: medium14(colorThird),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    flatTextButton(
                                      onPress: () {
                                        storyServices.deleteStory(
                                            userId: userId, storyId: storyId);

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          navigatorTo(
                                            context: context,
                                            screen: const LandingPage(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      text: "Yes",
                                      textColor: colorThird,
                                      buttonColor: colorPrimary,
                                      leftMargin: 0,
                                      rightMargin: 0,
                                      topMargin: 0,
                                      bottomMargin: 0,
                                      width: null,
                                      height: null,
                                    ),
                                    flatTextButton(
                                      onPress: () {
                                        // Back
                                        Navigator.pop(context);
                                      },
                                      text: "No",
                                      textColor: colorThird,
                                      buttonColor: colorPrimary,
                                      leftMargin: 0,
                                      rightMargin: 0,
                                      topMargin: 0,
                                      bottomMargin: 0,
                                      width: null,
                                      height: null,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Custom.delete,
                            color: colorThird,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: story.views!.map((data) {
                          // Object
                          final StoryViewers viewers =
                              StoryViewers.fromMap(data);

                          return CardStoryViewerWidget(storyViewers: viewers);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}

class CardStoryViewerWidget extends StatelessWidget {
  const CardStoryViewerWidget({
    Key? key,
    required this.storyViewers,
  }) : super(key: key);
  final StoryViewers storyViewers;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      padding: const EdgeInsets.symmetric(horizontal: margin, vertical: 12),
      child: StreamBuilder<DocumentSnapshot>(
          stream: firestoreUser.doc(storyViewers.userId!).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "Loading...",
                  style: medium14(colorThird),
                ),
              );
            } else {
              // Object
              final User user =
                  User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
              final DataProfile dataProfile =
                  DataProfile.fromMap(user.dataProfile!);

              return Row(
                children: [
                  // Profile
                  photoProfileNetworkUtils(
                    size: 36,
                    url: dataProfile.photo,
                  ),
                  const SizedBox(width: 8),
                  // User name || Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${dataProfile.username}",
                          style: semiBold14(colorThird),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          handlingTimeUtils(storyViewers.time!),
                          style: regular12(Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
