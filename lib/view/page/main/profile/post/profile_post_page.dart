import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class ProfilePostPage extends StatefulWidget {
  const ProfilePostPage({
    Key? key,
    required this.postIndex,
    required this.type,
    required this.userId,
  }) : super(key: key);
  final int postIndex;
  final ProfilePageType type;
  final String userId;

  @override
  _ProfilePostPageState createState() => _ProfilePostPageState();
}

class _ProfilePostPageState extends State<ProfilePostPage> {
  // Controller
  final scroll = ItemScrollController();

  @override
  Widget build(BuildContext context) {
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
        title: // User name
            StreamBuilder<DocumentSnapshot>(
          stream: firestoreUser.doc(widget.userId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading...");
            } else {
              // Object
              final User user =
                  User.fromMap(snapshot.data!.data() as Map<String, dynamic>);

              final DataProfile dataProfile =
                  DataProfile.fromMap(user.dataProfile!);

              return Text("@${dataProfile.username}");
            }
          },
        ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreUser
            .doc(widget.userId)
            .collection('POST')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Loading...',
                style: medium14(colorThird),
              ),
            );
          }
          return (snapshot.data!.docs.isNotEmpty)
              ? ScrollablePositionedList.builder(
                  itemScrollController: scroll,
                  initialScrollIndex: widget.postIndex,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // Object
                    final map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final ImagePost? imagePost = (map['type'] == postTypeImage)
                        ? ImagePost.fromMap(map)
                        : null;
                    final TextPost? textPost = (map['type'] == postTypeText)
                        ? TextPost.fromMap(map)
                        : null;

                    return Column(
                      children: [
                        (imagePost != null)
                            ? (imagePost.images!.length < 2)
                                ? Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                      bottom: (snapshot.data!.docs[index].id ==
                                              snapshot.data!.docs.last.id)
                                          ? 16
                                          : 0,
                                    ),
                                    child: CardSinglePostImageWidget(
                                      yourId: widget.userId,
                                      postId: snapshot.data!.docs[index].id,
                                      type: widget.type,
                                      imagePost: imagePost,
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                      top: 16,
                                      bottom: (snapshot.data!.docs[index].id ==
                                              snapshot.data!.docs.last.id)
                                          ? 16
                                          : 0,
                                    ),
                                    child: CardMultiPostImageWidget(
                                      yourId: widget.userId,
                                      postId: snapshot.data!.docs[index].id,
                                      imagePost: imagePost,
                                      type: widget.type,
                                    ),
                                  )
                            : Container(
                                margin: EdgeInsets.only(
                                  top: 16,
                                  bottom: (snapshot.data!.docs[index].id ==
                                          snapshot.data!.docs.last.id)
                                      ? 16
                                      : 0,
                                ),
                                child: CardPostTextWidget(
                                  yourId: widget.userId,
                                  postId: snapshot.data!.docs[index].id,
                                  textPost: textPost ?? TextPost(),
                                  type: widget.type,
                                ),
                              )
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Empty Post',
                    style: medium14(colorThird),
                  ),
                );
        },
      ),
    );
  }
}
