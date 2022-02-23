import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

// Image
class CardSinglePostImageWidget extends StatelessWidget {
  const CardSinglePostImageWidget({
    Key? key,
    required this.yourId,
    required this.postId,
    required this.type,
    required this.imagePost,
  }) : super(key: key);
  final String postId, yourId;
  final ProfilePageType type;
  final ImagePost imagePost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 4),
            color: colorThird.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile || Name || Time or Delete
          StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.doc(imagePost.yourId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                // Object
                final User user =
                    User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                final DataProfile dataProfile =
                    DataProfile.fromMap(user.dataProfile!);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: margin),
                  child: Row(
                    children: [
                      // Profile
                      photoProfileNetworkUtils(
                        size: 36,
                        url: dataProfile.photo,
                      ),
                      const SizedBox(width: 12),
                      // Name || Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            GestureDetector(
                              onTap: () {
                                if (type == ProfilePageType.other) {
                                  // Navigate
                                  Navigator.push(
                                    context,
                                    navigatorTo(
                                      context: context,
                                      screen: ProfilePage.other(
                                        yourId: yourId,
                                        userId: imagePost.yourId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "@${dataProfile.username}",
                                style: semiBold14(colorThird),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Time
                            Text(
                              handlingTimeUtils(imagePost.time!),
                              style: regular12(Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Delete
                      const SizedBox(width: 8),
                      (type == ProfilePageType.own)
                          ? PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert_outlined,
                                color: colorThird,
                              ),
                              onSelected: (_) {
                                // Show Confirmation Dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return confirmationDialog(
                                      content: Text(
                                        "Are you sure you want to delete this post?",
                                        style: medium14(colorThird),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        flatTextButton(
                                          onPress: () {
                                            postServices.deletePost(
                                                yourId: yourId, postId: postId);
                                            Navigator.pop(context);
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
                                        flatOutlineTextButton(
                                          onPress: () {
                                            Navigator.pop(context);
                                          },
                                          text: "No",
                                          textColor: colorPrimary,
                                          borderColor: colorPrimary,
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
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  child: Text("Delete"),
                                  value: "Delete",
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          // Content
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1 / 3,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              image: DecorationImage(
                image: NetworkImage(imagePost.images![0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Button Like || Comment || Share or Save
          Padding(
            padding: const EdgeInsets.only(left: margin, right: margin),
            child: Row(
              children: [
                // Like
                FavoriteButtonPostWidget(
                  yourId: yourId,
                  postId: postId,
                  userId: imagePost.yourId!,
                  postFrom: imagePost.yourId!,
                ),
                const SizedBox(width: 12),
                // Comment
                GestureDetector(
                  onTap: () {
                    // Navigate
                    Navigator.push(
                      context,
                      navigatorTo(
                        context: context,
                        screen: PostCommentPage(
                          postId: postId,
                          userId: imagePost.yourId!,
                          yourId: yourId,
                        ),
                      ),
                    );
                  },
                  child:
                      const Icon(Custom.comment, size: 20, color: colorThird),
                ),
                const SizedBox(width: 12),
                // Share
                //GestureDetector(
                //  onTap: () {},
                //  child:
                //      const Icon(Custom.forward, size: 20, color: colorThird),
                //),
                const Spacer(),
                // Save
                (type == ProfilePageType.other)
                    ? SaveButtonPostWidget(
                        yourId: yourId,
                        postId: postId,
                        userId: imagePost.yourId!,
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Like
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: margin),
            child: Text(
              "${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(imagePost.likes!.length)} likes",
              style: medium12(colorThird),
            ),
          ),
          // User name || Description || Total Comments
          StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(imagePost.yourId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: margin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User name
                        GestureDetector(
                          onTap: () {
                            if (type == ProfilePageType.other) {
                              // Navigate
                              Navigator.push(
                                context,
                                navigatorTo(
                                  context: context,
                                  screen: ProfilePage.other(
                                    yourId: yourId,
                                    userId: imagePost.yourId,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "@${dataProfile.username}",
                            style: semiBold14(colorThird),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Description
                        ReadMoreText(
                          imagePost.description!,
                          trimLines: 3,
                          style: regular14(colorThird),
                          colorClickableText: colorPrimary,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'other',
                          trimExpandedText: '',
                          moreStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        // Comment
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Navigate
                            Navigator.push(
                              context,
                              navigatorTo(
                                context: context,
                                screen: PostCommentPage(
                                  postId: postId,
                                  userId: imagePost.yourId!,
                                  yourId: yourId,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See all ${imagePost.totalComment} comments",
                            style: regular12(Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
          // Add Comment
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return CommentBarWidget.blank(
                    postId: postId,
                    userId: imagePost.yourId!,
                    yourId: yourId,
                  );
                },
              );
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(yourId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);
                  {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: margin),
                      child: Row(
                        children: [
                          photoProfileNetworkUtils(
                            size: 24,
                            url: dataProfile.photo,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Add comments...",
                            style: regular12(Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardMultiPostImageWidget extends StatelessWidget {
  const CardMultiPostImageWidget({
    Key? key,
    required this.yourId,
    required this.postId,
    required this.imagePost,
    required this.type,
  }) : super(key: key);
  final String postId, yourId;
  final ProfilePageType type;
  final ImagePost imagePost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 4),
            color: colorThird.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile || Name || Time or Delete
          StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.doc(imagePost.yourId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                // Object
                final User user =
                    User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                final DataProfile dataProfile =
                    DataProfile.fromMap(user.dataProfile!);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: margin),
                  child: Row(
                    children: [
                      // Profile
                      photoProfileNetworkUtils(
                        size: 36,
                        url: dataProfile.photo,
                      ),
                      const SizedBox(width: 12),
                      // Name || Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            GestureDetector(
                              onTap: () {
                                if (type == ProfilePageType.other) {
                                  // Navigate
                                  Navigator.push(
                                    context,
                                    navigatorTo(
                                      context: context,
                                      screen: ProfilePage.other(
                                        yourId: yourId,
                                        userId: imagePost.yourId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "@${dataProfile.username}",
                                style: semiBold14(colorThird),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Time
                            Text(
                              handlingTimeUtils(imagePost.time!),
                              style: regular12(Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Delete
                      const SizedBox(width: 8),
                      (type == ProfilePageType.own)
                          ? PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert_outlined,
                                color: colorThird,
                              ),
                              onSelected: (_) {
                                // Show Confirmation Dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return confirmationDialog(
                                      content: Text(
                                        "Are you sure you want to delete this post?",
                                        style: medium14(colorThird),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        flatTextButton(
                                          onPress: () {
                                            postServices.deletePost(
                                              yourId: yourId,
                                              postId: postId,
                                            );
                                            Navigator.pop(context);
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
                                        flatOutlineTextButton(
                                          onPress: () {
                                            Navigator.pop(context);
                                          },
                                          text: "No",
                                          textColor: colorPrimary,
                                          borderColor: colorPrimary,
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
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  child: Text("Delete"),
                                  value: "Delete",
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          // Content
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1 / 3,
            child: CarouselSlider.builder(
              slideBuilder: (index) {
                // Url
                final url = imagePost.images![index];

                return Image.network(
                  url,
                  fit: BoxFit.cover,
                );
              },
              slideIndicator: CircularSlideIndicator(
                padding: const EdgeInsets.only(bottom: 8),
                currentIndicatorColor: colorPrimary,
                indicatorRadius: 4,
                itemSpacing: 10,
              ),
              itemCount: imagePost.images!.length,
            ),
          ),
          // Button Like || Comment || Share or Save
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: margin, right: margin),
            child: Row(
              children: [
                // Like
                FavoriteButtonPostWidget(
                  yourId: yourId,
                  postId: postId,
                  userId: imagePost.yourId!,
                  postFrom: imagePost.yourId!,
                ),
                const SizedBox(width: 12),
                // Comment
                GestureDetector(
                  onTap: () {
                    // Navigate
                    Navigator.push(
                      context,
                      navigatorTo(
                        context: context,
                        screen: PostCommentPage(
                          postId: postId,
                          userId: imagePost.yourId!,
                          yourId: yourId,
                        ),
                      ),
                    );
                  },
                  child:
                      const Icon(Custom.comment, size: 20, color: colorThird),
                ),
                const SizedBox(width: 12),
                // Share
                //GestureDetector(
                //  onTap: () {},
                //  child:
                //      const Icon(Custom.forward, size: 20, color: colorThird),
                //),
                const Spacer(),
                // Save
                (type == ProfilePageType.other)
                    ? SaveButtonPostWidget(
                        yourId: yourId,
                        postId: postId,
                        userId: imagePost.yourId!,
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Like
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: margin),
            child: Text(
              "${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(imagePost.likes!.length)} likes",
              style: medium12(colorThird),
            ),
          ),
          // User name || Description || Total Comments
          StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(imagePost.yourId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: margin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User name
                        GestureDetector(
                          onTap: () {
                            if (type == ProfilePageType.other) {
                              // Navigate
                              Navigator.push(
                                context,
                                navigatorTo(
                                  context: context,
                                  screen: ProfilePage.other(
                                    yourId: yourId,
                                    userId: imagePost.yourId,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "@${dataProfile.username}",
                            style: semiBold14(colorThird),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Description
                        ReadMoreText(
                          imagePost.description!,
                          trimLines: 3,
                          style: regular14(colorThird),
                          colorClickableText: colorPrimary,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'other',
                          trimExpandedText: '',
                          moreStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        // Comment
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Navigate
                            Navigator.push(
                              context,
                              navigatorTo(
                                context: context,
                                screen: PostCommentPage(
                                  postId: postId,
                                  userId: imagePost.yourId!,
                                  yourId: yourId,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See all ${imagePost.totalComment} comments",
                            style: regular12(Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
          // Add Comment
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return CommentBarWidget.blank(
                    postId: postId,
                    userId: imagePost.yourId!,
                    yourId: yourId,
                  );
                },
              );
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(yourId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);
                  {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: margin),
                      child: Row(
                        children: [
                          photoProfileNetworkUtils(
                            size: 24,
                            url: dataProfile.photo,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Add comments...",
                            style: regular12(Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Text
class CardPostTextWidget extends StatelessWidget {
  const CardPostTextWidget({
    Key? key,
    required this.yourId,
    required this.postId,
    required this.type,
    required this.textPost,
  }) : super(key: key);
  final String postId, yourId;
  final ProfilePageType type;
  final TextPost textPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 4),
            color: colorThird.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile || Name || Time or Delete
          StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.doc(textPost.yourId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                // Object
                final User user =
                    User.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                final DataProfile dataProfile =
                    DataProfile.fromMap(user.dataProfile!);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: margin),
                  child: Row(
                    children: [
                      // Profile
                      photoProfileNetworkUtils(
                        size: 36,
                        url: dataProfile.photo,
                      ),
                      const SizedBox(width: 12),
                      // Name || Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            GestureDetector(
                              onTap: () {
                                if (type == ProfilePageType.other) {
                                  // Navigate
                                  Navigator.push(
                                    context,
                                    navigatorTo(
                                      context: context,
                                      screen: ProfilePage.other(
                                        yourId: yourId,
                                        userId: textPost.yourId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "@${dataProfile.username}",
                                style: semiBold14(colorThird),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Time
                            Text(
                              handlingTimeUtils(textPost.time!),
                              style: regular12(Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Delete
                      const SizedBox(width: 8),
                      (type == ProfilePageType.own)
                          ? PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert_outlined,
                                color: colorThird,
                              ),
                              onSelected: (_) {
                                // Show Confirmation Dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return confirmationDialog(
                                      content: Text(
                                        "Are you sure you want to delete this post?",
                                        style: medium14(colorThird),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        flatTextButton(
                                          onPress: () {
                                            postServices.deletePost(
                                              yourId: yourId,
                                              postId: postId,
                                            );
                                            Navigator.pop(context);
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
                                        flatOutlineTextButton(
                                          onPress: () {
                                            Navigator.pop(context);
                                          },
                                          text: "No",
                                          textColor: colorPrimary,
                                          borderColor: colorPrimary,
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
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  child: Text("Delete"),
                                  value: "Delete",
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: margin),
            child: Text(
              textPost.status!,
              style: medium14(colorThird),
            ),
          ),
          const SizedBox(height: 16),
          // Button Like || Comment || Share or Save
          Padding(
            padding: const EdgeInsets.only(left: margin, right: margin),
            child: Row(
              children: [
                // Like
                FavoriteButtonPostWidget(
                  yourId: yourId,
                  postId: postId,
                  userId: textPost.yourId!,
                  postFrom: textPost.yourId!,
                ),
                const SizedBox(width: 12),
                // Comment
                GestureDetector(
                  onTap: () {
                    // Navigate
                    Navigator.push(
                      context,
                      navigatorTo(
                        context: context,
                        screen: PostCommentPage(
                          postId: postId,
                          userId: textPost.yourId!,
                          yourId: yourId,
                        ),
                      ),
                    );
                  },
                  child:
                      const Icon(Custom.comment, size: 20, color: colorThird),
                ),
                const SizedBox(width: 12),
                // Share
                //GestureDetector(
                //  onTap: () {},
                //  child:
                //      const Icon(Custom.forward, size: 20, color: colorThird),
                //),
                const Spacer(),
                // Save
                (type == ProfilePageType.other)
                    ? SaveButtonPostWidget(
                        yourId: yourId,
                        postId: postId,
                        userId: textPost.yourId!,
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Like
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: margin),
            child: Text(
              "${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(textPost.likes!.length)} likes",
              style: medium12(colorThird),
            ),
          ),
          const SizedBox(height: 8),
          // Total Comments
          GestureDetector(
            onTap: () {
              // Navigate
              Navigator.push(
                context,
                navigatorTo(
                  context: context,
                  screen: PostCommentPage(
                    postId: postId,
                    userId: textPost.yourId!,
                    yourId: yourId,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: margin),
              child: Text(
                "See all ${textPost.totalComment} comments",
                style: regular12(Colors.grey),
              ),
            ),
          ),
          // Add Comment
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (context) {
                  return CommentBarWidget.blank(
                    postId: postId,
                    userId: textPost.yourId!,
                    yourId: yourId,
                  );
                },
              );
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.doc(yourId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  // Object
                  final User user = User.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);
                  final DataProfile dataProfile =
                      DataProfile.fromMap(user.dataProfile!);
                  {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: margin),
                      child: Row(
                        children: [
                          photoProfileNetworkUtils(
                            size: 24,
                            url: dataProfile.photo,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Add comments...",
                            style: regular12(Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
