import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stagemuse/assets/icons/custom_icons.dart';
import 'package:stagemuse/model/export_model.dart';
import 'package:stagemuse/services/export_services.dart';
import 'package:stagemuse/utils/export_utils.dart';
import 'package:stagemuse/view/export_view.dart';

class LikePostPage extends StatelessWidget {
  const LikePostPage({
    Key? key,
    required this.yourId,
  }) : super(key: key);
  final String yourId;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        adsServices.createAnchoredBanner(context);
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
            title: const Text("Liked posts"),
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
          body: StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.doc(yourId).snapshots(),
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

                return (user.likedPost!.isNotEmpty)
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            // Banner Ads
                            (adsServices.bannerAd != null)
                                ? SizedBox(
                                    width: adsServices.bannerAd!.size.width
                                        .toDouble(),
                                    height: adsServices.bannerAd!.size.height
                                        .toDouble(),
                                    child: AdWidget(ad: adsServices.bannerAd!),
                                  )
                                : const SizedBox(),
                            Column(
                              children: List.generate(
                                user.likedPost!.length,
                                (index) {
                                  // Object
                                  final likePost = user.likedPost![index];

                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: firestoreUser
                                        .doc(likePost['user id'])
                                        .collection('POST')
                                        .doc(likePost['post id'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else {
                                        if (snapshot.data!.exists) {
                                          // Object
                                          final map = snapshot.data!.data()
                                              as Map<String, dynamic>;
                                          final ImagePost? imagePost =
                                              (map['type'] == postTypeImage)
                                                  ? ImagePost.fromMap(map)
                                                  : null;
                                          final TextPost? textPost =
                                              (map['type'] == postTypeText)
                                                  ? TextPost.fromMap(map)
                                                  : null;

                                          return CardLikePostWidget(
                                            userId: likePost['user id'],
                                            imagePost: imagePost,
                                            textPost: textPost,
                                            postId: snapshot.data!.id,
                                            yourId: yourId,
                                          );
                                        } else {
                                          // Delete Like Post
                                          postServices.unLikePost(
                                            yourId: yourId,
                                            userId: likePost['user id'],
                                            postId: likePost['post id'],
                                          );

                                          return const SizedBox();
                                        }
                                      }
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          "Empty Post",
                          style: medium14(colorThird),
                        ),
                      );
              }
            },
          ),
        );
      },
    );
  }
}
