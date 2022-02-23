import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardStoryWidget extends StatefulWidget {
  const CardStoryWidget({
    Key? key,
    required this.yourId,
    required this.userId,
    required this.type,
    required this.index,
  }) : super(key: key);
  final String yourId;
  final String? userId;
  final StoryType type;
  final int index;

  const CardStoryWidget.own({
    Key? key,
    required this.yourId,
    required this.userId,
    this.type = StoryType.own,
    required this.index,
  }) : super(key: key);

  const CardStoryWidget.other({
    Key? key,
    required this.yourId,
    required this.userId,
    this.type = StoryType.other,
    required this.index,
  }) : super(key: key);

  @override
  _CardStoryWidgetState createState() => _CardStoryWidgetState();
}

class _CardStoryWidgetState extends State<CardStoryWidget> {
  // Variable
  bool empty = true, youSee = true;

  @override
  void initState() {
    super.initState();
    storyServices.checkStoryControl(
      own: (widget.type == StoryType.own) ? true : false,
      userId: (widget.type == StoryType.own) ? widget.yourId : widget.userId,
      yourId: widget.yourId,
      empty: () {
        if (mounted) {
          setState(() {
            empty = true;
          });
        }
      },
      notEmpty: () {
        if (mounted) {
          setState(() {
            empty = false;
          });
        }
      },
      youSee: () {
        if (mounted) {
          setState(() {
            youSee = true;
          });
        }
      },
      youNotSee: () {
        if (mounted) {
          setState(() {
            youSee = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final storyControl = context.read<StoryControllBloc>();

    return GestureDetector(
      onTap: () {
        if (widget.type == StoryType.own && empty) {
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
              return SetStoryFileTypeWidget(yourId: widget.yourId);
            },
          );
        } else {
          // Update bloc
          storyControl.add(
            SetStoryControll(
              activeSlideIndex: widget.index,
              storyId: null,
            ),
          );
          // Navigate
          Navigator.push(
            context,
            navigatorTo(
              context: context,
              screen: StoryPage(
                yourId: widget.yourId,
                userId: widget.userId ?? widget.yourId,
                type: widget.type,
                index: widget.index,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: margin),
        width: 80,
        child: Column(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                children: [
                  firstProfileWithStoryOrLiveNetworkUtils(
                    yourId: (widget.type == StoryType.own)
                        ? widget.yourId
                        : widget.userId!,
                    size: 56,
                    emptyStory: youSee,
                  ),
                  (widget.type == StoryType.own && empty)
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorSecondary,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 14,
                              color: colorThird,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(height: 4),
            (widget.type == StoryType.own)
                ? Text(
                    "Your Story",
                    style: medium12(colorThird),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : StreamBuilder<DocumentSnapshot>(
                    stream: firestoreUser.doc(widget.userId).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          "Loading...",
                          style: medium12(colorThird),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      } else {
                        // Object
                        final User user = User.fromMap(
                          snapshot.data!.data() as Map<String, dynamic>,
                        );
                        final DataProfile dataProfile =
                            DataProfile.fromMap(user.dataProfile!);

                        return Text(
                          "@${dataProfile.username}",
                          style: medium12(colorThird),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
