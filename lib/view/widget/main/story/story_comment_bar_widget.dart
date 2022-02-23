import 'package:flutter/material.dart';
import 'package:stagemuse/bloc/export_bloc.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemuse/view/export_view.dart';

class StoryCommentBarWidget extends StatefulWidget {
  const StoryCommentBarWidget({
    Key? key,
    required this.yourId,
    required this.userId,
  }) : super(key: key);
  final String yourId, userId;

  @override
  _StoryCommentBarWidgetState createState() => _StoryCommentBarWidgetState();
}

class _StoryCommentBarWidgetState extends State<StoryCommentBarWidget> {
  // Controller
  final _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bloc
    final _storyBloc = context.read<StoryCommentBloc>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              margin,
              0,
              margin,
              MediaQuery.of(context).viewInsets.bottom,
            ),
            child: TextField(
              controller: _commentController,
              style: regular12(colorThird),
              onTap: () {
                storyController.pause();
                _storyBloc.add(const SetStoryComment(true));
              },
              onSubmitted: (_) async {
                _storyBloc.add(const SetStoryComment(false));
                if (_commentController.text.isNotEmpty) {
                  await chatServices
                      .addChat(
                    context: context,
                    fromCamera: false,
                    yourId: widget.yourId,
                    userId: widget.userId,
                    chatType: chatTypeStory,
                    message: _commentController.text,
                    from: chatFrom(widget.yourId),
                  )
                      .whenComplete(() {
                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: colorPrimary,
                        content: Text(
                          "Comments have been sent",
                          style: medium14(colorThird),
                        ),
                      ),
                    );
                  });
                }
                _commentController.clear();
                storyController.play();
              },
              decoration: InputDecoration(
                hintText: "Send Messages....",
                hintStyle: regular12(colorThird),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: colorThird),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: colorThird),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  borderSide: BorderSide(color: colorThird),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
