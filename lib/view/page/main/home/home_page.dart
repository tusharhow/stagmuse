import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (!adsServices.loadAnchoredBanner) {
          adsServices.setLoadBanner(true);
          adsServices.createAnchoredBanner(context);
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "STAGEMUSE",
              style: semiBold22(colorThird),
            ),
            actions: [
              ChatButtonWidget(yourId: yourId),
              const SizedBox(width: margin),
            ],
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Banner Ads
                (adsServices.bannerAd != null)
                    ? SizedBox(
                        width: adsServices.bannerAd!.size.width.toDouble(),
                        height: adsServices.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: adsServices.bannerAd!),
                      )
                    : const SizedBox(),
                // Story
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: margin),
                      // Own
                      CardStoryWidget.own(
                        index: 0,
                        yourId: yourId,
                        userId: null,
                      ),
                      const SizedBox(width: 8),
                      // Other
                      StreamBuilder<DocumentSnapshot>(
                        stream: firestoreUser.doc(yourId).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            final User user = User.fromMap(
                                snapshot.data!.data() as Map<String, dynamic>);

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  user.following!.length,
                                  (index) {
                                    final accountId = user.following![index];

                                    return Row(
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                          stream: firestoreUser
                                              .doc(accountId)
                                              .collection('STORY')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            } else {
                                              if (snapshot
                                                  .data!.docs.isNotEmpty) {
                                                return Row(
                                                  children: [
                                                    // Unsee Story
                                                    (snapshot.data!.docs
                                                            .where((_) {
                                                      final Story storyLast =
                                                          Story.fromMap(
                                                              snapshot.data!
                                                                      .docs.last
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>);

                                                      return storyLast.views!
                                                          .where((view) =>
                                                              view["user id"] ==
                                                              yourId)
                                                          .isEmpty;
                                                    }).isNotEmpty)
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 8,
                                                            ),
                                                            child:
                                                                CardStoryWidget
                                                                    .other(
                                                              index: index,
                                                              yourId: yourId,
                                                              userId: accountId,
                                                            ),
                                                          )
                                                        : Container(),

                                                    // See Story
                                                    (snapshot.data!.docs
                                                            .where((_) {
                                                      final Story storyLast =
                                                          Story.fromMap(
                                                              snapshot.data!
                                                                      .docs.last
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>);

                                                      return storyLast.views!
                                                          .where((view) =>
                                                              view["user id"] ==
                                                              yourId)
                                                          .isNotEmpty;
                                                    }).isNotEmpty)
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 8,
                                                            ),
                                                            child:
                                                                CardStoryWidget
                                                                    .other(
                                                              index: index,
                                                              yourId: yourId,
                                                              userId: accountId,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: margin),
                    ],
                  ),
                ),
                Container(height: 0.5, color: colorPrimary),
                const SizedBox(height: 16),
                // Posts
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreFeed.orderBy('time').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    return (snapshot.data!.docs.isNotEmpty)
                        ? Column(
                            children: snapshot.data!.docs.map(
                              (docFeed) {
                                // Object
                                final map =
                                    docFeed.data() as Map<String, dynamic>;

                                return StreamBuilder<DocumentSnapshot>(
                                  stream: firestoreUser.doc(yourId).snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox();
                                    } else {
                                      final User user = User.fromMap(
                                        snapshot.data!.data()
                                            as Map<String, dynamic>,
                                      );
                                      return (user.following!
                                              .where((id) => id == docFeed.id)
                                              .isNotEmpty)
                                          ? StreamBuilder<DocumentSnapshot>(
                                              stream: firestoreUser
                                                  .doc(docFeed.id)
                                                  .collection('POST')
                                                  .doc(map['post id'])
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const SizedBox();
                                                } else {
                                                  // Object
                                                  final map = snapshot.data!
                                                          .data()
                                                      as Map<String, dynamic>;
                                                  final ImagePost? imagePost =
                                                      (map['type'] ==
                                                              postTypeImage)
                                                          ? ImagePost.fromMap(
                                                              map)
                                                          : null;
                                                  final TextPost? textPost =
                                                      (map['type'] ==
                                                              postTypeText)
                                                          ? TextPost.fromMap(
                                                              map)
                                                          : null;

                                                  if ((imagePost != null)) {
                                                    return (imagePost.images!
                                                                .length <
                                                            2)
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              bottom: 16,
                                                            ),
                                                            child:
                                                                CardSinglePostImageWidget(
                                                              yourId: yourId,
                                                              postId: snapshot
                                                                  .data!.id,
                                                              type: (snapshot
                                                                          .data!
                                                                          .id ==
                                                                      yourId)
                                                                  ? ProfilePageType
                                                                      .own
                                                                  : ProfilePageType
                                                                      .other,
                                                              imagePost:
                                                                  imagePost,
                                                            ),
                                                          )
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              bottom: 16,
                                                            ),
                                                            child:
                                                                CardMultiPostImageWidget(
                                                              yourId: yourId,
                                                              postId: snapshot
                                                                  .data!.id,
                                                              imagePost:
                                                                  imagePost,
                                                              type: (snapshot
                                                                          .data!
                                                                          .id ==
                                                                      yourId)
                                                                  ? ProfilePageType
                                                                      .own
                                                                  : ProfilePageType
                                                                      .other,
                                                            ),
                                                          );
                                                  } else {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        bottom: 16,
                                                      ),
                                                      child: CardPostTextWidget(
                                                        yourId: yourId,
                                                        postId:
                                                            snapshot.data!.id,
                                                        textPost: textPost ??
                                                            TextPost(),
                                                        type: (docFeed.id ==
                                                                yourId)
                                                            ? ProfilePageType
                                                                .own
                                                            : ProfilePageType
                                                                .other,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                            )
                                          : (docFeed.id == yourId)
                                              ? StreamBuilder<DocumentSnapshot>(
                                                  stream: firestoreUser
                                                      .doc(yourId)
                                                      .collection('POST')
                                                      .doc(map['post id'])
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const SizedBox();
                                                    } else {
                                                      if (snapshot
                                                          .data!.exists) {
                                                        // Object
                                                        final map = snapshot
                                                                .data!
                                                                .data()
                                                            as Map<String,
                                                                dynamic>;
                                                        final ImagePost?
                                                            imagePost =
                                                            (map['type'] ==
                                                                    postTypeImage)
                                                                ? ImagePost
                                                                    .fromMap(
                                                                        map)
                                                                : null;
                                                        final TextPost?
                                                            textPost =
                                                            (map['type'] ==
                                                                    postTypeText)
                                                                ? TextPost
                                                                    .fromMap(
                                                                        map)
                                                                : null;

                                                        return (imagePost !=
                                                                null)
                                                            ? (imagePost.images!
                                                                        .length <
                                                                    2)
                                                                ? Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          16,
                                                                    ),
                                                                    child:
                                                                        CardSinglePostImageWidget(
                                                                      yourId:
                                                                          yourId,
                                                                      postId: snapshot
                                                                          .data!
                                                                          .id,
                                                                      type: (snapshot.data!.id ==
                                                                              yourId)
                                                                          ? ProfilePageType
                                                                              .own
                                                                          : ProfilePageType
                                                                              .other,
                                                                      imagePost:
                                                                          imagePost,
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          16,
                                                                    ),
                                                                    child:
                                                                        CardMultiPostImageWidget(
                                                                      yourId:
                                                                          yourId,
                                                                      postId: snapshot
                                                                          .data!
                                                                          .id,
                                                                      imagePost:
                                                                          imagePost,
                                                                      type: (snapshot.data!.id ==
                                                                              yourId)
                                                                          ? ProfilePageType
                                                                              .own
                                                                          : ProfilePageType
                                                                              .other,
                                                                    ),
                                                                  )
                                                            : Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: 16,
                                                                ),
                                                                child:
                                                                    CardPostTextWidget(
                                                                  yourId:
                                                                      yourId,
                                                                  postId:
                                                                      snapshot
                                                                          .data!
                                                                          .id,
                                                                  textPost:
                                                                      textPost ??
                                                                          TextPost(),
                                                                  type: (docFeed
                                                                              .id ==
                                                                          yourId)
                                                                      ? ProfilePageType
                                                                          .own
                                                                      : ProfilePageType
                                                                          .other,
                                                                ),
                                                              );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    }
                                                  },
                                                )
                                              : const SizedBox();
                                    }
                                  },
                                );
                              },
                            ).toList(),
                          )
                        : const SizedBox();
                  },
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        );
      },
    );
  }
}
