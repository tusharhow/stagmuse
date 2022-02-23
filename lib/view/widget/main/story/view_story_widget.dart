import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:story_view/story_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final storyController = StoryController();

class ViewStoryWidget extends StatefulWidget {
  const ViewStoryWidget({
    Key? key,
    required this.type,
    required this.index,
    required this.userId,
  }) : super(key: key);
  final StoryType type;
  final int index;
  final String userId;

  @override
  _ViewStoryWidgetState createState() => _ViewStoryWidgetState();
}

class _ViewStoryWidgetState extends State<ViewStoryWidget> {
  // Controller
  final _controller1 = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    // Bloc
    final _storyBloc = context.read<StoryCommentBloc>();

    _storyBloc.add(const SetStoryComment(false));
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final storyControl = context.read<StoryControllBloc>();

    switch (widget.type) {
      case StoryType.other:
        return Expanded(
          child: StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(widget.userId).snapshots(),
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
                  final User user = User.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>,
                  );

                  return CarouselSlider.builder(
                    initialPage: storyControl.state.activeSlideIndex,
                    controller: _controller1,
                    slideBuilder: (index) {
                      final accountId = user.following![index];

                      return FutureBuilder<QuerySnapshot>(
                        future: firestoreUser
                            .doc(accountId)
                            .collection('STORY')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(
                                "Loading...",
                                style: medium14(colorThird),
                              ),
                            );
                          }
                          return StoryView(
                            progressPosition: ProgressPosition.top,
                            onComplete: () {
                              if (index == user.following!.length - 1) {
                                Navigator.pop(context);
                              } else {
                                _controller1.nextPage();
                              }
                            },
                            storyItems: List.generate(
                                snapshot.data!.docs.length, (index) {
                              // Object
                              final Story story = Story.fromMap(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>,
                              );

                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                storyServices.nextViewers(
                                  userId: accountId,
                                  yourId: widget.userId,
                                  storyId: snapshot.data!.docs[index].id,
                                );
                              });

                              return StoryItem(
                                ShowFileStoryWidget(
                                  storyId: snapshot.data!.docs[index].id,
                                  story: story,
                                  type: widget.type,
                                  userId: accountId,
                                  yourId: widget.userId,
                                ),
                                duration: const Duration(seconds: 5),
                              );
                            }).toList(),
                            controller: storyController,
                            inline: true,
                          );
                        },
                      );
                    },
                    itemCount: user.following!.length,
                    slideTransform: const CubeTransform(),
                  );
                }
              }),
        );
      default:
        return Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: firestoreUser.doc(widget.userId).collection('STORY').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    "Loading...",
                    style: medium14(colorThird),
                  ),
                );
              }
              return StoryView(
                progressPosition: ProgressPosition.top,
                onComplete: () {
                  Navigator.pop(context);
                },
                storyItems: List.generate(snapshot.data!.docs.length, (index) {
                  // Object
                  final Story story = Story.fromMap(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>,
                  );

                  final Story lastStory = Story.fromMap(
                    snapshot.data!.docs[snapshot.data!.docs.length - 1].data()
                        as Map<String, dynamic>,
                  );

                  if (story.youSee! && !lastStory.youSee!) {
                    storyController.next();
                  }

                  return StoryItem(
                    ShowFileStoryWidget(
                      storyId: snapshot.data!.docs[index].id,
                      story: story,
                      type: widget.type,
                      userId: widget.userId,
                      yourId: widget.userId,
                    ),
                    duration: const Duration(seconds: 5),
                  );
                }).toList(),
                controller: storyController,
                inline: true,
              );
            },
          ),
        );
    }
  }
}

class ShowFileStoryWidget extends StatelessWidget {
  const ShowFileStoryWidget({
    Key? key,
    required this.yourId,
    required this.storyId,
    required this.userId,
    required this.story,
    required this.type,
  }) : super(key: key);
  final String userId, yourId, storyId;
  final Story story;
  final StoryType type;

  @override
  Widget build(BuildContext context) {
    // Bloc
    final storyControl = context.read<StoryControllBloc>();

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // File Show
          CachedNetworkImage(
            imageUrl: story.url!,
            imageBuilder: (context, image) => Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Profile || Name || Time
          Padding(
            padding: const EdgeInsets.all(margin),
            child: StreamBuilder<DocumentSnapshot>(
                stream: firestoreUser.doc(userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    // Object
                    final User user = User.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    final DataProfile dataProfile =
                        DataProfile.fromMap(user.dataProfile!);

                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (storyControl.state.storyId != storyId) {
                        storyControl.add(
                          SetStoryControll(
                            activeSlideIndex:
                                storyControl.state.activeSlideIndex,
                            storyId: storyId,
                          ),
                        );

                        if (type == StoryType.own) {
                          storyServices.udpateSeeStory(
                            userId: userId,
                            storyId: storyId,
                          );
                        } else {
                          if (story.views!
                              .where((element) => element["user id"] == yourId)
                              .isEmpty) {
                            storyServices.udpateStoryViewer(
                              userId: userId,
                              storyId: storyId,
                              yourId: yourId,
                            );
                          }
                        }
                      }
                    });

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile
                        photoProfileNetworkUtils(
                          size: 36,
                          url: dataProfile.photo,
                        ),
                        const SizedBox(width: 12),
                        // Name || Time
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "@${dataProfile.username}",
                                style: bold14(colorThird),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Time
                              Text(
                                handlingTimeUtils(story.time!),
                                style: regular12(colorThird),
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
          ),
        ],
      ),
    );
  }
}
