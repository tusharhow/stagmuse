import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';

enum CommentBarType { blank, reply }

// Post Comment
class CommentBarWidget extends StatefulWidget {
  const CommentBarWidget({
    Key? key,
    required this.type,
    this.username,
    this.commentId,
    required this.userId,
    required this.postId,
    required this.yourId,
  }) : super(key: key);
  final CommentBarType type;
  final String userId, yourId, postId;
  final String? username, commentId;

  const CommentBarWidget.blank({
    Key? key,
    this.type = CommentBarType.blank,
    this.username = "",
    this.commentId = "",
    required this.userId,
    required this.postId,
    required this.yourId,
  }) : super(key: key);

  const CommentBarWidget.reply({
    Key? key,
    this.type = CommentBarType.reply,
    required this.username,
    required this.commentId,
    required this.userId,
    required this.postId,
    required this.yourId,
  }) : super(key: key);

  @override
  _CommentBarWidgetState createState() => _CommentBarWidgetState();
}

class _CommentBarWidgetState extends State<CommentBarWidget> {
  bool _send = false;

  // Controller
  final _barController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.type == CommentBarType.reply) {
      _barController.text = widget.username!;
    }

    _barController.addListener(() {
      if (_barController.text.isNotEmpty) {
        if (!_send) {
          setState(() {
            _send = true;
          });
        }
      }
      if (_barController.text.isEmpty) {
        if (_send) {
          setState(() {
            _send = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _barController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 0.5, color: colorPrimary),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 1 / 4,
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.doc(widget.yourId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                final User user =
                    User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                final DataProfile dataProfile =
                    DataProfile.fromMap(user.dataProfile!);

                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: margin, vertical: 0),
                  child: Row(
                    children: [
                      photoProfileNetworkUtils(
                        size: 24,
                        url: dataProfile.photo,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          maxLines: null,
                          controller: _barController,
                          style: regular12(colorThird),
                          onEditingComplete: () {
                            Navigator.pop(context);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Add Comments...",
                            hintStyle: regular12(Colors.grey),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_barController.text.isNotEmpty) {
                            if (widget.type == CommentBarType.blank) {
                              postServices.addComment(
                                userId: widget.userId,
                                postId: widget.postId,
                                comment: _barController.text,
                                yourId: widget.yourId,
                              );
                            } else {
                              postServices.replyComment(
                                userId: widget.userId,
                                postId: widget.postId,
                                commentId: widget.commentId!,
                                comment: _barController.text,
                                yourId: widget.yourId,
                              );
                            }
                          }
                          _barController.clear();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Send",
                          style: medium14(
                            (_send)
                                ? colorPrimary
                                : colorPrimary.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

// Chat
class ChatBarWidget extends StatefulWidget {
  const ChatBarWidget({
    Key? key,
    required this.userId,
    required this.yourId,
  }) : super(key: key);
  final String userId, yourId;

  @override
  _ChatBarWidgetState createState() => _ChatBarWidgetState();
}

class _ChatBarWidgetState extends State<ChatBarWidget> {
  // Controller
  final _chatController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 56,
        maxHeight: MediaQuery.of(context).size.height * 1 / 4,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: colorSecondary,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: margin, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: margin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Camera
            GestureDetector(
              onTap: () async {
                await chatServices.addChat(
                  context: context,
                  fromCamera: true,
                  yourId: widget.yourId,
                  userId: widget.userId,
                  chatType: chatTypeImage,
                  message: _chatController.text,
                  from: chatFrom(widget.yourId),
                );
              },
              child: const Icon(Custom.camera, color: colorThird),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: TextField(
                keyboardType: TextInputType.text,
                maxLines: null,
                controller: _chatController,
                style: regular12(colorThird),
                onSubmitted: (_) async {
                  if (_chatController.text.isNotEmpty) {
                    await chatServices.addChat(
                      context: context,
                      fromCamera: false,
                      yourId: widget.yourId,
                      userId: widget.userId,
                      chatType: chatTypeText,
                      message: _chatController.text,
                      from: chatFrom(widget.yourId),
                    );

                    _chatController.clear();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Message...",
                  hintStyle: regular12(colorThird),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Gallery
            GestureDetector(
              onTap: () async {
                await chatServices.addChat(
                  context: context,
                  fromCamera: false,
                  yourId: widget.yourId,
                  userId: widget.userId,
                  chatType: chatTypeImage,
                  message: _chatController.text,
                  from: chatFrom(widget.yourId),
                );
              },
              child: const Icon(Custom.picture, color: colorThird),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
